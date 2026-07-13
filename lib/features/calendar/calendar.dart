import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart' as intl;
import 'package:live_vitalist/core/presentation/widgets/custom_card.dart';
import 'package:live_vitalist/day/data/day_provider.dart';
import 'package:live_vitalist/features/calendar/domain/calendar_constants.dart';
import 'package:live_vitalist/features/calendar/widgets/calendar_help_dialog.dart';
import 'package:live_vitalist/features/calendar/widgets/calendar_item.dart';
import 'package:live_vitalist/features/calendar/widgets/dotted_line.dart';
import 'package:live_vitalist/icon_button.dart';
import 'package:live_vitalist/settings_data.dart';

class WeekCalendar extends ConsumerWidget {
  const WeekCalendar({super.key});

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
        onTap: () => showDialog(
          context: context,
          builder: (context) => CalendarHelpDialog(),
        ),
      ),
      child: SizedBox(
        height: CalendarConstants.itemHeight,
        child: Stack(
          children: [
            ListView.builder(
              scrollDirection: Axis.horizontal,
              reverse: true,
              itemBuilder: (context, index) {
                final date = now.normalized.subtract(Duration(days: index));
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
              bottom: CalendarConstants.labelHeight +
                  1.0 /
                      1.5 *
                      (CalendarConstants.itemHeight -
                          CalendarConstants.labelHeight) -
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
