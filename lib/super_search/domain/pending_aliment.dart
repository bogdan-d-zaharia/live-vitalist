import 'package:live_vitalist/aliment/domain/aliment.dart';

/// An aliment picked from the search results, waiting to be added to a meal.
class PendingAliment {
  PendingAliment({
    required this.alimentID,
    required this.servingSize,
    required this.unit,
  });

  final String alimentID;
  double servingSize;
  String unit;

  InstancedAliment toInstanced() => InstancedAliment(
        alimentID: alimentID,
        servingSize: servingSize,
        unit: unit,
      );
}
