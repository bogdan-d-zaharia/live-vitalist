import 'dart:convert';
import 'dart:io';
// import 'package:lecle_downloads_path_provider/lecle_downloads_path_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

import 'json_handler.dart';

///     LOAD                    : local || DOWNLOAD
///     SAVE                    : local && SYNC
///
///     DOWNLOAD  [INTERNET]    : local = cloud
///     - used to download old information
///       or after reinstalling.
///
///     SYNC      [INTERNET]    : cloud = local
///     - used to upload to cloud after no internet
///       or after creating an account.
///
///               [     IMPORTED      ]
///           [           LOCAL           ]
///     [                 CLOUD                 ]
abstract final class StorageHandler {
  static bool isFirebase = false;

  static Future<void> saveJson(String path, Map<String, dynamic> json,
      {bool doBackup = false}) async {
    if (!doBackup) {
      await FileHandler.saveJson(path, json);
    } else {
      await FileHandler.saveJsonAndBackup(path, json);
    }

    /* SYNC */
    if (isFirebase) {
      FirebaseHandler.saveJson(path, json);
    }
  }

  /// Check `StorageHandler` doc.
  static Future<Map<String, dynamic>?> loadJson(String path) async {
    final Map<String, dynamic>? fileJson = await FileHandler.loadJson(path);
    //TODO: I don't think `convertIntsToDoubles` is needed because
    // it only saves doubles locally.
    // It could if downloaded directly from internet.
    // Perhaps `convertIntsToDoubles` after internet.loadJson.
    if (fileJson != null) return JsonHandler.convertIntsToDoubles(fileJson);

    /* DOWNLOAD */
    final Map<String, dynamic>? firebaseJson =
        JsonHandler.convertIntsToDoubles(await FirebaseHandler.loadJson(path));
    if (firebaseJson != null) {
      bool isADayDataThatIsOlderThanAWeek = false;

      final List<String> x = path.split('_');
      if (x.length >= 3) {
        final int? day = int.tryParse(x[0]);
        final int? month = int.tryParse(x[1]);
        final int? year = int.tryParse(x[2]);

        if (day != null && month != null && year != null) {
          isADayDataThatIsOlderThanAWeek =
              DateTime.now().difference(DateTime(year, month, day)) >
                  Duration(days: 7);
        }
      }

      if (!isADayDataThatIsOlderThanAWeek) {
        FileHandler.saveJson(path, firebaseJson);
      }

      return firebaseJson;
    }

    return null;
  }

  static Future<void> syncAll() async {
    final dir = Directory(await FileHandler.localPath);
    for (File file in dir.listSync().whereType<File>()) {
      final fileName = p.basenameWithoutExtension(file.path);
      if (!file.existsSync() || fileName.contains('_backup')) continue;

      Map<String, dynamic>? json;
      try {
        json = JsonHandler.forceStringKeys(jsonDecode(file.readAsStringSync()));
        // ignore: empty_catches
      } catch (e) {}

      if (json != null) {
        await FirebaseHandler.saveJson(fileName, json);
      }
    }
  }
}

abstract final class FileHandler {
  static Future<String> get localPath async =>
      (await getApplicationSupportDirectory()).path;

  static Future<File?> _getFile(String path, {bool doCreate = false}) async {
    final localPath = await FileHandler.localPath;
    final filePath = '$localPath/$path.json';
    final file = File(filePath);

    if (Directory(localPath).existsSync() && !file.existsSync()) {
      if (!doCreate) return null;

      file.createSync(recursive: true);
      file.writeAsString('{}');
    }

    return file;
  }

  static Future<void> saveJson(String path, Map<String, dynamic> json) async {
    final File file = (await _getFile(path, doCreate: true))!;
    if (json.isEmpty) {
      return file.deleteSync();
    }

    final String str = jsonEncode(json);
    await file.writeAsString(str);
  }

  /// Saves the **json** and **creates** a backup,
  ///
  /// or **updates** it if it is older than **1 day**.
  static Future<void> saveJsonAndBackup(
      String path, Map<String, dynamic> json) async {
    final old = await FileHandler.loadJson(path);
    await FileHandler.saveJson(path, json);
    final delta = await FileHandler.deltaFile(path, '${path}_backup');
    if (delta == null || delta.inDays >= 1) {
      await FileHandler.saveJson('${path}_backup', old ?? {});
    }
  }

  static Future<Map<String, dynamic>?> loadJson(String path) async {
    final File? file = await _getFile(path);
    String? str = (await file?.readAsString());

    if (str != null && str.length > 2) {
      //TODO: Investigate and fix real cause.
      /* This happends rarely but is annoying enough.
         The first " is replaced with a }.
         I made a lazy fix.

         FormatException (FormatException: Unexpected character (at character 3)
         {}aliments":{"652656957":{"name":"q","referenceSize":1.0,"referenceFields":...
           ^ */
      if (str[1] == "}") str = str.replaceRange(1, 2, '"');
      return jsonDecode(str);
    }
    return null;
  }

  static Future<Duration?> deltaFile(String filename1, String filename2) async {
    final File? file1 = await _getFile(filename1);
    final File? file2 = await _getFile(filename2);
    if (file1 == null || file2 == null) return null;

    return file2.lastModifiedSync().difference(file1.lastModifiedSync());
  }

  static Future<void> deleteLocal() async {
    final dir = Directory(await FileHandler.localPath);
    for (File file in dir.listSync().whereType<File>()) {
      await file.delete();
    }
  }
}

abstract final class FirebaseHandler {
  static Future<bool> saveJson(String path, Map<String, dynamic> json) async {
    final fileName = p.basenameWithoutExtension(path);
    if (fileName.contains('_backup') || fileName == 'settings') return false;

    final user = FirebaseAuth.instance.currentUser;
    final uid = user?.uid;
    final db = FirebaseDatabase.instance.ref();

    /* Just waits until it has internet connection and sends. 
       If there is no internet connection, it waits, no exceptions given. */
    await db
        .child('users/$uid/$path')
        .set(json); /* used `mapToListRecursive` to maintain order */

    return true;
  }

  static Future<Map<String, dynamic>?> loadJson(String path) async {
    if (!StorageHandler.isFirebase) return null;

    final user = FirebaseAuth.instance.currentUser;
    final uid = user?.uid;
    final db = FirebaseDatabase.instance.ref();

    final snapshot = await db.child('users/$uid/$path').get();

    if (snapshot.exists && snapshot.value != null) {
      return (snapshot.value as Map)
          .map<String, dynamic>((key, value) => MapEntry(key as String, value));
    }

    return null;
  }
}
