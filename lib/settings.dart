import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'aliment.dart';
import 'auth_gate.dart';
import 'cache_handler.dart';
import 'custom_card.dart';
import 'file_handler.dart';
import 'models/reference_fields_model.dart';
import 'palette.dart';

abstract final class SettingsData {
  static late SharedPreferencesWithCache _prefs;

  static Future<void> init() async {
    _prefs = await SharedPreferencesWithCache.create(
        cacheOptions: SharedPreferencesWithCacheOptions());
  }

  /* The set and get work sync
     because there is a table manipulated under the hood. */
  static bool get isMonthDay => _prefs.getBool('isMonthDay') ?? false;
  static set isMonthDay(bool val) => _prefs.setBool('isMonthDay', val);

  static bool get isLoggedIn => _prefs.getBool('isLoggedIn') ?? false;
  static set isLoggedIn(bool val) => _prefs.setBool('isLoggedIn', val);

  static String get language => _prefs.getString('language') ?? 'ENG';
  static set language(String val) => _prefs.setString('language', val);

  static bool get isComplexCalendar =>
      _prefs.getBool('isComplexCalendar') ?? false;
  static set isComplexCalendar(bool val) =>
      _prefs.setBool('isComplexCalendar', val);

  static int get sort => _prefs.getInt('sort') ?? 0;
  static set sort(int val) => _prefs.setInt('sort', val);
}

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
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

    DayHandler.cache.clear();
    AlimentBank.aliments.clear();
    AlimentBank.mruIDs.clear();
    NutrientsHandler.reset();
    SettingsData.isLoggedIn = false;

    if (mounted) {
      await Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => AuthGate(),
        ),
        (route) => false,
      );
    }
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
                        //TODO: Day data doesn't automatically sync when connecting with Google.
                        await AuthGate.signInWithGoogle();
                        if (StorageHandler.isFirebase) {
                          //TODO: Perhaps show a pop up and ask upon conflict.
                          await AlimentBank.loadMerged();
                          await NutrientsHandler.load(); //TODO: Merge
                          DayHandler.cache.clear();
                          setState(() {});
                        }
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
