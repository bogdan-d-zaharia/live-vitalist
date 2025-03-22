import 'package:flutter/material.dart';
import 'file_handler.dart';

abstract final class SettingsData {
  static bool isMonthDay = false;

  static Map<String, dynamic>? toJson() {
    return {
      'isMonthDay': isMonthDay,
    };
  }

  static void fromJson(Map<String, dynamic> json) {
    if (json.containsKey('isMonthDay')) isMonthDay = json['isMonthDay'];
  }

  /// [ IO_FUNCTION ]
  ///
  /// `intl.DateFormat('d_M_y').format(date)` is used internally,
  /// as such, hours, minutes, seconds etc. don't matter.
  static Future<void> save() async {
    return FileHandler.saveJson(toJson()!, name: 'settings');
  }

  /// [ IO_FUNCTION ]
  ///
  /// `intl.DateFormat('d_M_y').format(date)` is used internally,
  /// as such, hours, minutes, seconds etc. don't matter.
  static Future<void> load(DateTime date) async {
    await FileHandler.loadJson(date: date).then((json) {
      fromJson(json);
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
      body: Center(
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
          ],
        ),
      ),
    );
  }
}
