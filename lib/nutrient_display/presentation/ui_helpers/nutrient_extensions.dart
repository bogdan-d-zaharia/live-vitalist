import 'package:live_vitalist/nutrient/domain/nutrient.dart';
import 'package:live_vitalist/nutrient_display/domain/intake.dart';
import 'package:live_vitalist/settings/data/settings_data.dart';

extension NutrientExtensions on Nutrient {
  Intake toIntake(double amount) {
    final label = translations[SettingsData.language] ?? '';
    return Intake(label, amount, lowerLimit, upperLimit, unit);
  }
}

extension IntakeExtensions on Intake {
  /// $1 is Right, $2 is Left.
  (String?, String?) calculateRLExcessTexts({int charSpacing = 2}) {
    final String spacing = ' ' * charSpacing;

    double? absoluteExcess;
    if ((lowerLimit != null) && (amount < lowerLimit!)) {
      absoluteExcess = amount - lowerLimit!;
    } else if ((upperLimit != null) && (amount > upperLimit!)) {
      absoluteExcess = amount - upperLimit!;
    }

    double? relativeExcess;
    if ((lowerLimit != null) && (amount < lowerLimit!)) {
      relativeExcess = absoluteExcess! / lowerLimit!;
    } else if ((upperLimit != null) && (amount > upperLimit!)) {
      relativeExcess = absoluteExcess! / upperLimit!;
    }

    double? remaining;
    if (absoluteExcess == null && upperLimit != null) {
      remaining = upperLimit! - amount;
    }

    String? rightText;
    if (absoluteExcess != null) {
      rightText = '${absoluteExcess > 0 ? '+' : ''}'
          '${absoluteExcess.toStringAsFixed(1)} $unit$spacing';
    }
    if (remaining != null) {
      rightText = '${(remaining).toStringAsFixed(2)} $unit$spacing';
    }

    String? leftText;
    if (relativeExcess != null) {
      leftText = '$spacing${relativeExcess > 0 ? '+' : ''}'
          '${(relativeExcess * 100.0).toStringAsFixed(1)}%';
    }

    /// TODO: Maybe 0% -> 'lowerLimit'; 100% -> 'upperLimit'
    /// if (remaining != null) {
    ///   leftText = '${(remaining).toStringAsFixed(2)} $unit ';
    /// }

    (String?, String?) output = (rightText, leftText);

    return output;
  }
}
