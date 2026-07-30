import 'package:flutter/foundation.dart';
import 'package:live_vitalist/features/aliment/domain/aliment_data.dart';

@immutable
class AlimentBankState {
  final Map<String, AlimentData> aliments;
  final List<String> order;

  const AlimentBankState({
    required this.aliments,
    required this.order,
  });

  Map<String, dynamic> toJson() => {
        // dot notation
        ...aliments.map((id, data) => MapEntry('aliments/$id', data.toJson())),
        if (order.isNotEmpty) 'order': order,
      };

  factory AlimentBankState.fromJson(Map<String, dynamic> json) {
    final Map<String, AlimentData> parsedAliments =
        ((json['aliments'] ?? {}) as Map).map((id, d) => MapEntry(
            id as String, AlimentData.fromJson(Map<String, dynamic>.from(d))));

    final List<String> parsedOrder = List<String>.from(json['order'] ?? []);

    final fullOrder = {
      ...parsedOrder,
      ...parsedAliments.keys,
    }.toList();

    return AlimentBankState(aliments: parsedAliments, order: fullOrder);
  }
}
