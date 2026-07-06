import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:live_vitalist/aliment/aliment_data.dart';

import 'package:live_vitalist/file_handler.dart';
import 'package:live_vitalist/json_handler.dart';

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
    return StorageHandler.saveJson('alimentBank', state.toJson(),
        doBackup: true);
  }

  Future<void> load() async {
    final json = await StorageHandler.loadJson('alimentBank');
    if (json != null) {
      state = AlimentBankState.fromJson(json);
    }
  }

  Future<void> loadMerged() async {
    final local = await FileHandler.loadJson('alimentBank') ?? {};
    final internet = await FirebaseHandler.loadJson('alimentBank') ?? {};
    final mergedData = JsonHandler.mergeBaseAddon(
        internet['aliments'] ?? {}, local['aliments'] ?? {});
    final mergedOrder = [...local['order'] ?? [], ...internet['order'] ?? []];
    state = AlimentBankState.fromJson(JsonHandler.processJson(
        {'aliments': mergedData, 'order': mergedOrder}));
    await save();
  }
}

final alimentBankProvider =
    StateNotifierProvider<AlimentBank, AlimentBankState>(
        (ref) => AlimentBank());
