import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:live_vitalist/features/super_search/domain/pending_aliment.dart';

@immutable
class AlimentSearchState {
  final bool isActive;
  final String query;
  final List<PendingAliment> selection;

  const AlimentSearchState({
    this.isActive = false,
    this.query = '',
    this.selection = const [],
  });

  bool isSelected(String alimentID) =>
      selection.any((item) => item.alimentID == alimentID);

  AlimentSearchState copyWith({
    bool? isActive,
    String? query,
    List<PendingAliment>? selection,
  }) {
    return AlimentSearchState(
      isActive: isActive ?? this.isActive,
      query: query ?? this.query,
      selection: selection ?? this.selection,
    );
  }
}

/* Written by hand instead of codegen because the search state
   holds no async work and stays this small. */
class AlimentSearchController extends Notifier<AlimentSearchState> {
  @override
  AlimentSearchState build() => const AlimentSearchState();

  void enter() => state = state.copyWith(isActive: true);

  void exit() => state = const AlimentSearchState();

  void setQuery(String query) => state = state.copyWith(query: query);

  void toggle(PendingAliment aliment) {
    if (state.isSelected(aliment.alimentID)) {
      remove(aliment.alimentID);
    } else {
      state = state.copyWith(selection: [...state.selection, aliment]);
    }
  }

  void remove(String alimentID) {
    state = state.copyWith(
      selection:
          state.selection.where((item) => item.alimentID != alimentID).toList(),
    );
  }
}

final alimentSearchProvider =
    NotifierProvider<AlimentSearchController, AlimentSearchState>(
        AlimentSearchController.new);
