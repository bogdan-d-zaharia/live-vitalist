import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../file_handler.dart';
import '../json_handler.dart';
import 'aliment.dart';

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
        (json['aliments'] as Map<String, dynamic>).map((id, d) =>
            MapEntry(id, AlimentData.fromJson(Map<String, dynamic>.from(d))));

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

  void moveToFront(String alimentID) {
    if (!state.aliments.containsKey(alimentID)) return;
    final updatedOrder = [...state.order]
      ..remove(alimentID)
      ..insert(0, alimentID);
    state = AlimentBankState(aliments: state.aliments, order: updatedOrder);
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
    final merged = JsonHandler.mergeBaseAddon(internet, local);
    state = AlimentBankState.fromJson(JsonHandler.processJson(merged));
    await save();
  }

  AlimentData getAliment(String id) {
    final aliment = state.aliments[id];
    if (aliment == null) throw Exception('Aliment not found: $id');
    return aliment;
  }
}

final alimentBankProvider =
    StateNotifierProvider<AlimentBank, AlimentBankState>((ref) {
  return AlimentBank();
});
