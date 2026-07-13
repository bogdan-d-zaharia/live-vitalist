import 'package:live_vitalist/nutrient/domain/nutrient.dart';

extension NutrientUtils on Nutrient {
  double? getRatio(double? amount) {
    if (amount == null) return null;
    final lower = lowerLimit ?? 0.0;
    final upper = upperLimit ?? double.infinity;

    if (lower <= amount && amount <= upper) return 1.0;
    if (amount < lower) return amount / lower;
    if (amount > upper) return amount / upper;
    return null;
  }
}
