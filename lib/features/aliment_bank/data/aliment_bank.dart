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

  Future<void> load() async {
    final storage = ref.read(storageProvider.notifier);
    final catalogs = await _loadCatalogs(storage);
    state = catalogs;
  }

  Future<MapEntry<String, AlimentCatalog>?> _loadCatalog(
      String key, Future<Map<String, dynamic>?> future) async {
    final json = await future;
    if (json == null) return null;
    return MapEntry(key, AlimentCatalog.fromJson(json));
  }

  Future<MapEntry<String, AlimentCatalog>?> _saveCatalog(
      String key, Future<dynamic> future, Storage storage, String path) async {
    final obj = await future;
    final json = Map<String, dynamic>.from(obj ?? {});
    await storage.saveJson(path, json);
    if (obj == null) return null;
    return MapEntry(key, AlimentCatalog.fromJson(json));
  }

  /// If a catalog's version is the same, it loads from file.
  /// If a catalog is updated online, it is downloaded.
  /// If a catalog is deleted online, it is deleted locally as well.
  Future<Map<String, AlimentCatalog>> _loadCatalogs(Storage storage) async {
    final versionsPath = AlimentBankConstants.catalogVersionsPath;
    final c = storage.loadCloud(versionsPath);
    final l = storage.loadLocal(versionsPath);
    final cloudJson = await c;
    final localJson = await l;
    final cloudVersions = Map<String, String>.from(cloudJson ?? {});
    final localVersions = Map<String, String>.from(localJson ?? {});
    final keys = localVersions.keys.toSet().union(cloudVersions.keys.toSet());
    final List<Future<MapEntry<String, AlimentCatalog>?>> result = [];
    for (var key in keys) {
      final path = '${AlimentBankConstants.catalogsPath}/$key';
      final catalogEntry = localVersions[key] == cloudVersions[key]
          ? _loadCatalog(key, storage.loadJson(path))
          : _saveCatalog(key, storage.loadCloud(path), storage, path);
      result.add(catalogEntry);
    }
    if (cloudJson != null) await storage.saveJson(versionsPath, cloudVersions);
    final entriesOrNull = await Future.wait(result);
    final entries = entriesOrNull.whereType<MapEntry<String, AlimentCatalog>>();
    return Map.fromEntries(entries);
  }
}

@Riverpod(keepAlive: true)
AlimentBankState alimentBank(Ref ref) {
  final customAliments = ref.watch(customAlimentsProvider);
  final order = ref.watch(alimentOrderProvider);

  final catalogs = ref.watch(alimentCatalogsProvider);
  final catalogAliments = Map.fromEntries(
      catalogs.values.expand((catalog) => catalog.original.aliments.entries));

  final saveData = AlimentBankState(
    aliments: customAliments,
    order: order.toList(),
  );
  ref.read(alimentBankControllerProvider.notifier).saveBank(saveData);

  return AlimentBankState(
    aliments: {
      ...customAliments,
      ...catalogAliments,
    },
    order: {
      ...order,
      ...customAliments.keys,
      ...catalogAliments.keys,
    }.toList(),
  );
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
