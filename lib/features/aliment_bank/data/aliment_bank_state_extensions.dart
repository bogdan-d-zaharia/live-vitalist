import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:live_vitalist/features/aliment/domain/aliment_data.dart';
import 'package:live_vitalist/features/aliment_bank/domain/aliment_bank_state.dart';

// TODO: Throw error and catch later, move the rest to domain.
extension AlimentBankStateExtensions on AlimentBankState {
  AlimentData getAliment(String alimentID) {
    final alimentData = aliments[alimentID];
    if (alimentData == null) {
      FirebaseCrashlytics.instance
          .recordError(
            StateError('Using error aliment placeholder! (id: $alimentID)'),
            StackTrace.current,
            reason: 'Aliment ID was not found in AlimentBankState',
            information: ['alimentID: $alimentID'],
            fatal: false,
          )
          .ignore();

      return AlimentData.errorPlaceholder;
    }
    return alimentData;
  }
}
