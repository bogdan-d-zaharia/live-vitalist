import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../file_handler.dart';
import 'nutrient.dart';
import 'nutrient_initial_data.dart';

class NutrientState {
  final Map<String, Nutrient> data;
  final List<String> order;

  NutrientState({required this.data, required this.order});

  Nutrient getByIndex(int index) => data[order[index]]!;
}

class NutrientStateNotifier extends StateNotifier<NutrientState> {
  NutrientStateNotifier()
      : super(NutrientState(
          data: initialNutrientMap,
          order: initialNutrientMap.keys.toList(),
        ));

  void reorder(int oldIndex, int newIndex) {
    final updated = [...state.order];
    final item = updated.removeAt(oldIndex);
    updated.insert(newIndex, item);
    state = NutrientState(data: state.data, order: updated);
    _save();
  }

  void update(String key, Nutrient updated) {
    state = NutrientState(
      data: {...state.data, key: updated},
      order: state.order,
    );
    _save();
  }

  void addNutrient(String key, Nutrient nutrient) {
    state = NutrientState(
      data: {...state.data, key: nutrient},
      order: [...state.order, key],
    );
    _save();
  }

  void loadFromJson(Map<String, dynamic> json) {
    final rawData = Map<String, dynamic>.from(json['data'] ?? {});
    final newData = rawData.map((key, value) =>
        MapEntry(key, Nutrient.fromJson(Map<String, dynamic>.from(value))));

    final rawOrder = List<String>.from(json['order'] ?? []);
    final fullOrder = {
      ...rawOrder,
      ...newData.keys,
    }.toList();

    state = NutrientState(
      data: newData,
      order: fullOrder,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (state.data.isNotEmpty)
        'data': state.data.map((key, value) => MapEntry(key, value.toJson())),
      if (state.order.isNotEmpty) 'order': state.order,
    };
  }

  Future<void> _save() {
    return StorageHandler.saveJson('nutrients', toJson(), doBackup: true);
  }

  Future<void> load() async {
    final json = await StorageHandler.loadJson('nutrients');
    if (json != null) {
      loadFromJson(json);
    }
  }

  /* Tags */

  void addTag(String key, String tag) {
    final old = state.data[key];
    if (old == null) return;

    final updatedTags = {...old.tags, tag}.toList();
    update(key, old.copyWith(tags: updatedTags));
  }

  void removeTag(String key, String tag) {
    final old = state.data[key];
    if (old == null) return;

    final updatedTags = [...old.tags]..remove(tag);
    update(key, old.copyWith(tags: updatedTags));
  }

  void toggleTag(String key, String tag) {
    final old = state.data[key];
    if (old == null) return;

    final tags = [...old.tags];
    if (tags.contains(tag)) {
      tags.remove(tag);
    } else {
      tags.add(tag);
    }

    update(key, old.copyWith(tags: tags));
  }
}

final nutrientStateProvider =
    StateNotifierProvider<NutrientStateNotifier, NutrientState>(
        (ref) => NutrientStateNotifier());
