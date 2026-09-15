import 'package:flutter/material.dart';
import 'package:live_vitalist/core/domain/intervals.dart';
import 'package:live_vitalist/core/presentation/widgets/target_bar/target_bar_draw_data.dart';
import 'package:live_vitalist/core/presentation/widgets/target_bar/target_bar_draw_helper.dart';

/// A widget that presents the progress as a bar filling, with
/// - `value` being the % it is filled,
/// - `start` being the % for the start of the desired interval shown,
/// - `end` being the % for the end of the desired interval shown.
/// all being numbers in the range [0.0, 1.0].
class UnitaryTargetBar extends StatelessWidget {
  final StrictInterval interval;
  final TargetBarDrawData drawData;

  const UnitaryTargetBar({
    super.key,
    required this.interval,
    TargetBarDrawData? drawData,
  }) : drawData = drawData ?? const TargetBarDrawData();

  /// A(M) + d (linear),
  /// A in [-1, 1] (alignment),
  /// M [W/2, 1-W/2] (middle),
  /// )
  //
  /// (1) M = 1/2 => A = 0 => `d = -1/2 * s`
  ///
  /// (2) M = 1-w/2 => A = 1
  ///
  /// Rise-Over-Run from (1), (2) => `s = 2 / (1 - w)`
  static double getAlignment(double l, double u) {
    final m = (l + u) / 2.0;
    final w = u - l;
    if (w >= 1.0) return 0.0;
    final s = 2.0 / (1.0 - w);
    final d = -0.5 * s;
    final a = s * m + d;
    return a;
  }

  @override
  Widget build(BuildContext context) {
    final width = interval.end - interval.start;
    final alignment = getAlignment(interval.start, interval.end);
    final shade = Colors.green.withValues(alpha: 0.8);
    final pillFSB = FractionallySizedBox(
      alignment: Alignment(alignment, 0.0),
      widthFactor: width.clamp(0.0, 1.0),
      child: drawData.pill ?? Container(color: shade),
    );

    final shadowColor = getShadowColor(context, 0.7);
    final shadowFSB = FractionallySizedBox(
      alignment: Alignment.topRight,
      widthFactor: 1.0 - interval.value.clamp(0.0, 1.0),
      child: Container(color: shadowColor),
    );

    final stackChildren = [shadowFSB, ...drawData.stackAddons]
      ..insert(drawData.isPillForeground ? 1 : 0, pillFSB);

    // TODO: Make reach corners round.
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(drawData.radius),
        color: Colors.lightGreen,
      ),
      clipBehavior: Clip.antiAlias,
      height: drawData.height,
      child: Stack(
        alignment: Alignment.topLeft,
        fit: StackFit.expand,
        children: stackChildren,
      ),
    );
  }
}
