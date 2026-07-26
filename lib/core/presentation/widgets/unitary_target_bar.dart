import 'package:flutter/material.dart';
import 'package:live_vitalist/core/domain/intervals.dart';
import 'package:live_vitalist/core/theme/palette.dart';

/// A widget that presents the progress as a bar filling, with
/// - `value` being the % it is filled,
/// - `start` being the % for the start of the desired interval shown,
/// - `end` being the % for the end of the desired interval shown.
/// all being numbers in the range [0.0, 1.0].
class UnitaryTargetBar extends StatelessWidget {
  final StrictInterval interval;
  final List<Widget> stackAddons;
  final double height;
  final double radius;

  const UnitaryTargetBar({
    super.key,
    required this.interval,
    this.stackAddons = const [],
    this.height = 12.0,
    this.radius = 6.0,
  });

  @override
  Widget build(BuildContext context) {
    final shadowColor = Palette.counterColor(context).withValues(alpha: 0.7);
    // TODO: Make reach corners round.
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius),
        color: Colors.orange,
      ),
      clipBehavior: Clip.antiAlias,
      height: height,
      child: Stack(
        alignment: Alignment.topLeft,
        fit: StackFit.expand,
        children: [
          FractionallySizedBox(
            alignment: Alignment.topLeft,
            widthFactor: interval.end.clamp(0.0, 1.0),
            child: Container(color: Colors.green),
          ),
          FractionallySizedBox(
            alignment: Alignment.topLeft,
            widthFactor: interval.start.clamp(0.0, 1.0),
            child: Container(color: Colors.lightGreen),
          ),
          FractionallySizedBox(
            alignment: Alignment.topRight,
            widthFactor: 1.0 - interval.value.clamp(0.0, 1.0),
            child: Container(color: shadowColor),
          ),
          ...stackAddons,
        ],
      ),
    );
  }
}
