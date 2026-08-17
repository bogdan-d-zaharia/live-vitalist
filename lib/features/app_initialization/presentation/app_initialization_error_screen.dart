import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:live_vitalist/features/app_initialization/presentation/controllers/app_initialization_provider.dart';

class AppInitializationErrorScreen extends ConsumerWidget {
  const AppInitializationErrorScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'The application could not be initialized.',
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 16.0),
                FilledButton(
                  onPressed: () => ref.invalidate(appInitializationProvider),
                  child: Text('Try again'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
