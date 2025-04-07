import 'dart:convert';
import 'dart:io';
// import 'package:lecle_downloads_path_provider/lecle_downloads_path_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:path_provider/path_provider.dart';

abstract final class StorageHandler {
  static bool isFirebase = false;
  static bool isExternal = true;

  static Future<void> saveJson(String path, Map<String, dynamic> json,
      {bool doBackup = false}) async {
    final Map<String, dynamic>? old =
        doBackup ? await StorageHandler.loadJson(path) : null;

    if (!isFirebase || !(await FirebaseHandler.saveJson(path, json))) {
      await FileHandler.saveJson(path, json);
    }

    /* Save a backup locally. */
    if (doBackup) FileHandler.saveJson('${path}_backup', old!);
  }

  static Future<Map<String, dynamic>> loadJson(String path) async {
    Map<String, dynamic>? json;

    if (isFirebase) {
      json = await FirebaseHandler.loadJson(path);
      if (json != null) {
        return json;
      }
    }

    /* (!isFirebase || json == null) */
    json = await FileHandler.loadJson(path);

    return json;
  }
}

abstract final class FileHandler {
  static Future<File?> _getFile(
    String path, {
    bool doCreate = true,
  }) async {
    final downloadsPath = StorageHandler.isExternal
        ? '/storage/emulated/0/Download'
        : (await getApplicationSupportDirectory()).path;

    /// final downloadsPath = (await DownloadsPath.downloadsDirectory())!.path;
    /// final downloadsPath = 'C:/users/bogda/desktop';
    final filePath = '$downloadsPath/MicroHealth_0_0_7/$path';

    final file = File(filePath);

    if (Directory(downloadsPath).existsSync() && !file.existsSync()) {
      if (!doCreate) return null;

      file.createSync(recursive: true);
      file.writeAsString('{}');
    }

    return file;
  }

  static Future<void> saveJson(String path, Map<String, dynamic> json) async {
    final File file = (await _getFile(path))!;
    final String str = jsonEncode(json);

    /// {'':} -> 5 characters /// If too short, don't even create.
    if (str.length <= 5) return;
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
      await FileHandler.saveJson('${path}_backup', old);
    }
  }

  static Future<Map<String, dynamic>> loadJson(String path) async {
    final File? file = await _getFile(path, doCreate: false);
    final String str = (await file?.readAsString()) ?? '{}';
    return jsonDecode(str);
  }

  static Future<Duration?> deltaFile(String filename1, String filename2) async {
    final File? file1 = await _getFile(filename1, doCreate: false);
    final File? file2 = await _getFile(filename2, doCreate: false);
    if (file1 == null || file2 == null) return null;

    return file2.lastModifiedSync().difference(file1.lastModifiedSync());
  }
}

abstract final class FirebaseHandler {
  static Future<bool> saveJson(String path, Map<String, dynamic> json) async {
    final user = FirebaseAuth.instance.currentUser;
    final uid = user?.uid;
    final db = FirebaseDatabase.instance.ref();

    await db.child('users/$uid/$path').set(json);

    return true;
  }

  static Future<Map<String, dynamic>?> loadJson(String path) async {
    final user = FirebaseAuth.instance.currentUser;
    final uid = user?.uid;
    final db = FirebaseDatabase.instance.ref();

    final snapshot = await db.child('users/$uid/$path').get();

    if (snapshot.exists) {
      return snapshot.value as Map<String, dynamic>;
    }

    return null;
  }
}
