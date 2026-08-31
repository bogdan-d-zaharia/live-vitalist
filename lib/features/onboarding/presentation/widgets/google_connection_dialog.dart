import 'package:flutter/material.dart';
import 'package:live_vitalist/core/presentation/widgets/custom_card.dart';
import 'package:live_vitalist/l10n/app_localizations.dart';

enum GoogleConnectionDialogType {
  accountNotFound,
  connectionFailed,
}

class GoogleConnectionDialog extends StatelessWidget {
  final GoogleConnectionDialogType type;
  const GoogleConnectionDialog({super.key, required this.type});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final (title, message) = switch (type) {
      GoogleConnectionDialogType.accountNotFound => (
          l.googleConnectionDialogAccountNotFoundTitle,
          l.googleConnectionDialogAccountNotFoundMessage,
        ),
      GoogleConnectionDialogType.connectionFailed => (
          l.googleConnectionDialogConnectionFailedTitle,
          l.googleConnectionDialogConnectionFailedMessage,
        ),
    };

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.all(24.0),
      child: CustomCard(
        padding: EdgeInsets.fromLTRB(26.0, 24.0, 26.0, 12.0),
        logo: Icon(Icons.error_outline_rounded),
        title: title,
        child: Column(
          spacing: 4.0,
          children: [
            Text(
              message,
              textAlign: TextAlign.center,
            ),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: SizedBox(
                width: double.infinity,
                child: Center(child: Text(l.actionContinue)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Future<void> showGoogleConnectionDialog(
  BuildContext context, {
  required GoogleConnectionDialogType type,
}) async {
  return showDialog(
    context: context,
    builder: (context) => GoogleConnectionDialog(type: type),
  );
}
