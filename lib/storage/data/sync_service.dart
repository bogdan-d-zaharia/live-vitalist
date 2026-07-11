import 'package:live_vitalist/aliment/aliment_bank.dart';
import 'package:live_vitalist/aliment/aliment_constants.dart';
import 'package:live_vitalist/day/day_provider.dart';
import 'package:live_vitalist/nutrient/nutrient_provider.dart';
import 'package:live_vitalist/storage/data/file_handler.dart';
import 'package:live_vitalist/storage/data/firebase_handler.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'sync_service.g.dart';

/// To solve data conflicts, we can either:
/// 1. Save & Load intelligently
/// 2. Append (intelligently) / Overwrite (brute)
///    the cloud with local data,
///        then delete everything local (to force online download)
///        then pull from cloud
/// We are going to use the second option.
///
/// note: both are connected to be able to save,
/// so we have to take them separately to delete local data,
/// we can't use the StorageProvider directly.
@riverpod
class SyncService extends _$SyncService {
  late FileHandler _fileHlr;
  late FirebaseHandler _firebaseHlr;

  @override
  void build() {
    _fileHlr = FileHandler();
    _firebaseHlr = FirebaseHandler();
  }

  Future<void> _appendOrderWithCloud() async {
    // TODO: Make .loadJson generic (and cast at return, implicitly or not)
    // and use .load('alimentBank/order')
    final cloudOrder = (await _firebaseHlr
        .loadJson(AlimentConstants.alimentBankPath))?['order'];
    final oldState = ref.read(alimentBankProvider);
    ref.read(alimentBankProvider.notifier).setState(AlimentBankState(
          aliments: oldState.aliments,
          order: [...oldState.order, ...cloudOrder],
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
      await _appendOrderWithCloud();
      await _saveProviders();
      await _fileHlr.delete();
      await _clearProviders();
      await _loadProviders();
    } finally {
      keepAliveLink.close();
    }
  }
}
