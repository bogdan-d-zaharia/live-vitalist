import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:live_vitalist/core/presentation/widgets/custom_card.dart';
import 'package:live_vitalist/features/legal/data/legal_handler.dart';
import 'package:live_vitalist/features/legal/domain/legal_types.dart';
import 'package:live_vitalist/features/legal/presentation/widgets/legal_prerequisites_text.dart';
import 'package:live_vitalist/l10n/app_localizations.dart';

class LegalDialog extends ConsumerWidget {
  final List<LegalRequirement> requirements;
  const LegalDialog({super.key, required this.requirements});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.all(24.0),
      child: CustomCard(
        logo: Icon(Icons.gavel_rounded),
        title: l.legalDialogTitle,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            LegalPrerequisitesText(),
            SizedBox(height: 8.0),
            Text(l.legalSettingsHint),
            SizedBox(height: 8.0),
            Wrap(
              alignment: WrapAlignment.end,
              spacing: 8.0,
              children: [
                FilledButton.tonal(
                  onPressed: () async {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(l.legalClosingApp),
                        duration: Duration(seconds: 2),
                      ),
                    );
                    await Future.delayed(Duration(seconds: 3));
                    SystemNavigator.pop();
                  },
                  child: Text(l.legalExitApp),
                ),
                FilledButton(
                  onPressed: () async {
                    await ref.read(legalHandlerProvider).accept(requirements);
                    if (context.mounted) Navigator.pop(context, true);
                  },
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

Future<bool> showLegalDialog(
  BuildContext context,
  List<LegalRequirement> requirements,
) async {
  final bool? isAccepted = await showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) => LegalDialog(requirements: requirements),
  );
  return isAccepted ?? false;
}
