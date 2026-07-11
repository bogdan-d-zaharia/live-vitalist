import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:live_vitalist/custom_card.dart';
import 'package:live_vitalist/settings/data/settings_constants.dart';
import 'package:live_vitalist/settings/presentation/controllers/settings_controller.dart';
import 'package:live_vitalist/settings/presentation/widgets/settings_dialogs.dart';

class DataDeletionPage extends ConsumerWidget {
  const DataDeletionPage({super.key});

  Future<void> _executeDeleteEverythingWorkflow(
      BuildContext context, WidgetRef ref) async {
    final controller = ref.read(settingsControllerProvider.notifier);

    if (controller.isFirebase) {
      final reauth = await showDialog<bool>(
        context: context,
        builder: (context) => const ReauthenticateDialog(),
      );
      if (reauth != true) return;
    }

    await controller.executeDeleteEverything();

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Closing the app...'),
            duration: Duration(seconds: 2)),
      );
    }

    await Future.delayed(const Duration(seconds: 3));
    SystemNavigator.pop();
  }

  void _showDeleteInternetConfirmation(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => ConfirmDeletionDialog(
        text: SettingsConstants.deleteInternet2,
        onConfirm: () async {
          final reauth = await showDialog<bool>(
            context: context,
            builder: (context) => const ReauthenticateDialog(),
          );
          if (reauth == true) {
            await ref
                .read(settingsControllerProvider.notifier)
                .deleteOnlineAccount();
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isFirebase =
        ref.watch(settingsControllerProvider.notifier).isFirebase;

    return Scaffold(
      appBar: AppBar(title: const Text('Account Deletion')),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: ListView(
          children: [
            if (isFirebase)
              CustomCard(
                logo: const Icon(Icons.no_accounts_rounded),
                title: 'Account and data deletion',
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(SettingsConstants.deleteInternet1),
                    TextButton(
                      onPressed: () =>
                          _showDeleteInternetConfirmation(context, ref),
                      child: const Text('Permanently delete online data'),
                    ),
                  ],
                ),
              ),
            CustomCard(
              logo: const Icon(Icons.no_accounts_rounded),
              title: 'Account and data deletion',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(SettingsConstants.deleteAll1),
                  TextButton(
                    onPressed: () => showDialog(
                      context: context,
                      builder: (context) => ConfirmDeletionDialog(
                        text: SettingsConstants.deleteAll2,
                        onConfirm: () =>
                            _executeDeleteEverythingWorkflow(context, ref),
                      ),
                    ),
                    child: const Text('Permanently delete all data'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
