import 'package:flutter/material.dart';
import 'package:live_vitalist/core/presentation/widgets/custom_card.dart';
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

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.all(24.0),
      child: CustomCard(
        logo: Icon(Icons.warning_amber_rounded),
        title: l.superSearchAiDisclaimerTitle,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(l.superSearchAiDisclaimerMessage),
            SizedBox(height: 8.0),
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
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                FilledButton.tonal(
                  onPressed: () => Navigator.pop(context),
                  child: Text(l.actionCancel),
                ),
                SizedBox(width: 8.0),
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
      ),
    );
  }
}
