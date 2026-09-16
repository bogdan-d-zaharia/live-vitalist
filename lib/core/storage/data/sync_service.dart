import 'package:firebase_auth/firebase_auth.dart';
import 'package:live_vitalist/core/storage/data/storage_provider.dart';
import 'package:live_vitalist/features/aliment_bank/data/aliment_bank.dart';
import 'package:live_vitalist/features/aliment_bank/domain/aliment_bank_state.dart';
import 'package:live_vitalist/features/day/data/day_provider.dart';
import 'package:live_vitalist/features/nutrient/data/nutrient_provider.dart';
import 'package:live_vitalist/features/nutrient/domain/nutrient_config_header.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'sync_service.g.dart';

/// To solve data conflicts, we can either:
/// 1. Save & Load intelligently
/// 2. Append (intelligently) / Overwrite (brute)
///    the cloud with local data,
///        then delete everything local (to force online download)
///        then pull from cloud
/// We are going to use the second option.
@riverpod
class SyncService extends _$SyncService {
  late Storage _storageNotifier;

  @override
  void build() {
    _storageNotifier = ref.read(storageProvider.notifier);
  }

  List<String> _popLocalOrder() {
    final order = ref.read(alimentOrderProvider);
    ref
        .read(alimentOrderProvider.notifier)
        .load(AlimentBankState(aliments: {}, order: []));
    return order.toList();
  }

  void _pushLocalOrder(List<String> localOrder) {
    final oldAliments = ref.read(customAlimentsProvider);
    final oldOrder = ref.read(alimentOrderProvider);
    final bank = AlimentBankState(
      aliments: oldAliments,
      order: [...localOrder, ...oldOrder],
    );
    ref.read(alimentBankControllerProvider.notifier).setState(bank);
  }

  Future<void> _saveProviders() async {
    await ref
        .read(alimentBankControllerProvider.notifier)
        .save(); // intelligent
    // TODO: await saveQueuedRecords();                  // brute but granular
    await _saveNutrientConfigs();
  }

  Future<void> _saveNutrientConfigs() async {
    final headers = await ref.read(nutrientConfigsListProvider.future);
    await ref.read(nutrientConfigsListProvider.notifier).pendingWrites;
    final userId = FirebaseAuth.instance.currentUser?.uid;
    final remote = userId == null
        ? null
        : await _storageNotifier.loadCloud(
            'users/$userId/nutrientConfigs/index',
          );
    final remoteHeaders = (remote?['configs'] as List?)
            ?.map((value) =>
                NutrientConfigHeader.fromJson(Map<String, dynamic>.from(value)))
            .toList() ??
        <NutrientConfigHeader>[];
    for (final header in headers) {
      await ref.read(nutrientConfigProvider(header.id).notifier).save();
    }
    final ids = headers.map((header) => header.id).toSet();
    await _storageNotifier.saveJson('nutrientConfigs/index', {
      'configs': [
        ...headers,
        ...remoteHeaders.where((header) => !ids.contains(header.id)),
      ].map((header) => header.toJson()).toList(),
    });
  }

  void _clearProviders() {
    ref.read(alimentBankControllerProvider.notifier).invalidate();
    ref.invalidate(nutrientConfigsListProvider);
    ref.invalidate(nutrientConfigProvider);
    ref.invalidate(nutrientsProvider);
    ref.invalidate(dayCacheProvider);
  }

  Future<void> _loadProviders() async {
    await ref.read(alimentBankControllerProvider.notifier).load();
    // day records and nutrient configurations load on demand
  }

  Future<void> lateLogin() async {
    final keepAliveLink = ref.keepAlive();
    try {
      final localOrder = _popLocalOrder();

      await _saveProviders(); // (except order)
      await _storageNotifier.deleteLocal();
      _clearProviders();
      // TODO: Make the providers load on build()
      // -> at startup by themselves
      // -> after the invalidation
      await _loadProviders();

      _pushLocalOrder(localOrder);
    } finally {
      keepAliveLink.close();
    }
  }
}
