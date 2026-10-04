import 'package:flutter/foundation.dart';
import 'package:live_vitalist/core/auth/data/apple_credential_source.dart';
import 'package:live_vitalist/core/auth/domain/credential_source.dart';
import 'package:live_vitalist/core/auth/data/google_credential_source.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:live_vitalist/core/presentation/widgets/custom_card.dart';
import 'package:live_vitalist/core/presentation/widgets/mini_card.dart';
import 'package:live_vitalist/features/settings/presentation/controllers/settings_controller.dart';
import 'package:live_vitalist/features/settings/presentation/widgets/data_deletion_page.dart';
import 'package:live_vitalist/features/settings/data/settings_data.dart';
import 'package:live_vitalist/features/settings/presentation/widgets/language_dropdown.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:live_vitalist/l10n/app_localizations.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsState();
}

class _SettingsState extends ConsumerState<SettingsScreen> {
  bool _isConnecting = false;

  Future<void> _handleConnection(CredentialSource credentials) async {
    if (_isConnecting) return;
    setState(() => _isConnecting = true);
    await ref.read(settingsControllerProvider.notifier).connect(credentials);
    if (mounted) setState(() => _isConnecting = false);
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final showApple = !kIsWeb && defaultTargetPlatform == TargetPlatform.iOS;
    final isFirebase =
        ref.watch(settingsControllerProvider.notifier).isFirebase;

    final googleButton = TextButton(
      onPressed: _isConnecting
          ? null
          : () => _handleConnection(ref.read(googleCredentialSourceProvider)),
      child: Text(l.settingsConnectWithGoogle),
    );
    final connectWidget = !showApple
        ? googleButton
        : Wrap(
            children: [
              googleButton,
              TextButton(
                onPressed: _isConnecting
                    ? null
                    : () => _handleConnection(
                        ref.read(appleCredentialSourceProvider)),
                child: Text(l.settingsConnectWithApple),
              ),
            ],
          );

    return Scaffold(
      appBar: AppBar(
        title: Text(l.settingsTitle),
        actions: [
          PopupMenuButton<String>(
            icon: Row(
              children: [
                Text(l.settingsDocuments),
                SizedBox(
                  width: 32.0,
                  height: 32.0,
                  child: Icon(Icons.more_vert_rounded),
                ),
              ],
            ),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24.0)),
            clipBehavior: Clip.hardEdge,
            color: Theme.of(context).colorScheme.surfaceContainerHigh,
            itemBuilder: (context) => [
              PopupMenuItem(
                onTap: () => launchUrl(
                    Uri.parse(
                        'https://live-vitalist.notion.site/Privacy-Policy-Live-Vitalist-1d612e3b9fc280d1be5cd9a718709560'),
                    mode: LaunchMode.externalApplication),
                child: Text(l.settingsPrivacyPolicy),
              ),
              PopupMenuItem(
                onTap: () => launchUrl(
                    Uri.parse(
                        'https://live-vitalist.notion.site/Terms-of-Use-Live-Vitalist-1d612e3b9fc28053a196f93d6c739858'),
                    mode: LaunchMode.externalApplication),
                child: Text(l.settingsTermsOfUse),
              ),
              PopupMenuItem(
                onTap: () => launchUrl(Uri(
                    scheme: 'mailto',
                    path: 'livevitalist@gmail.com',
                    query: Uri.encodeFull('subject=Feedback&body=Hello!'))),
                child: Text(l.settingsSendFeedback),
              ),
              PopupMenuItem(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const DataDeletionPage(),
                  ),
                ),
                child: Text(l.settingsDataDeletion),
              ),
            ],
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: ListView(
          children: [
            if (!isFirebase)
              CustomCard(
                logo: const Icon(Icons.cloud_upload_rounded),
                title: l.settingsCloudBackup,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(l.settingsCloudBackupMessage),
                    const SizedBox(height: 12.0),
                    connectWidget,
                  ],
                ),
              ),
            MiniCard(child: LanguageDropdown()),
            MiniCard(
              child: Row(
                children: [
                  const SizedBox(width: 16.0),
                  Checkbox(
                    value: SettingsData.isMonthDay,
                    onChanged: (val) {
                      if (val == null) return;
                      setState(() => SettingsData.isMonthDay = val);
                    },
                  ),
                  Expanded(child: Text(l.settingsUseMonthDayFormat)),
                  const SizedBox(width: 12.0),
                ],
              ),
            ),
            MiniCard(
              child: Row(
                children: [
                  const SizedBox(width: 16.0),
                  Checkbox(
                    value: SettingsData.isComplexCalendar,
                    onChanged: (val) {
                      if (val == null) return;
                      setState(() => SettingsData.isComplexCalendar = val);
                    },
                  ),
                  Expanded(child: Text(l.settingsUseComplexCalendar)),
                  const SizedBox(width: 12.0),
                ],
              ),
            ),
            MiniCard(
              child: Row(
                children: [
                  const SizedBox(width: 16.0),
                  Checkbox(
                    value: SettingsData.isShowCalorieDistribution,
                    onChanged: (val) {
                      if (val == null) return;
                      setState(
                          () => SettingsData.isShowCalorieDistribution = val);
                    },
                  ),
                  Expanded(child: Text(l.settingsShowMacroDistribution)),
                  const SizedBox(width: 12.0),
                ],
              ),
            ),
            MiniCard(
              child: Row(
                children: [
                  const SizedBox(width: 16.0),
                  Checkbox(
                    value: SettingsData.isShowOmegaBalance,
                    onChanged: (val) {
                      if (val == null) return;
                      setState(() => SettingsData.isShowOmegaBalance = val);
                    },
                  ),
                  Expanded(child: Text(l.settingsShowOmegaBalance)),
                  const SizedBox(width: 12.0),
                ],
              ),
            ),
            MiniCard(
              child: Row(
                children: [
                  const SizedBox(width: 16.0),
                  Checkbox(
                    value: SettingsData.isShowNutrientProgress,
                    onChanged: (val) {
                      if (val == null) return;
                      setState(() => SettingsData.isShowNutrientProgress = val);
                    },
                  ),
                  Expanded(child: Text(l.settingsShowNutrientProgress)),
                  const SizedBox(width: 12.0),
                ],
              ),
            ),
            const SizedBox(height: 12.0),
          ],
        ),
      ),
    );
  }
}
