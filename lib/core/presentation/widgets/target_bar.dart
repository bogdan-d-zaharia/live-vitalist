import 'package:flutter/material.dart';
import 'package:live_vitalist/core/domain/interval_normalization.dart';
import 'package:live_vitalist/core/domain/intervals.dart';
import 'package:live_vitalist/core/presentation/widgets/unitary_target_bar.dart';

class TargetBar extends StatelessWidget {
  final LooseInterval interval;
  final NormalizationData normalizationData;
  final List<Widget> stackAddons;
  final double height;
  final double radius;

  const TargetBar({
    super.key,
    required this.interval,
    this.normalizationData = NormalizationData.preset,
    this.stackAddons = const [],
    this.height = 12.0,
    this.radius = 6.0,
  });

  @override
  Widget build(BuildContext context) {
    final StrictInterval strict = interval.normalize(normalizationData);
    return UnitaryTargetBar(
      interval: strict,
      stackAddons: stackAddons,
      height: height,
      radius: radius,
    );
  }
}
