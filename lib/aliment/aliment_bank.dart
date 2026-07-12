import 'package:flutter/foundation.dart';
import 'package:live_vitalist/aliment/aliment_constants.dart';
import 'package:live_vitalist/aliment/aliment_data.dart';
import 'package:live_vitalist/storage/data/storage_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'aliment_bank.g.dart';

@immutable
class AlimentBankState {
  final Map<String, AlimentData> aliments;
  final List<String> order;

  const AlimentBankState({
    required this.aliments,
    required this.order,
  });

  Map<String, dynamic> toJson() => {
        // dot notation
        ...aliments.map((id, data) => MapEntry('aliments/$id', data.toJson())),

        // 'aliments': aliments.map((id, data) => MapEntry('$id', data.toJson())),
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

@Riverpod(keepAlive: true)
class AlimentBank extends _$AlimentBank {
  @override
  AlimentBankState build() {
    return AlimentBankState(aliments: {}, order: []);
  }

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
    return ref
        .read(storageProvider.notifier)
        .saveJson(AlimentConstants.alimentBankPath, state.toJson());
  }

  Future<void> load() async {
    final json = await ref
        .read(storageProvider.notifier)
        .loadJson(AlimentConstants.alimentBankPath);
    if (json != null) state = AlimentBankState.fromJson(json);
  }

  void setState(AlimentBankState newState) {
    state = newState;
    save();
  }
}
