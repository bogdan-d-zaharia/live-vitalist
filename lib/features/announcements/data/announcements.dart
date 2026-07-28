import 'package:flutter/material.dart';
import 'package:live_vitalist/features/legal/domain/legal_types.dart';
import 'package:live_vitalist/features/legal/legal_dialog.dart';
import 'package:live_vitalist/features/reports/domain/entities/week_report.dart';
import 'package:live_vitalist/features/reports/presentation/widgets/week_report_overlay.dart';

sealed class IAnnouncement {
  Future<void> pushAnnouncementPopup(BuildContext context);
}

class WeekReportAnnouncement implements IAnnouncement {
  final WeekReport weekReport;
  WeekReportAnnouncement(this.weekReport);

  @override
  Future<void> pushAnnouncementPopup(BuildContext context) async {
    if (!context.mounted) return;
    return showDialog(
      context: context,
      builder: (context) => WeekReportOverlay(weekReport: weekReport),
    );
  }
}

class LegalAnnouncement implements IAnnouncement {
  final List<LegalRequirement> requirements;
  LegalAnnouncement(this.requirements);

  @override
  Future<void> pushAnnouncementPopup(BuildContext context) async {
    if (!context.mounted) return;
    await showLegalDialog(context, requirements);
  }
}
