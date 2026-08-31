import 'package:flutter/material.dart';
import 'package:live_vitalist/core/theme/app_text_styles_theme.dart';
import 'package:live_vitalist/core/theme/palette.dart';
import 'package:live_vitalist/features/reports/presentation/theme/report_styles.dart';
import 'package:live_vitalist/l10n/app_localizations.dart';

class ConsistencyStrip extends StatelessWidget {
  final List<bool> days;
  const ConsistencyStrip({super.key, required this.days});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final labels = [
      l.reportsMondayShort,
      l.reportsTuesdayShort,
      l.reportsWednesdayShort,
      l.reportsThursdayShort,
      l.reportsFridayShort,
      l.reportsSaturdayShort,
      l.reportsSundayShort,
    ];
    final labelStyle = ReportStyles.dayViewLabel.copyWith(height: 1.0);
    final count = days.fold(0, (count, day) => count += day ? 1 : 0);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Text(l.reportsConsistency, style: ReportStyles.dayViewBold),
            Spacer(),
            Text(
              l.reportsDaysOnTarget(count, days.length),
              style: AppTextStylesTheme.of(context).highlight,
            ),
          ],
        ),
        SizedBox(height: 14.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            for (int i = 0; i < days.length; ++i)
              Column(
                children: [
                  Text(labels[i], style: labelStyle),
                  SizedBox(height: 8.0),
                  Container(
                    width: 22.0,
                    height: 22.0,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: days[i] ? Palette.green : Colors.transparent,
                      border: Border.all(color: Palette.green, width: 1.5),
                    ),
                    child: days[i]
                        ? Icon(
                            Icons.check_rounded,
                            size: 13.0,
                            color: Colors.black,
                          )
                        : null,
                  ),
                ],
              ),
          ],
        ),
      ],
    );
  }
}
