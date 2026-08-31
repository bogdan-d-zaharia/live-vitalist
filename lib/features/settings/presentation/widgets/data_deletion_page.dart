import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:live_vitalist/core/presentation/widgets/custom_card.dart';
import 'package:live_vitalist/features/settings/presentation/controllers/settings_controller.dart';
import 'package:live_vitalist/features/settings/presentation/widgets/settings_dialogs.dart';
import 'package:live_vitalist/l10n/app_localizations.dart';

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

    final deleted = await controller.executeDeleteEverything();

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(deleted
                ? AppLocalizations.of(context).legalClosingApp
                : AppLocalizations.of(context).settingsDeletionFailed),
            duration: const Duration(seconds: 2)),
      );
    }

    if (!deleted) return;

    await Future.delayed(const Duration(seconds: 3));
    SystemNavigator.pop();
  }

  void _showDeleteInternetConfirmation(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    showDialog(
      context: context,
      builder: (context) => ConfirmDeletionDialog(
        text: l.settingsDeleteOnlineConfirmation,
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
    final l = AppLocalizations.of(context);
    final isFirebase =
        ref.watch(settingsControllerProvider.notifier).isFirebase;

    return Scaffold(
      appBar: AppBar(title: Text(l.settingsAccountDeletion)),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: ListView(
          children: [
            // TODO: Add all records (that are now local) to queue.
            if (isFirebase)
              CustomCard(
                logo: const Icon(Icons.no_accounts_rounded),
                title: l.settingsAccountAndDataDeletion,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(l.settingsDeleteOnlineDescription),
                    TextButton(
                      onPressed: () =>
                          _showDeleteInternetConfirmation(context, ref),
                      child: Text(l.settingsPermanentlyDeleteOnlineData),
                    ),
                  ],
                ),
              ),
            CustomCard(
              logo: const Icon(Icons.no_accounts_rounded),
              title: l.settingsAccountAndDataDeletion,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(l.settingsDeleteAllDescription),
                  TextButton(
                    onPressed: () => showDialog(
                      context: context,
                      builder: (context) => ConfirmDeletionDialog(
                        text: l.settingsDeleteAllConfirmation,
                        onConfirm: () =>
                            _executeDeleteEverythingWorkflow(context, ref),
                      ),
                    ),
                    child: Text(l.settingsPermanentlyDeleteAllData),
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
