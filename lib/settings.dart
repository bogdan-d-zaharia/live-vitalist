import 'package:flutter/material.dart';

import 'aliment.dart';
import 'auth_gate.dart';
import 'cache_handler.dart';
import 'custom_card.dart';
import 'file_handler.dart';
import 'models/reference_fields_model.dart';

abstract final class SettingsData {
  static bool isMonthDay = false;
  static bool isLoggedIn = false;
  static String language = 'ENG';

  // static Set<String> languages = {'ENG'};

  static Map<String, dynamic> toJson() {
    return {
      'isMonthDay': isMonthDay,
      'isLoggedIn': isLoggedIn,
      'language': language,
    };
  }

  static void fromJson(Map<String, dynamic> json) {
    if (json.containsKey('isMonthDay')) isMonthDay = json['isMonthDay'];
    if (json.containsKey('isLoggedIn')) isLoggedIn = json['isLoggedIn'];
    if (json.containsKey('language')) language = json['language'];
  }

  /// [ IO_FUNCTION ]
  static Future<void> save() async {
    return FileHandler.saveJson('settings', toJson());
  }

  /// [ IO_FUNCTION ]
  static Future<void> load() async {
    await FileHandler.loadJson('settings').then((json) {
      fromJson(json ?? {});
    });
  }
}

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
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
                    ElevatedButton(
                      onPressed: () async {
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
                child: ElevatedButton(
                  onPressed: () => StorageHandler.syncAll(),
                  child: Text('Backup all data to cloud'),
                ),
              ),
            Card(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
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
                  Text('Use Month / Day'),
                  Spacer(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
