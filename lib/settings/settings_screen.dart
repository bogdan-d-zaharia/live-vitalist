import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:live_vitalist/core/presentation/widgets/custom_card.dart';
import 'package:live_vitalist/core/presentation/widgets/mini_card.dart';
import 'package:live_vitalist/palette.dart';
import 'package:live_vitalist/settings/presentation/controllers/settings_controller.dart';
import 'package:live_vitalist/settings/presentation/widgets/data_deletion_page.dart';
import 'package:live_vitalist/settings_data.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsState();
}

class _SettingsState extends ConsumerState<SettingsScreen> {
  void _handleGoogleConnection() async {
    final success =
        await ref.read(settingsControllerProvider.notifier).connectWithGoogle();
    if (success && mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final isFirebase =
        ref.watch(settingsControllerProvider.notifier).isFirebase;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        actions: [
          PopupMenuButton<String>(
            icon: const Row(
              children: [
                Text('Documents'),
                SizedBox(
                    width: 32.0,
                    height: 32.0,
                    child: Icon(Icons.more_vert_rounded)),
              ],
            ),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24.0)),
            clipBehavior: Clip.hardEdge,
            color: Palette.isDarkMode(context) ? Colors.grey[800] : null,
            itemBuilder: (context) => [
              PopupMenuItem(
                onTap: () => launchUrl(
                    Uri.parse(
                        'https://live-vitalist.notion.site/Privacy-Policy-Live-Vitalist-1d612e3b9fc280d1be5cd9a718709560'),
                    mode: LaunchMode.externalApplication),
                child: const Text('Privacy Policy'),
              ),
              PopupMenuItem(
                onTap: () => launchUrl(
                    Uri.parse(
                        'https://live-vitalist.notion.site/Terms-of-Use-Live-Vitalist-1d612e3b9fc28053a196f93d6c739858'),
                    mode: LaunchMode.externalApplication),
                child: const Text('Terms of Use'),
              ),
              PopupMenuItem(
                onTap: () => launchUrl(Uri(
                    scheme: 'mailto',
                    path: 'livevitalist@gmail.com',
                    query: Uri.encodeFull('subject=Feedback&body=Hello!'))),
                child: const Text('Send Feedback'),
              ),
              PopupMenuItem(
                onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const DataDeletionPage())),
                child: const Text('Data Deletion'),
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
                title: 'Connect with Google',
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                        'Backup your files to cloud or restore your data by connecting with Google.'),
                    const SizedBox(height: 12.0),
                    TextButton(
                        onPressed: _handleGoogleConnection,
                        child: const Text('Connect with Google')),
                  ],
                ),
              ),
            MiniCard(
              child: Row(
                children: [
                  const SizedBox(width: 16.0),
                  Checkbox(
                    value: SettingsData.isMonthDay,
                    onChanged: (val) {
                      if (val != null) {
                        setState(() => SettingsData.isMonthDay = val);
                      }
                    },
                  ),
                  const Text('Use M/D format'),
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
                      if (val != null) {
                        setState(() => SettingsData.isComplexCalendar = val);
                      }
                    },
                  ),
                  const Text('Use complex calendar view'),
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
                      if (val != null) {
                        setState(() => SettingsData.isShowOmegaBalance = val);
                      }
                    },
                  ),
                  const Text('Show Omega-3 to Omega-6 balance'),
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
