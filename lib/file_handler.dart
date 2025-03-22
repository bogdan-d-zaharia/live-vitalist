import 'dart:convert';
import 'dart:io';
// import 'package:lecle_downloads_path_provider/lecle_downloads_path_provider.dart';
import 'package:intl/intl.dart' as intl;

abstract final class FileHandler {
  /// `intl.DateFormat('d_M_y').format(date)` is used internally,
  /// as such, hours, minutes, seconds etc. don't matter.
  static Future<File?> _getFile({
    DateTime? date,
    String? name,
    bool doCreate = true,
  }) async {
    if ((date == null) && (name == null)) throw Exception('No inputed name!');

    final fileName =
        '${date != null ? intl.DateFormat('d_M_y').format(date) : name}.json';

    final downloadsPath = '/storage/emulated/0/Download';

    /// final downloadsPath = (await DownloadsPath.downloadsDirectory())!.path;
    /// final downloadsPath = 'C:/users/bogda/desktop';
    final filePath = '$downloadsPath/MicroHealth_0_0_7/$fileName';

    final file = File(filePath);

    if (Directory(downloadsPath).existsSync() && !file.existsSync()) {
      if (!doCreate) return null;

      file.createSync(recursive: true);
      file.writeAsString('{}');
    }

    return file;
  }

  /// `intl.DateFormat('d_M_y').format(date)` is used internally,
  /// as such, hours, minutes, seconds etc. don't matter.
  static Future<void> saveJson(Map<String, dynamic> json,
      {DateTime? date, String? name}) async {
    final File file = (await _getFile(date: date, name: name))!;
    final String str = jsonEncode(json);

    /// {'':} -> 5 characters /// If too short, don't even create.
    if (str.length <= 5) return;
    await file.writeAsString(str);
  }

  /// Saves the **json** and **creates** a backup,
  ///
  /// or **updates** it if it is older than **1 day**.
  static Future<void> saveJsonAndBackup(Map<String, dynamic> json,
      {required String name}) async {
    final old = await FileHandler.loadJson(name: name);
    await FileHandler.saveJson(json, name: name);
    final delta = await FileHandler.deltaFile(name, '${name}_backup');
    if (delta == null || delta.inDays >= 1) {
      await FileHandler.saveJson(old, name: '${name}_backup');
    }
  }

  /// `intl.DateFormat('d_M_y').format(date)` is used internally,
  /// as such, hours, minutes, seconds etc. don't matter.
  static Future<Map<String, dynamic>> loadJson(
      {DateTime? date, String? name}) async {
    final File? file = await _getFile(date: date, name: name, doCreate: false);
    final String str = (await file?.readAsString()) ?? '{}';
    return jsonDecode(str);
  }

  static Future<Duration?> deltaFile(String filename1, String filename2) async {
    final File? file1 = await _getFile(name: filename1, doCreate: false);
    final File? file2 = await _getFile(name: filename2, doCreate: false);
    if (file1 == null || file2 == null) return null;

    return file2.lastModifiedSync().difference(file1.lastModifiedSync());
  }
}
