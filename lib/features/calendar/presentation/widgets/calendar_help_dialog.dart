import 'package:flutter/material.dart';
import 'package:live_vitalist/core/presentation/widgets/mini_card.dart';
import 'package:live_vitalist/features/calendar/domain/calendar_constants.dart';
import 'package:live_vitalist/features/calendar/presentation/widgets/simple_calendar_item.dart';
import 'package:live_vitalist/core/presentation/widgets/labels_widget.dart';
import 'package:live_vitalist/features/settings/data/settings_data.dart';
import 'package:live_vitalist/l10n/app_localizations.dart';

class CalendarHelpDialog extends StatelessWidget {
  const CalendarHelpDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
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
                    l.calendarMaximum: Colors.lightGreen.withValues(alpha: 0.4),
                  l.calendarLeadingNutrient: Colors.lightGreen,
                  if (SettingsData.isComplexCalendar)
                    l.calendarMinimum: Colors.green,
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
