// TODO: Make Intake have a LooseInterval
// and rethink Nutrient,
// perhaps keep a key, move the translations
class Intake {
  final String label;
  final double amount;
  final double? lowerLimit;
  final double? upperLimit;
  final String unit;

  Intake(this.label, this.amount, this.lowerLimit, this.upperLimit, this.unit);
}
