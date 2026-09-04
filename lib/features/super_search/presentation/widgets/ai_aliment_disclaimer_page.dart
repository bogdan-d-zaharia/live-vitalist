import 'package:flutter/material.dart';
import 'package:live_vitalist/core/presentation/widgets/custom_alert_dialog.dart';
import 'package:live_vitalist/features/settings/data/settings_data.dart';
import 'package:live_vitalist/l10n/app_localizations.dart';

Future<bool> showAiAlimentDisclaimer(BuildContext context) async {
  if (SettingsData.hasAcceptedAiAlimentDisclaimer) return true;

  final result = await showDialog<_AiAlimentDisclaimerResult>(
    context: context,
    builder: (_) => const AiAlimentDisclaimerPage(),
  );

  if (result == _AiAlimentDisclaimerResult.agreeAndDoNotShowAgain) {
    SettingsData.hasAcceptedAiAlimentDisclaimer = true;
  }

  return result != null;
}

enum _AiAlimentDisclaimerResult { agree, agreeAndDoNotShowAgain }

class AiAlimentDisclaimerPage extends StatelessWidget {
  const AiAlimentDisclaimerPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);

    return CustomAlertDialog(
      icon: Icon(Icons.warning_amber_rounded),
      title: Text(l.superSearchAiDisclaimerTitle),
      content: Text(l.superSearchAiDisclaimerMessage),
      actions: [
        Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () => Navigator.pop(
                  context,
                  _AiAlimentDisclaimerResult.agreeAndDoNotShowAgain,
                ),
                child: Text(
                  l.superSearchAiDisclaimerAgreeAndDoNotShowAgain,
                ),
              ),
            ),
            Wrap(
              alignment: WrapAlignment.end,
              spacing: 8.0,
              children: [
                FilledButton.tonal(
                  onPressed: () => Navigator.pop(context),
                  child: Text(l.actionCancel),
                ),
                FilledButton(
                  onPressed: () => Navigator.pop(
                    context,
                    _AiAlimentDisclaimerResult.agree,
                  ),
                  child: Text(l.legalAgree),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
