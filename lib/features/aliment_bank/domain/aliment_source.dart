import 'package:flutter/foundation.dart';
import 'package:live_vitalist/features/aliment/domain/aliment_data.dart';

@immutable
class AlimentSource {
  final Map<String, AlimentData> aliments;
  const AlimentSource({required this.aliments});

  factory AlimentSource.fromJson(dynamic json) {
    return AlimentSource(
      aliments: json is Map
          ? json.map((key, value) => MapEntry(key, AlimentData.fromJson(value)))
          : {},
    );
  }
}
