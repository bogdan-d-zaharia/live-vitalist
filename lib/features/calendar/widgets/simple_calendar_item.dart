import 'package:flutter/material.dart';
import 'package:live_vitalist/features/calendar/domain/calendar_constants.dart';
import 'package:live_vitalist/nutrient/domain/nutrient.dart';
import 'package:live_vitalist/nutrient/domain/nutrient_extensions.dart';
import 'package:live_vitalist/core/theme/palette.dart';
import 'package:live_vitalist/settings/data/settings_data.dart';

class SimpleCalendarItem extends StatelessWidget {
  const SimpleCalendarItem({
    required this.intake,
    required this.title,
    required this.isSelected,
    super.key,
  });

  final Map<Nutrient, double> intake;
  final String title;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    final Nutrient? kcals = intake.keys.firstOrNull;

    (double?, double?, double?) calculateMinMaxAverage(
        Map<Nutrient, double> values) {
      double min = double.infinity;
      double max = 0.0;
      double sum = 0.0;
      int num = 0;

      for (final nutrient in values.keys) {
        final double? ratio = nutrient.getRatio(values[nutrient]);
        if (ratio != null) {
          min = ratio < min ? ratio : min;
          max = ratio > max ? ratio : max;
          sum += ratio;
          num++;
        }
      }

      if (num == 0 || min == double.infinity || max == 0.0) {
        return (null, null, null);
      }

      return (min, max, sum / num);
    }

    (double, double, double) forceMinMaxAverage(Map<Nutrient, double> values) {
      final (minim, maxim, avg) = calculateMinMaxAverage(values);
      return (minim ?? 0.0, maxim ?? 0.0, avg ?? 0.0);
    }

    Widget? bars;
    if (intake.values.every((v) => v == 0.0)) {
      bars = null;
    } else {
      final (minim, maxim, _) = forceMinMaxAverage(intake);
      final kcalRatio = kcals?.getRatio(intake[kcals]);

      bars = Container(
        margin: const EdgeInsets.only(bottom: CalendarConstants.labelHeight),
        width: 12.0,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(6.0)),
        clipBehavior: Clip.hardEdge,
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            if (SettingsData.isComplexCalendar)
              FractionallySizedBox(
                heightFactor: (maxim / 1.5).clamp(0.0, 1.0),
                child:
                    Container(color: Colors.lightGreen.withValues(alpha: 0.4)),
              ),
            FractionallySizedBox(
              heightFactor: ((kcalRatio ?? 0.0) / 1.5).clamp(0.0, 1.0),
              child: Container(color: Colors.lightGreen),
            ),
            if (SettingsData.isComplexCalendar)
              FractionallySizedBox(
                heightFactor: (minim / 1.5).clamp(0.0, 1.0),
                child: Container(color: Colors.green),
              ),
          ],
        ),
      );
    }

    return SizedBox(
      width: 36.0,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          if (bars != null) bars,
          Padding(
            padding: const EdgeInsets.only(bottom: 6.0),
            child: Text(
              title,
              style: isSelected
                  ? Palette.calendarItem.copyWith(
                      color: Palette.isDarkMode(context)
                          ? Colors.white
                          : Colors.black,
                      shadows: [
                        Shadow(
                          offset: const Offset(0, 1),
                          blurRadius: 12.0,
                          color: Palette.isDarkMode(context)
                              ? Colors.white.withValues(alpha: 0.6)
                              : Colors.black.withValues(alpha: 0.4),
                        ),
                      ],
                    )
                  : Palette.calendarItem.copyWith(
                      color: Colors.grey.withValues(alpha: 0.8),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
