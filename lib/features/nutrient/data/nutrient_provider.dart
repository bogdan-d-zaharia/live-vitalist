import 'package:flutter/foundation.dart';
import 'package:live_vitalist/core/storage/data/storage_provider.dart';
import 'package:live_vitalist/core/utils/id_generator.dart';
import 'package:live_vitalist/features/day/data/day_provider.dart';
import 'package:live_vitalist/features/onboarding/domain/options/nutrients_option.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../domain/nutrient.dart';
import '../domain/nutrient_config_failure.dart';
import '../domain/nutrient_config_header.dart';
import '../domain/nutrient_constants.dart';
import '../domain/nutrient_state.dart';

part 'nutrient_provider.g.dart';

@Riverpod(keepAlive: true)
class NutrientConfigsList extends _$NutrientConfigsList {
  Future<void> _writes = Future.value();

  Future<void> get pendingWrites => _writes;

  @override
  Future<List<NutrientConfigHeader>> build() async {
    final storage = ref.read(storageProvider.notifier);
    final json = await storage.loadJson('nutrientConfigs/index');
    final headers = (json?['configs'] as List?)
        ?.map((value) =>
            NutrientConfigHeader.fromJson(Map<String, dynamic>.from(value)))
        .toList();
    if (headers != null && headers.isNotEmpty) return headers;

    final legacy = await storage.loadJson('nutrients');
    final header = NutrientConfigHeader(id: IdGenerator.uuidV4());
    final initial = legacy == null
        ? NutrientConstants.defaultNutrientState
        : NutrientState.fromJson(legacy);
    await storage.saveJson('nutrientConfigs/${header.id}', initial.toJson());
    await storage.saveJson('nutrientConfigs/index', {
      'configs': [header.toJson()]
    });
    return [header];
  }

  Future<void> _save(List<NutrientConfigHeader> headers) {
    state = AsyncData(List.unmodifiable(headers));
    final storage = ref.read(storageProvider.notifier);
    final json = {'configs': headers.map((header) => header.toJson()).toList()};
    final write = _writes.then((_) async {
      await storage.saveJson('nutrientConfigs/index', json);
    });
    _writes = write.then((_) {}, onError: (Object _, StackTrace __) {});
    return write;
  }

  Future<void> use(String id) async {
    await future;
    final headers = state.requireValue;
    final header = headers.firstWhere((header) => header.id == id);
    await _save([header, ...headers.where((header) => header.id != id)]);
  }

  Future<void> rename(String id, String name) async {
    final trimmed = name.trim();
    if (trimmed.isEmpty) return;
    await future;
    await _save(state.requireValue
        .map((header) => header.id == id
            ? NutrientConfigHeader(id: id, name: trimmed)
            : header)
        .toList());
  }

  Future<String> create({required String name, String? sourceId}) async {
    await future;
    final source = sourceId == null
        ? NutrientConstants.defaultNutrientState
        : await ref.read(nutrientConfigProvider(sourceId).future);
    final id = IdGenerator.uuidV4();
    await ref
        .read(storageProvider.notifier)
        .saveJson('nutrientConfigs/$id', source.toJson());
    await _save(
        [...state.requireValue, NutrientConfigHeader(id: id, name: name)]);
    return id;
  }
}

@Riverpod(keepAlive: true)
class NutrientConfig extends _$NutrientConfig {
  Future<void> _writes = Future.value();

  Future<void> save() async {
    await future;
    await _writes;
    await _save(state.requireValue);
  }

  @override
  Future<NutrientState> build(String id) async {
    final json = await ref
        .read(storageProvider.notifier)
        .loadJson('nutrientConfigs/$id');
    if (json == null) {
      throw NutrientConfigFailure(NutrientConfigFailureReason.notFound,
          configId: id);
    }
    return NutrientState.fromJson(json, configId: id);
  }

  Future<void> _save(NutrientState updated) {
    state = AsyncData(updated);
    final storage = ref.read(storageProvider.notifier);
    final json = updated.toJson();
    final write = _writes.then((_) async {
      await storage.saveJson('nutrientConfigs/$id', json);
    });
    _writes = write.then((_) {}, onError: (Object _, StackTrace __) {});
    return write;
  }

  Future<void> reorder(int oldIndex, int newIndex) async {
    await future;
    final current = state.requireValue;
    final order = [...current.order];
    order.insert(newIndex, order.removeAt(oldIndex));
    await _save(NutrientState(data: current.data, order: order, configId: id));
  }

  Future<void> updateNutrient(String key, Nutrient nutrient) async {
    await future;
    final current = state.requireValue;
    await _save(NutrientState(
      data: {...current.data, key: nutrient},
      order:
          current.order.contains(key) ? current.order : [...current.order, key],
      configId: id,
    ));
  }

  Future<void> addNutrient(String key, Nutrient nutrient) =>
      updateNutrient(key, nutrient);

  Future<void> toggleTag(String key, String tag) async {
    await future;
    final nutrient = state.requireValue.data[key];
    if (nutrient == null) return;
    final tags = [...nutrient.tags];
    tags.contains(tag) ? tags.remove(tag) : tags.add(tag);
    await updateNutrient(key, nutrient.copyWith(tags: tags));
  }

  Future<void> loadFromOnboarding(Set<NutrientsOption> options) async {
    await future;
    final current = state.requireValue;
    final data = current.data.map((key, nutrient) {
      final enabled = key == 'kcals' ||
          options.any((option) => nutrient.tags.contains(option.name));
      final tags = [...nutrient.tags]..remove('disabled');
      if (!enabled) tags.add('disabled');
      return MapEntry(key, nutrient.copyWith(tags: tags));
    });
    await _save(NutrientState(data: data, order: current.order, configId: id));
  }
}

@immutable
class NutrientConfigSelection {
  final String? id;
  final bool isMixed;

  const NutrientConfigSelection({this.id, this.isMixed = false});
}

@riverpod
Future<NutrientConfigSelection> nutrientConfigSelection(Ref ref) async {
  final dates = ref.watch(selectedDatesProvider);
  final days = await Future.wait(
      dates.map((date) => ref.watch(dayRecordProvider(date).future)));
  final ids = days.map((day) => day.nutrientConfigId).toSet();
  return NutrientConfigSelection(
      id: ids.length == 1 ? ids.first : null, isMixed: ids.length > 1);
}

@riverpod
Future<NutrientState> nutrients(Ref ref) async {
  final headersFuture = ref.watch(nutrientConfigsListProvider.future);
  final selectionFuture = ref.watch(nutrientConfigSelectionProvider.future);
  final headers = await headersFuture;
  final selection = await selectionFuture;
  if (!ref.mounted) {
    throw NutrientConfigFailure(NutrientConfigFailureReason.selectionChanged);
  }
  return ref
      .watch(nutrientConfigProvider(selection.id ?? headers.first.id).future);
}

@riverpod
Future<NutrientState> dayNutrients(Ref ref, DateTime date) async {
  final headersFuture = ref.watch(nutrientConfigsListProvider.future);
  final dayFuture = ref.watch(dayRecordProvider(date).future);
  final headers = await headersFuture;
  final day = await dayFuture;
  if (!ref.mounted) {
    throw NutrientConfigFailure(NutrientConfigFailureReason.dayChanged);
  }
  return ref.watch(
      nutrientConfigProvider(day.nutrientConfigId ?? headers.first.id).future);
}
