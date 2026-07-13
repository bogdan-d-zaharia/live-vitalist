import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart' as intl;
import 'package:live_vitalist/day/day_extensions.dart';

import 'aliment/aliment_bank.dart';
import 'custom_card.dart';
import 'day/day_provider.dart';
import 'icon_button.dart';
import 'labels_widget.dart';
import 'nutrient/nutrient.dart';
import 'nutrient/nutrient_provider.dart';
import 'palette.dart';
import 'settings_data.dart';

const double itemHeight = 80.0;
const double labelHeight = 26.0;

class WeekCalendar extends ConsumerWidget {
  const WeekCalendar({super.key});

  void showHelp(BuildContext context) {
    final intake = {
      Nutrient(
        translations: {'ENG': 'Calories'},
        unit: 'kcal',
        lowerLimit: 2000.0,
        upperLimit: 2500.0,
      ): 2600.0,
      Nutrient(
        translations: {'ENG': 'Fats'},
        unit: 'g',
        lowerLimit: 70.0,
        upperLimit: 100.0,
      ): 30.0,
      Nutrient(
        translations: {'ENG': 'Saturated fats'},
        unit: 'g',
        lowerLimit: 16.0,
        upperLimit: 25.0,
      ): 120.0,
    };

    final simpleWid = SizedBox(
      height: 100.0,
      child: SimpleCalendarItem(
        intake: intake,
        title: '4/5',
        isSelected: true,
      ),
    );

    showDialog(
      context: context,
      builder: (context) => Center(
        child: MiniCard(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                LabelsWidget(
                  map: {
                    if (SettingsData.isComplexCalendar)
                      'Maximum': Colors.lightGreen.withValues(alpha: 0.4),
                    'Leading nutrient': Colors.lightGreen,
                    if (SettingsData.isComplexCalendar) 'Minimum': Colors.green,
                  },
                ),
                const SizedBox(width: 24.0),
                Padding(
                  padding: const EdgeInsets.only(top: 24.0, bottom: 12.0),
                  child: simpleWid,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final now = DateTime.now().normalized;
    final dates = ref.watch(selectedDatesProvider);
    final datesNotifier = ref.read(selectedDatesProvider.notifier);

    return CustomCard(
      logo: const Icon(Icons.view_week),
      title: "Calendar",
      action: MyIconButton(
        icon: const Icon(Icons.help_outline_rounded, size: 22.0),
        onTap: () => showHelp(context),
      ),
      child: SizedBox(
        height: itemHeight,
        child: Stack(
          children: [
            ListView.builder(
              scrollDirection: Axis.horizontal,
              reverse: true,
              itemBuilder: (context, index) {
                final date = now.subtract(Duration(days: index));
                return Material(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(8.0),
                  clipBehavior: Clip.hardEdge,
                  child: InkWell(
                    onTap: () => datesNotifier.setSingleDate(date),
                    onLongPress: () => datesNotifier.toggleDate(date),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 6.0),
                      child: CalendarItem(
                        date: date,
                        title: intl.DateFormat(
                                SettingsData.isMonthDay ? 'M/d' : 'd/M')
                            .format(date),
                        isSelected: dates.contains(date),
                      ),
                    ),
                  ),
                );
              },
            ),
            Positioned(
              bottom: labelHeight +
                  1.0 / 1.5 * (itemHeight - labelHeight) -
                  1.25 / 2.0,
              child: const DottedLine(
                dotDiameter: 1.25,
                dotSpacing: 2.25,
                color: Colors.green,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CalendarItem extends ConsumerWidget {
  const CalendarItem({
    super.key,
    required this.title,
    required this.date,
    required this.isSelected,
  });

  final String title;
  final DateTime date;
  final bool isSelected;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dayMap = ref.watch(dayCacheProvider);
    final bank = ref.watch(alimentBankProvider);
    final nutrients = ref.watch(nutrientsProvider);

    final day = dayMap[date];
    if (day != null) {
      final intakeById = day.readIntake(bank);
      final intakeByNutrient = <Nutrient, double>{
        /* Makes sure the leading nutrient is first
           to show it specially. */
        nutrients.data[nutrients.order.first]!: 0.0,
      };

      for (final entry in intakeById.entries) {
        final nutrient = nutrients.data[entry.key];
        if (nutrient != null && !nutrient.tags.contains('disabled')) {
          intakeByNutrient[nutrient] = entry.value;
        }
      }

      return SimpleCalendarItem(
        intake: intakeByNutrient,
        title: title,
        isSelected: isSelected,
      );
    }

    ref.read(dayCacheProvider.notifier).load(date);
    return const Center(
        child: CircularProgressIndicator(strokeCap: StrokeCap.round));
  }
}

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
        margin: const EdgeInsets.only(bottom: labelHeight),
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
                              ? Colors.white.withOpacity(0.6)
                              : Colors.black.withOpacity(0.4),
                        ),
                      ],
                    )
                  : Palette.calendarItem.copyWith(
                      color: Colors.grey.withOpacity(0.8),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}

class DottedLine extends StatelessWidget {
  const DottedLine({
    required this.dotDiameter,
    required this.dotSpacing,
    required this.color,
    super.key,
  });

  final double dotDiameter;
  final double dotSpacing;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: dotDiameter,
      child: CustomPaint(
        size: Size(1000.0, 100.0),
        painter: DottedLinePainter(
          dotDiameter: dotDiameter,
          dotSpacing: dotSpacing,
          color: color,
        ),
      ),
    );
  }
}

class DottedLinePainter extends CustomPainter {
  const DottedLinePainter({
    required this.dotDiameter,
    required this.dotSpacing,
    required this.color,
  });

  final double dotDiameter;
  final double dotSpacing;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..style = PaintingStyle.fill
      ..color = color;

    for (double i = 0.0; i < size.width; i += dotDiameter + dotSpacing) {
      canvas.drawCircle(Offset(i, dotDiameter / 2.0), dotDiameter / 2.0, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
