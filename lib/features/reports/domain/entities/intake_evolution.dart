import 'package:live_vitalist/features/nutrient_display/domain/intake.dart';

class IntakeEvolution {
  final Intake? previous;
  final Intake current;
  IntakeEvolution(this.previous, this.current);
}
