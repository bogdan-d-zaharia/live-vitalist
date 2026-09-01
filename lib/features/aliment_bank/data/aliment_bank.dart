import 'package:live_vitalist/features/aliment_bank/domain/aliment_bank_state.dart';
import 'package:live_vitalist/features/aliment_bank/domain/aliment_bank_constants.dart';
import 'package:live_vitalist/features/aliment/domain/aliment_data.dart';
import 'package:live_vitalist/core/storage/data/storage_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'aliment_bank.g.dart';

@Riverpod(keepAlive: true)
class AlimentBank extends _$AlimentBank {
  @override
  AlimentBankState build() {
    return AlimentBankState(aliments: {}, order: []);
  }

  void setAliment(String id, AlimentData data) {
    state = AlimentBankState(
      aliments: {...state.aliments, id: data},
      order: state.order.contains(id) ? state.order : [id, ...state.order],
    );
    save();
  }

  void setFirst(String id) {
    if (state.aliments.keys.contains(id)) {
      state = AlimentBankState(
        aliments: state.aliments,
        order: [id, ...state.order..removeWhere((otherId) => otherId == id)],
      );
    }
    save();
  }

  Future<void> save() {
    return ref
        .read(storageProvider.notifier)
        .saveJson(AlimentBankConstants.alimentBankPath, state.toJson());
  }

  Future<void> load() async {
    final json = await ref
        .read(storageProvider.notifier)
        .loadJson(AlimentBankConstants.alimentBankPath);
    if (json != null) state = AlimentBankState.fromJson(json);
  }

  void setState(AlimentBankState newState) {
    state = newState;
    save();
  }
}
