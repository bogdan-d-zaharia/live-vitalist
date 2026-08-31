import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:live_vitalist/features/app_initialization/presentation/controllers/app_initialization_provider.dart';
import 'package:live_vitalist/l10n/app_localizations.dart';

class AppInitializationErrorScreen extends ConsumerWidget {
  const AppInitializationErrorScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  l.appInitializationErrorMessage,
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 16.0),
                FilledButton(
                  onPressed: () => ref.invalidate(appInitializationProvider),
                  child: Text(l.actionTryAgain),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
