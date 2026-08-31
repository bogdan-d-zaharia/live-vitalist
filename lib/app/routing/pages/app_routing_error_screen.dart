import 'package:flutter/material.dart';
import 'package:live_vitalist/l10n/app_localizations.dart';

class AppRoutingErrorScreen extends StatelessWidget {
  const AppRoutingErrorScreen({super.key, this.error});

  final Exception? error;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(24.0),
            child: Text(
              error == null
                  ? l.appRoutingErrorMessage
                  : 'The requested page could not be opened:\n$error',
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }
}
