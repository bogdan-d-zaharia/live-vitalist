import 'package:live_vitalist/features/aliment/data/aliment_bank.dart';
import 'package:live_vitalist/features/aliment/domain/aliment.dart';

extension AlimentDataReadUtils on Aliment {
  /// Tolerable to errors,
  /// if no unit synonym found, returns 1.0 even if not the basic unit.
  double readUnitSize(AlimentBankState bank) {
    return readDataRef(bank).unitSynonyms[unit] ?? 1.0;
  }

  double readField(String nutrient, AlimentBankState bank, double unitSize) {
    final data = readDataRef(bank);
    final refField = data.referenceFields[nutrient] ?? 0.0;
    return refField * servingSize * unitSize / data.referenceSize;
  }

  /// Returns a processed copy of the referencedFields,
  /// taking into account the servingSize and unit size.
  Map<String, double> readFields(AlimentBankState bank) {
    final data = readDataRef(bank);
    return data.referenceFields.map((key, value) =>
        MapEntry(key, readField(key, bank, readUnitSize(bank))));
    //  value * servingSize * readUnitSize(bank) / data.referenceSize));
  }
}

extension AlimentsAnalysis on List<Aliment> {
  Map<String, double> summedFields(AlimentBankState bank) {
    final Map<String, double> result = {};

    for (var aliment in this) {
      for (final entry in aliment.readFields(bank).entries) {
        result.update(entry.key, (v) => v + entry.value,
            ifAbsent: () => entry.value);
      }
    }

    return result;
  }
}
