import 'package:flutter/material.dart';
import 'package:live_vitalist/core/presentation/widgets/custom_card.dart';
import 'package:live_vitalist/l10n/app_localizations.dart';

enum ConnectionDialogType {
  accountNotFound,
  connectionFailed,
}

class ConnectionDialog extends StatelessWidget {
  final ConnectionDialogType type;
  final String provider;
  const ConnectionDialog(
      {super.key, required this.type, required this.provider});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final (title, message) = switch (type) {
      ConnectionDialogType.accountNotFound => (
          l.connectionDialogAccountNotFoundTitle,
          l.connectionDialogAccountNotFoundMessage(provider),
        ),
      ConnectionDialogType.connectionFailed => (
          l.connectionDialogConnectionFailedTitle(provider),
          l.connectionDialogConnectionFailedMessage(provider),
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

Future<void> showConnectionDialog(
  BuildContext context, {
  required ConnectionDialogType type,
  required String provider,
}) async {
  return showDialog(
    context: context,
    builder: (context) => ConnectionDialog(type: type, provider: provider),
  );
}
