import 'package:live_vitalist/nutrient/data/nutrient_provider.dart';
import 'package:live_vitalist/nutrient/domain/nutrient.dart';
import 'package:live_vitalist/nutrient/domain/nutrient_extensions.dart';
import 'package:live_vitalist/settings/data/settings_data.dart';

List<String> filteredAndSortedKeys(
    NutrientState state, Map<String, double> intake) {
  List<String> keys = state.order
      .where((key) => !state.data[key]!.tags.contains('disabled'))
      .toList();

  if (SettingsData.isSmartHide) {
    keys = keys.where((key) {
      final value = (intake[key] ?? 0.0);
      final lower = state.data[key]!.lowerLimit;
      final upper = state.data[key]!.upperLimit;
      return (lower != null && value < lower) ||
          (upper != null && value > upper * 0.9);
    }).toList();
  }

  if (SettingsData.sort != 0) {
    keys.sort((a, b) {
      final aValue = (intake[a] ?? 0.0);
      final bValue = (intake[b] ?? 0.0);
      return SettingsData.sort == 1
          ? _compareDescending(aValue, state.data[a]!, bValue, state.data[b]!)
          : _compareAscending(aValue, state.data[a]!, bValue, state.data[b]!);
    });
  }

  return keys;
}

double _mapRange(
    double value, double inMin, double inMax, double outMin, double outMax) {
  return (value - inMin) * (outMax - outMin) / (inMax - inMin) + outMin;
}

int _compareAscending(
    double intakeA, Nutrient fieldA, double intakeB, Nutrient fieldB) {
  // final debugNA = fieldA.translations['ENG'];
  // final debugNB = fieldB.translations['ENG'];

  final ratioA = fieldA.getRatio(intakeA)!;
  final ratioB = fieldB.getRatio(intakeB)!;
  if (ratioA != ratioB) return ratioA.compareTo(ratioB);

  final rA = _mapRange(intakeA, fieldA.lowerLimit ?? 0.0,
      fieldA.upperLimit ?? double.infinity, 0.0, 1.0);
  final rB = _mapRange(intakeB, fieldB.lowerLimit ?? 0.0,
      fieldB.upperLimit ?? double.infinity, 0.0, 1.0);
  return rA.compareTo(rB);
}

int _compareDescending(
    double intakeA, Nutrient fieldA, double intakeB, Nutrient fieldB) {
  // final debugNA = fieldA.translations['ENG'];
  // final debugNB = fieldB.translations['ENG'];

  final ratioA = fieldA.getRatio(intakeA)!;
  final ratioB = fieldB.getRatio(intakeB)!;
  if (ratioA != ratioB) return ratioB.compareTo(ratioA);

  final rA = _mapRange(intakeA, fieldA.lowerLimit ?? 0.0,
      fieldA.upperLimit ?? double.infinity, 0.0, 1.0);
  final rB = _mapRange(intakeB, fieldB.lowerLimit ?? 0.0,
      fieldB.upperLimit ?? double.infinity, 0.0, 1.0);
  return rB.compareTo(rA);
}
