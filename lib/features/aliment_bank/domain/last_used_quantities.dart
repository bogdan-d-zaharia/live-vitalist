import 'package:flutter/foundation.dart';
import 'package:live_vitalist/features/aliment/domain/aliment.dart';

@immutable
class Quantity {
  final double amount;
  final String unit;
  const Quantity(this.amount, this.unit);

  Map<String, dynamic> toJson() => {
        'amount': amount,
        'unit': unit,
      };
  factory Quantity.fromJson(Map<String, dynamic> json) {
    final amount = switch (json['amount']) {
      num a => a.toDouble(),
      String s => double.tryParse(s),
      _ => null,
    };
    final unit = switch (json['unit']) {
      String s => s,
      _ => null,
    };
    return Quantity(amount ?? 1.0, unit ?? '');
  }
}

typedef Quantities = Map<String, Quantity>;

Map<String, dynamic> quantitiesToJson(Quantities quantities) =>
    quantities.map((id, quantity) => MapEntry(id, quantity.toJson()));

Quantities quantitiesFromJson(Map<String, dynamic> json) {
  final quantities = json.map((id, value) =>
      MapEntry(id, Quantity.fromJson(Map<String, dynamic>.from(value))));
  quantities.removeWhere((_, quantity) => quantity.unit.isEmpty);
  return quantities;
}

extension InstanceToQuantity on InstancedAliment {
  Quantity getQuantity() {
    return Quantity(servingSize, unit);
  }
}
