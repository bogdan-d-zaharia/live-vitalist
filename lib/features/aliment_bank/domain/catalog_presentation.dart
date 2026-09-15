import 'package:flutter/foundation.dart';

@immutable
class CatalogPresentation {
  final String sourceTitle;
  final String description;

  const CatalogPresentation({
    required this.sourceTitle,
    required this.description,
  });

  factory CatalogPresentation.fromJson(Map<String, dynamic> json) {
    return CatalogPresentation(
      sourceTitle: json['source_title'],
      description: json['description'],
    );
  }
}
