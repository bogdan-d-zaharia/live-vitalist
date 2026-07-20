import 'package:flutter/foundation.dart';
import 'package:live_vitalist/features/settings/data/settings_data.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'nutrient_display_controller.g.dart';

@immutable
class NutrientDisplayState {
  final bool isEditMode;
  final Sort sort;
  final bool isSmartHide;

  const NutrientDisplayState({
    required this.isEditMode,
    required this.sort,
    required this.isSmartHide,
  });

  NutrientDisplayState copyWith(
      {bool? isEditMode, Sort? sort, bool? isSmartHide}) {
    return NutrientDisplayState(
      isEditMode: isEditMode ?? this.isEditMode,
      sort: sort ?? this.sort,
      isSmartHide: isSmartHide ?? this.isSmartHide,
    );
  }
}

@riverpod
class NutrientDisplayController extends _$NutrientDisplayController {
  @override
  NutrientDisplayState build() => NutrientDisplayState(
        isEditMode: false,
        sort: SettingsData.sort,
        isSmartHide: SettingsData.isSmartHide,
      );

  void circleSort() {
    final Sort newSort = switch (state.sort) {
      Sort.unsorted => Sort.descending,
      Sort.descending => Sort.ascending,
      _ => Sort.unsorted,
    };
    state = state.copyWith(sort: newSort);
    SettingsData.sort = newSort;
  }

  void toggleEditMode() {
    state = state.copyWith(isEditMode: !state.isEditMode);
  }

  void toggleSmartHide() {
    final bool newIsSmartHide = !state.isSmartHide;
    state = state.copyWith(isSmartHide: newIsSmartHide);
    SettingsData.isSmartHide = newIsSmartHide;
  }
}
