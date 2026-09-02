import 'package:flutter/foundation.dart';
import 'package:live_vitalist/features/aliment_bank/domain/aliment_bank_state.dart';
import 'package:live_vitalist/features/aliment/domain/aliment_data.dart';

part 'temporary_aliment.dart';
part 'instanced_aliment.dart';

@immutable
sealed class Aliment {
  final double servingSize;
  final String unit;

  const Aliment({
    required this.servingSize,
    required this.unit,
  });

  Map<String, dynamic> toJson();
  AlimentData readDataRef(AlimentBankState bank);
  Aliment copyWith({double? servingSize, String? unit});
}
