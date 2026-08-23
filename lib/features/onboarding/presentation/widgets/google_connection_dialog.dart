import 'package:flutter/material.dart';
import 'package:live_vitalist/core/presentation/widgets/custom_card.dart';

enum GoogleConnectionDialogType {
  accountNotFound,
  connectionFailed,
}

class GoogleConnectionDialog extends StatelessWidget {
  final GoogleConnectionDialogType type;
  const GoogleConnectionDialog({super.key, required this.type});

  @override
  Widget build(BuildContext context) {
    final (title, message) = switch (type) {
      GoogleConnectionDialogType.accountNotFound => (
          'Account not found',
          'We could not find a Live Vitalist account connected to this Google account. Please complete the onboarding first.',
        ),
      GoogleConnectionDialogType.connectionFailed => (
          'Google connection failed',
          'We could not connect with Google. Please check your internet connection and try again.',
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
                child: Center(child: Text('Continue')),
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
