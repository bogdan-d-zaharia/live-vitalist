import 'package:live_vitalist/core/storage/data/storage_provider.dart';
import 'package:live_vitalist/features/aliment/data/aliment_bank.dart';
import 'package:live_vitalist/features/day/data/day_provider.dart';
import 'package:live_vitalist/features/nutrient/data/nutrient_provider.dart';
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
    final localAlimentBank = ref.read(alimentBankProvider);
    final localOrder = List.of(localAlimentBank.order);
    ref.read(alimentBankProvider.notifier).setState(
        AlimentBankState(aliments: localAlimentBank.aliments, order: []));
    return localOrder;
  }

  void _pushLocalOrder(List<String> localOrder) {
    final oldState = ref.read(alimentBankProvider);
    ref.read(alimentBankProvider.notifier).setState(AlimentBankState(
          aliments: oldState.aliments,
          order: [...localOrder, ...oldState.order],
        ));
  }

  Future<void> _saveProviders() async {
    await ref.read(alimentBankProvider.notifier).save(); // intelligent
    // TODO: await saveQueuedRecords();                  // brute but granular
    // await ref.read(nutrientsProvider.notifier)        .intelligentSave();
  }

  Future<void> _clearProviders() async {
    ref.invalidate(alimentBankProvider);
    ref.invalidate(nutrientsProvider);
    ref.invalidate(dayCacheProvider);
  }

  Future<void> _loadProviders() async {
    await ref.read(alimentBankProvider.notifier).load();
    // day records load on demand
    await ref.read(nutrientsProvider.notifier).load();
  }

  Future<void> lateLogin() async {
    final keepAliveLink = ref.keepAlive();
    try {
      final localOrder = _popLocalOrder();

      await _saveProviders(); // (except order)
      await _storageNotifier.deleteLocal();
      await _clearProviders();
      await _loadProviders();

      _pushLocalOrder(localOrder);
    } finally {
      keepAliveLink.close();
    }
  }
}
