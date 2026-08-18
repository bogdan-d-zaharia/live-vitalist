// ignore_for_file: annotate_overrides

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:live_vitalist/features/super_search/domain/pending_aliment.dart';

part 'super_search_state.freezed.dart';

@freezed
class SuperSearchState with _$SuperSearchState {
  final bool isActive;
  final String query;
  final List<PendingAliment> selection;
  final DateTime? date;
  final String? mealName;

  const SuperSearchState({
    this.isActive = false,
    this.query = '',
    this.selection = const [],
    this.date,
    this.mealName,
  });

  bool isSelected(String alimentID) =>
      selection.any((item) => item.alimentID == alimentID);
}
