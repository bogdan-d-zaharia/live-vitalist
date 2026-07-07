import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:live_vitalist/aliment/aliment_data.dart';

import 'package:live_vitalist/json_handler.dart';
import 'package:live_vitalist/storage/data/storage_solution.dart';

class AlimentBankState {
  final Map<String, AlimentData> aliments;
  final List<String> order;

  AlimentBankState({
    required this.aliments,
    required this.order,
  });

  Map<String, dynamic> toJson() => {
        'aliments': aliments.map((id, data) => MapEntry(id, data.toJson())),
        'order': order,
      };

  factory AlimentBankState.fromJson(Map<String, dynamic> json) {
    final Map<String, AlimentData> parsedAliments =
        ((json['aliments'] ?? {}) as Map).map((id, d) => MapEntry(
            id as String, AlimentData.fromJson(Map<String, dynamic>.from(d))));

    final List<String> parsedOrder = List<String>.from(json['order'] ?? []);

    final fullOrder = {
      ...parsedOrder,
      ...parsedAliments.keys,
    }.toList();

    return AlimentBankState(aliments: parsedAliments, order: fullOrder);
  }
}

class AlimentBank extends StateNotifier<AlimentBankState> {
  AlimentBank() : super(AlimentBankState(aliments: {}, order: []));

  static final instance = Provider<AlimentBank>((ref) => AlimentBank());

  void setAliment(String id, AlimentData data) {
    state = AlimentBankState(
      aliments: {...state.aliments, id: data},
      order: state.order.contains(id) ? state.order : [id, ...state.order],
    );
    save();
  }

  void setFirst(String id) {
    if (state.aliments.keys.contains(id)) {
      state = AlimentBankState(
        aliments: state.aliments,
        order: [id, ...state.order..removeWhere((otherId) => otherId == id)],
      );
    }
    save();
  }

  Future<void> save() {
    return StorageSolution.instance.saveJson('alimentBank', state.toJson());
  }

  Future<void> load() async {
    final json = await StorageSolution.instance.loadJson('alimentBank');
    if (json != null) {
      state = AlimentBankState.fromJson(json);
    }
  }

  Future<void> loadMerged() async {
    final sources = await StorageSolution.instance.loadSources();
    final mergedData = JsonHandler.mergeBaseAddon(
      sources['cloud']['aliments'] ?? {},
      sources['local']['aliments'] ?? {},
    );
    final mergedOrder = [
      ...sources['local']['order'] ?? [],
      ...sources['cloud']['order'] ?? [],
    ];

    state = AlimentBankState.fromJson(JsonHandler.processJson(
        {'aliments': mergedData, 'order': mergedOrder}));
    await save();
  }
}

final alimentBankProvider =
    StateNotifierProvider<AlimentBank, AlimentBankState>(
        (ref) => AlimentBank());
