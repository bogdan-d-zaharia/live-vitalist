import 'package:flutter/foundation.dart';
import 'package:live_vitalist/features/aliment_bank/domain/aliment_bank_state.dart';
import 'package:live_vitalist/features/aliment_bank/domain/aliment_bank_constants.dart';
import 'package:live_vitalist/features/aliment/domain/aliment_data.dart';
import 'package:live_vitalist/core/storage/data/storage_provider.dart';
import 'package:live_vitalist/features/aliment_bank/domain/aliment_catalog.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'aliment_bank.g.dart';

@Riverpod(keepAlive: true)
class AlimentOrder extends _$AlimentOrder {
  @override
  Set<String> build() => {};

  void load(AlimentBankState bank) => state = bank.order.toSet();

  void setFirst(String id) async => state = {id, ...state};
}

@Riverpod(keepAlive: true)
class CustomAliments extends _$CustomAliments {
  @override
  Map<String, AlimentData> build() => {};

  void load(AlimentBankState bank) => state = bank.aliments;

  void setAliment(String id, AlimentData data) {
    if (id.split('-').length > 1) return;
    state = {...state, id: data};
    ref.read(alimentOrderProvider.notifier).setFirst(id);
  }
}

@Riverpod(keepAlive: true)
class AlimentCatalogs extends _$AlimentCatalogs {
  @override
  Map<String, AlimentCatalog> build() => {};

  /// If a catalog's version is the same, it loads from file.
  /// If a catalog is updated online, it is downloaded.
  /// If a catalog is deleted online, it is deleted locally as well.
  Future<void> load() async {
    final storage = ref.read(storageProvider.notifier);
    final versionsPath = AlimentBankConstants.catalogVersionsPath;
    final l = storage.loadLocal(versionsPath);
    final c = storage.loadCloud(versionsPath);

    final localJson = await l;
    final localVersions = Map<String, String>.from(localJson ?? {});
    state = await _loadLocal(storage, localVersions);

    _updateWithCloud(storage, localVersions, c, versionsPath);
    return;
  }

  Future<MapEntry<String, AlimentCatalog>?> _loadCatalog(
      String key, Future<dynamic> future) async {
    final json = await future;
    if (json == null) return null;
    return MapEntry(key, AlimentCatalog.fromJson(json));
  }

  Future<MapEntry<String, AlimentCatalog>?> _saveCatalog(
      String key, Future<dynamic> future, Storage storage, String path) async {
    final obj = await future;
    final json = Map<String, dynamic>.from(obj ?? {});
    await storage.saveLocal(path, json);
    if (obj == null) return null;
    return MapEntry(key, AlimentCatalog.fromJson(json));
  }

  Future<Map<String, AlimentCatalog>> _loadLocal(
      Storage storage, Map<String, String> localVersions) async {
    final List<Future<MapEntry<String, AlimentCatalog>?>> result = [];
    for (var key in localVersions.keys) {
      final path = '${AlimentBankConstants.catalogsPath}/$key';
      final catalogEntry = _loadCatalog(key, storage.loadLocal(path));
      result.add(catalogEntry);
    }
    final entriesOrNull = await Future.wait(result);
    final entries = entriesOrNull.whereType<MapEntry<String, AlimentCatalog>>();
    return Map.fromEntries(entries);
  }

  /// Fire & Forget
  Future<void> _updateWithCloud(
      Storage storage,
      Map<String, String> localVersions,
      Future<dynamic> c,
      String versionsPath) async {
    final cloudJson = await c;
    if (cloudJson == null) return;
    final cloudVersions = Map<String, String>.from(cloudJson);
    if (mapEquals(localVersions, cloudVersions)) return;

    final keys = localVersions.keys.toSet().union(cloudVersions.keys.toSet());
    final Set<String> deleted = {};
    final List<Future<MapEntry<String, AlimentCatalog>?>> updateFtr = [];
    for (var key in keys) {
      final path = '${AlimentBankConstants.catalogsPath}/$key';
      if (!cloudVersions.containsKey(key)) {
        deleted.add(key);
      } else if (cloudVersions[key] != localVersions[key]) {
        final future = storage.loadCloud(path);
        final catalogEntry = _saveCatalog(key, future, storage, path);
        updateFtr.add(catalogEntry);
      }
    }
    await storage.saveLocal(versionsPath, cloudVersions);
    final entriesOrNull = await Future.wait(updateFtr);
    final entries = entriesOrNull.whereType<MapEntry<String, AlimentCatalog>>();
    final update = Map.fromEntries(entries);
    state = state
      ..removeWhere((key, value) => deleted.contains(key))
      ..updateAll((key, value) => update[key] ?? value);
  }
}

@Riverpod(keepAlive: true)
AlimentBankState alimentBank(Ref ref) {
  final customAliments = ref.watch(customAlimentsProvider);
  final order = ref.watch(alimentOrderProvider);

  final catalogs = ref.watch(alimentCatalogsProvider);
  final catalogAliments = Map.fromEntries(catalogs.values.expand((catalog) => [
        ...catalog.original.aliments.entries,
        ...catalog.aiEnhanced.aliments.entries
      ]));

  final saveData = AlimentBankState(
    aliments: customAliments,
    order: order.toList(),
  );
  ref.read(alimentBankControllerProvider.notifier).saveBank(saveData);

  final displayAliments = {
    ...customAliments,
    ...catalogAliments,
  };
  final displayOrder = {
    ...order.where((id) => displayAliments.containsKey(id)),
    ...customAliments.keys,
    ...catalogAliments.keys,
  }.toList();
  return AlimentBankState(aliments: displayAliments, order: displayOrder);
}

@Riverpod(keepAlive: true)
class AlimentBankController extends _$AlimentBankController {
  @override
  void build() {}

  void setState(AlimentBankState bank) {
    ref.read(alimentOrderProvider.notifier).load(bank);
    ref.read(customAlimentsProvider.notifier).load(bank);
  }

  Future<void> load() async {
    final jsonFtr = ref
        .read(storageProvider.notifier)
        .loadJson(AlimentBankConstants.alimentBankPath);
    final catalogFtr = ref.read(alimentCatalogsProvider.notifier).load();

    final json = await jsonFtr;
    final bank = json != null
        ? AlimentBankState.fromJson(json)
        : AlimentBankState(aliments: {}, order: []);
    setState(bank);

    await catalogFtr;
  }

  Future<void> saveBank(AlimentBankState bank) async {
    await ref
        .read(storageProvider.notifier)
        .saveJson(AlimentBankConstants.alimentBankPath, bank.toJson());
  }

  Future<void> save() async {
    final customAliments = ref.read(customAlimentsProvider);
    final order = ref.read(alimentOrderProvider);
    final saveData = AlimentBankState(
      aliments: customAliments,
      order: order.toList(),
    );
    return saveBank(saveData);
  }

  void invalidate() {
    ref.invalidate(alimentOrderProvider);
    ref.invalidate(customAlimentsProvider);
    ref.invalidate(alimentCatalogsProvider);
    ref.invalidate(alimentBankProvider);
  }
}
