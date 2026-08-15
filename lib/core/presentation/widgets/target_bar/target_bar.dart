import 'package:flutter/material.dart';
import 'package:live_vitalist/core/domain/interval_normalization.dart';
import 'package:live_vitalist/core/domain/intervals.dart';
import 'package:live_vitalist/core/presentation/widgets/target_bar/target_bar_draw_data.dart';
import 'package:live_vitalist/core/presentation/widgets/target_bar/unitary_target_bar.dart';

class TargetBar extends StatelessWidget {
  final LooseInterval interval;
  final NormalizationData normalizationData;
  final TargetBarDrawData? drawData;

  const TargetBar({
    super.key,
    required this.interval,
    this.normalizationData = NormalizationData.preset,
    this.drawData,
  });

  @override
  Widget build(BuildContext context) {
    final StrictInterval strict = interval.normalize(normalizationData);
    return UnitaryTargetBar(interval: strict, drawData: drawData);
  }
}
