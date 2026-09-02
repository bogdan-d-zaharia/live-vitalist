import 'package:flutter/foundation.dart';
import 'package:live_vitalist/features/aliment_bank/domain/aliment_source.dart';
import 'package:live_vitalist/features/aliment_bank/domain/catalog_presentation.dart';

@immutable
class AlimentCatalog {
  final AlimentSource original;
  final AlimentSource aiEnhanced;
  final Map<String, CatalogPresentation> presentations;

  const AlimentCatalog({
    required this.original,
    required this.aiEnhanced,
    required this.presentations,
  });

  factory AlimentCatalog.fromJson(Map<String, dynamic> json) {
    return AlimentCatalog(
      original: AlimentSource.fromJson(json['original']),
      aiEnhanced: AlimentSource.fromJson(json['ai_enhanced']),
      presentations: Map.from(json['presentation'] ?? {}).map(
          (key, value) => MapEntry(key, CatalogPresentation.fromJson(value))),
    );
  }
}
