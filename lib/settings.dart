import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:url_launcher/url_launcher.dart';

import 'aliment/aliment_bank_provider.dart';
import 'custom_card.dart';
import 'day/day_provider.dart';
import 'file_handler.dart';
import 'palette.dart';
import 'settings_data.dart';

class Settings extends ConsumerStatefulWidget {
  const Settings({super.key});

  @override
  ConsumerState<Settings> createState() => _SettingsState();
}

class _SettingsState extends ConsumerState<Settings> {
  // #region //* ACCOUNT DELETION *//
  final String deleteAll1 =
      'You can delete your account and all data stored both online and on your device by using the button below. This will permanently remove everything linked to your account and reset the app.';

  final String deleteAll2 =
      'Are you sure you want to delete your account and all associated data? This will erase your online data and local storage. This action is permanent and cannot be undone.';

  final String deleteInternet1 =
      'You can delete your account and all data stored online by using the button below. Your data will be permanently removed from our servers, but app settings and local storage will remain on your device.';

  final String deleteInternet2 =
      'Are you sure you want to delete your account and all data stored online? This action is permanent and cannot be undone.';

  Future<bool> deleteInternet() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return false;

    final bool b = await showDialog(
          context: context,
          builder: (context) {
            return Dialog(
              backgroundColor: Colors.transparent,
              child: CustomCard(
                headerSpace: 0.0,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'You must authenticate first before we can delete your account associated with Google.',
                      style: TextStyle(fontSize: 16.0),
                    ),
                    SizedBox(height: 12.0),
                    ElevatedButton.icon(
                      onPressed: () async {
                        final googleUser = await GoogleSignIn().signIn();
                        final googleAuth = await googleUser?.authentication;

                        final credential = GoogleAuthProvider.credential(
                          accessToken: googleAuth?.accessToken,
                          idToken: googleAuth?.idToken,
                        );

                        await user.reauthenticateWithCredential(credential);

                        await FirebaseDatabase.instance
                            .ref('users/${user.uid}')
                            .remove();

                        await user.delete();

                        if (context.mounted) {
                          Navigator.pop(context, true);
                        }
                      },
                      icon: Icon(Icons.delete, color: Colors.white),
                      label: Text("Re-authenticate and delete"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                        padding:
                            EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ) ??
        false;

    if (b) {
      StorageHandler.isFirebase = false;
    }

    return b;
  }

  void deleteInternetPopup() {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: CustomCard(
            headerSpace: 0.0,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  deleteInternet2,
                  style: TextStyle(fontSize: 16.0),
                ),
                SizedBox(height: 12.0),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      width: 100.0,
                      child: ElevatedButton.icon(
                        onPressed: () => Navigator.pop(context),
                        label: Text("Cancel"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(
                              horizontal: 16, vertical: 12),
                        ),
                      ),
                    ),
                    SizedBox(width: 12.0),
                    SizedBox(
                      width: 100.0,
                      child: ElevatedButton.icon(
                        onPressed: () async {
                          if (await deleteInternet()) {
                            setState(() {});
                            if (context.mounted) {
                              Navigator.pop(context);
                            }
                          }
                        },
                        icon: Icon(Icons.delete, color: Colors.white),
                        label: Text("Delete"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(
                              horizontal: 16, vertical: 12),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> deleteEverything() async {
    if (StorageHandler.isFirebase && !await deleteInternet()) return;
    await FileHandler.deleteLocal();
    await SettingsData.deleteAll();

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Closing the app...'),
          duration: Duration(seconds: 2),
        ),
      );
    }

    await Future.delayed(Duration(seconds: 3));
    SystemNavigator.pop();
  }

  void deleteEverythingPopup() {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: CustomCard(
            headerSpace: 0.0,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  deleteAll2,
                  style: TextStyle(fontSize: 16.0),
                ),
                SizedBox(height: 12.0),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      width: 100.0,
                      child: ElevatedButton.icon(
                        onPressed: () => Navigator.pop(context),
                        label: Text("Cancel"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(
                              horizontal: 16, vertical: 12),
                        ),
                      ),
                    ),
                    SizedBox(width: 12.0),
                    SizedBox(
                      width: 100.0,
                      child: ElevatedButton.icon(
                        onPressed: deleteEverything,
                        icon: Icon(Icons.delete, color: Colors.white),
                        label: Text("Delete"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(
                              horizontal: 16, vertical: 12),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // #endregion

  @override
  Widget build(BuildContext context) {
    final bankNotifier = ref.read(alimentBankProvider.notifier);
    final dayCacheNotifier = ref.read(dayCacheProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
        actions: [
          PopupMenuButton(
            // icon: Row(
            //   children: [
            //     Text('Documents'),
            //     SizedBox(
            //       width: 32.0,
            //       height: 32.0,
            //       child: Icon(Icons.more_vert_rounded),
            //     ),
            //   ],
            // ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24.0),
            ),
            clipBehavior: Clip.hardEdge,
            color: Palette.isDarkMode(context) ? Colors.grey[800] : null,
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              PopupMenuItem<String>(
                onTap: () async {
                  final url = Uri.parse(
                      'https://live-vitalist.notion.site/Privacy-Policy-Live-Vitalist-1d612e3b9fc280d1be5cd9a718709560');
                  await launchUrl(url, mode: LaunchMode.externalApplication);
                },
                child: Text('Privacy Policy'),
              ),
              PopupMenuItem<String>(
                onTap: () async {
                  final url = Uri.parse(
                      'https://live-vitalist.notion.site/Terms-of-Use-Live-Vitalist-1d612e3b9fc28053a196f93d6c739858');
                  await launchUrl(url, mode: LaunchMode.externalApplication);
                },
                child: Text('Terms of Use'),
              ),
              PopupMenuItem<String>(
                onTap: () async {
                  final Uri emailLaunchUri = Uri(
                    scheme: 'mailto',
                    path: 'livevitalist@gmail.com',
                    query: Uri.encodeFull('subject=Feedback&body=Hello!'),
                  );
                  await launchUrl(emailLaunchUri);
                },
                child: Text('Send Feedback'),
              ),
              PopupMenuItem<String>(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Scaffold(
                        appBar: AppBar(
                          title: Text('Account Deletion'),
                        ),
                        body: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: ListView(
                            children: [
                              if (StorageHandler.isFirebase)
                                CustomCard(
                                  logo: Icon(Icons.no_accounts_rounded),
                                  title: 'Account and data deletion',
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(deleteInternet1),
                                      TextButton(
                                        onPressed: deleteInternetPopup,
                                        child: Text(
                                            'Permanently delete online data'),
                                      ),
                                    ],
                                  ),
                                ),
                              CustomCard(
                                logo: Icon(Icons.no_accounts_rounded),
                                title: 'Account and data deletion',
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(deleteAll1),
                                    TextButton(
                                      onPressed: deleteEverythingPopup,
                                      child:
                                          Text('Permanently delete all data'),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
                child: Text('Data Deletion'),
              ),
            ],
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: ListView(
          children: [
            if (!StorageHandler.isFirebase)
              CustomCard(
                logo: Icon(Icons.cloud_upload_rounded),
                title: 'Connect with Google',
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                        'Backup your files to cloud or restore your data by connecting with Google.'),
                    SizedBox(height: 12.0),
                    TextButton(
                      onPressed: () async {
                        /* From AuthGate */
                        final googleUser = await GoogleSignIn().signIn();
                        if (googleUser == null) return; /* user canceled */

                        final googleAuth = await googleUser.authentication;

                        final credential = GoogleAuthProvider.credential(
                          accessToken: googleAuth.accessToken,
                          idToken: googleAuth.idToken,
                        );

                        await FirebaseAuth.instance
                            .signInWithCredential(credential);

                        StorageHandler.isFirebase = true;

                        //TODO: Perhaps show a pop up and ask upon conflict.

                        await bankNotifier.loadMerged();
                        // await NutrientsHandler.load(); //TODO: Verify
                        dayCacheNotifier.clear();
                        setState(() {});
                      },
                      child: Text('Connect with Google'),
                    ),
                  ],
                ),
              ),
            //TODO: Implement
            //// CustomCard(
            ////   logo: Icon(Icons.file_upload_outlined),
            ////   title: 'Export files',
            ////   child: Column(
            ////     crossAxisAlignment: CrossAxisAlignment.start,
            ////     children: [
            ////       Text('Export your files to process with external tools.'),
            ////       SizedBox(height: 12.0),
            ////       ElevatedButton(
            ////         onPressed: () async {},
            ////         child: Text('Export'),
            ////       ),
            ////     ],
            ////   ),
            //// ),
            if (StorageHandler.isFirebase)
              CustomCard(
                logo: Icon(Icons.sync_rounded),
                title: 'Backup to cloud',
                child: TextButton(
                  onPressed: () => StorageHandler.syncAll(),
                  child: Text('Backup all data to cloud'),
                ),
              ),

            MiniCard(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(width: 16.0),
                  Checkbox(
                    value: SettingsData.isMonthDay,
                    onChanged: (value) {
                      if (value != null) {
                        setState(() {
                          SettingsData.isMonthDay = value;
                        });
                      }
                    },
                  ),
                  Text('Use M/D format'),
                  Spacer(),
                ],
              ),
            ),

            MiniCard(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(width: 16.0),
                  Checkbox(
                    value: SettingsData.isComplexCalendar,
                    onChanged: (value) {
                      if (value != null) {
                        setState(() {
                          SettingsData.isComplexCalendar = value;
                        });
                      }
                    },
                  ),
                  Text('Use complex calendar view'),
                  Spacer(),
                ],
              ),
            ),

            MiniCard(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(width: 16.0),
                  Checkbox(
                    value: SettingsData.isShowOmegaBalance,
                    onChanged: (value) {
                      if (value != null) {
                        setState(() {
                          SettingsData.isShowOmegaBalance = value;
                        });
                      }
                    },
                  ),
                  Text('Show Omega-3 to Omega-6 balance'),
                  Spacer(),
                ],
              ),
            ),

            //TODO: Implement
            // CustomCard(
            //   logo: const Icon(Icons.bar_chart_rounded),
            //   title: 'Calendar bar type',
            //   child: Row(
            //     children: [
            //       Expanded(
            //         child: AspectRatio(
            //           aspectRatio: 1.0,
            //           child: Card(
            //             child: Stack(
            //               alignment: Alignment.bottomCenter,
            //               children: [
            //                 Container(
            //                   width: 12.0,
            //                   decoration: BoxDecoration(
            //                     borderRadius: BorderRadius.circular(6.0),
            //                   ),
            //                   clipBehavior: Clip.hardEdge,
            //                   child: Stack(
            //                     alignment: Alignment.bottomCenter,
            //                     children: [
            //                       FractionallySizedBox(
            //                         heightFactor: (1.3 / 1.5).clamp(0.0, 1.0),
            //                         child: Container(
            //                           color: Colors.lightGreen
            //                               .withValues(alpha: 0.4),
            //                         ),
            //                       ),
            //                       FractionallySizedBox(
            //                         heightFactor: (1.1 / 1.5).clamp(0.0, 1.0),
            //                         child: Container(
            //                           color: Colors.lightGreen
            //                               .withValues(alpha: 0.4),
            //                         ),
            //                       ),
            //                       FractionallySizedBox(
            //                         heightFactor: (0.4 / 1.5).clamp(0.0, 1.0),
            //                         child: Container(
            //                           color: Colors.lightGreen,
            //                         ),
            //                       ),
            //                     ],
            //                   ),
            //                 ),
            //                 Positioned(
            //                   /// Dot position
            //                   bottom: 50.0,
            //                   child: Container(
            //                     height: 4,
            //                     width: 4,
            //                     decoration: BoxDecoration(
            //                       color: Colors.green,
            //                       borderRadius: BorderRadius.circular(4 / 2.0),
            //                     ),
            //                   ),
            //                 ),
            //               ],
            //             ),
            //           ),
            //         ),
            //       ),
            //       SizedBox(width: 8.0),
            //       Expanded(
            //         child: AspectRatio(
            //           aspectRatio: 1.0,
            //           child: Placeholder(),
            //         ),
            //       ),
            //       SizedBox(width: 8.0),
            //       Expanded(
            //         flex: 2,
            //         child: Padding(
            //           padding: const EdgeInsets.all(8.0),
            //           child: Text('data'),
            //         ),
            //       ),
            //     ],
            //   ),
            // ),

            SizedBox(height: 12.0),
          ],
        ),
      ),
    );
  }
}
