import 'package:flutter/material.dart';
import 'package:live_vitalist/core/presentation/widgets/mini_card.dart';
import 'package:live_vitalist/features/calendar/domain/calendar_constants.dart';
import 'package:live_vitalist/features/calendar/widgets/simple_calendar_item.dart';
import 'package:live_vitalist/labels_widget.dart';
import 'package:live_vitalist/settings_data.dart';

class CalendarHelpDialog extends StatelessWidget {
  const CalendarHelpDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
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
                child: SizedBox(
                  height: 100.0,
                  child: SimpleCalendarItem(
                    intake: CalendarConstants.helpExampleIntake,
                    title: '4/5',
                    isSelected: true,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
