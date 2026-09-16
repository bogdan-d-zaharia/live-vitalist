import 'package:freezed_annotation/freezed_annotation.dart';

import 'nutrient.dart';

part 'nutrient_state.freezed.dart';

@freezed
class NutrientState with _$NutrientState {
  @override
  final Map<String, Nutrient> data;
  @override
  final List<String> order;
  @override
  final String? configId;

  const NutrientState({required this.data, required this.order, this.configId});

  Nutrient getByIndex(int index) => data[order[index]]!;

  factory NutrientState.fromJson(Map<String, dynamic> json,
      {String? configId}) {
    final rawData = Map<String, dynamic>.from(
      json.containsKey('data') ? json['data'] ?? {} : json,
    );
    final data = rawData.map((key, value) =>
        MapEntry(key, Nutrient.fromJson(Map<String, dynamic>.from(value))));
    final order = {
      if (json.containsKey('data')) ...List<String>.from(json['order'] ?? []),
      ...data.keys,
    }.where(data.containsKey).toList();
    return NutrientState(data: data, order: order, configId: configId);
  }

  Map<String, dynamic> toJson() => {
        'data': data.map((key, value) => MapEntry(key, value.toJson())),
        'order': order,
      };
}
