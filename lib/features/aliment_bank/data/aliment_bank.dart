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
  List<AlimentCatalog> build() => [];

  Future<void> load() async {
    final storage = ref.read(storageProvider.notifier);
    state = await _loadCatalogs(storage);
  }

  Future<AlimentCatalog?> _loadCatalog(
      Future<Map<String, dynamic>?> future) async {
    final json = await future;
    if (json == null) return null;
    return AlimentCatalog.fromJson(json);
  }

  Future<AlimentCatalog?> _saveCatalog(
      Future<dynamic> future, Storage storage, String path) async {
    final obj = await future;
    final json = Map<String, dynamic>.from(obj ?? {});
    await storage.saveJson(path, json);
    if (obj == null) return null;
    return AlimentCatalog.fromJson(json);
  }

  /// If a catalog's version is the same, it loads from file.
  /// If a catalog is updated online, it is downloaded.
  /// If a catalog is deleted online, it is deleted locally as well.
  Future<List<AlimentCatalog>> _loadCatalogs(Storage storage) async {
    final versionsPath = AlimentBankConstants.catalogVersionsPath;
    final c = storage.loadCloud(versionsPath);
    final l = storage.loadJson(versionsPath);
    final cloudJson = await c;
    final localJson = await l;
    final cloudVersions = Map<String, String>.from(cloudJson ?? {});
    final localVersions = Map<String, String>.from(localJson ?? {});
    final keys = localVersions.keys.toSet().union(cloudVersions.keys.toSet());
    final List<Future<AlimentCatalog?>> result = [];
    for (var key in keys) {
      final path = '${AlimentBankConstants.catalogsPath}/$key';
      final catalog = localVersions[key] == cloudVersions[key]
          ? _loadCatalog(storage.loadJson(path))
          : _saveCatalog(storage.loadCloud(path), storage, path);
      result.add(catalog);
    }
    if (cloudJson != null) await storage.saveJson(versionsPath, cloudVersions);
    return (await Future.wait(result)).whereType<AlimentCatalog>().toList();
  }
}

@Riverpod(keepAlive: true)
AlimentBankState alimentBank(Ref ref) {
  final customAliments = ref.watch(customAlimentsProvider);
  final catalogs = ref.watch(alimentCatalogsProvider);
  final order = ref.watch(alimentOrderProvider);

  final catalogAliments = Map.fromEntries(
      catalogs.expand((catalog) => catalog.original.aliments.entries));

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
    return ref.read(alimentBankControllerProvider.notifier).saveBank(saveData);
  }

  void invalidate() {
    ref.invalidate(alimentOrderProvider);
    ref.invalidate(customAlimentsProvider);
    ref.invalidate(alimentCatalogsProvider);
    ref.invalidate(alimentBankProvider);
  }
}
