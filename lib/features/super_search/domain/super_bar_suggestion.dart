// ignore_for_file: annotate_overrides

import 'package:freezed_annotation/freezed_annotation.dart';

part 'super_bar_suggestion.freezed.dart';

@freezed
class SuperBarSuggestion with _$SuperBarSuggestion {
  final String text;
  final Duration duration;

  const SuperBarSuggestion({
    required this.text,
    required this.duration,
  });
}

@freezed
class SuperBarSuggestions with _$SuperBarSuggestions {
  final List<SuperBarSuggestion> items;

  const SuperBarSuggestions({
    this.items = const [],
  });
}
