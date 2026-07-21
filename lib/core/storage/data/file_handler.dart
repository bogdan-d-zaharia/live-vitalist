import 'dart:convert';
import 'dart:io';

import 'package:live_vitalist/core/utils/json_handler.dart';
import 'package:live_vitalist/core/storage/domain/storage_interfaces.dart';
import 'package:path_provider/path_provider.dart';

final class FileHandler implements IStorageHandler, ILocalDeletion {
  // @override
  // late IStorageHandler? nextHandler;
  // FileHandler(this.nextHandler);

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

  @override
  Future<bool> saveJson(String path, Map<String, dynamic> json) async {
    final File file = (await _getFile(path, doCreate: true))!;
    if (json.isEmpty) {
      file.deleteSync();
      return true;
    }

    final String str = jsonEncode(json.flattenDotNotation()); // dot notation
    // final String str = jsonEncode(json);
    await file.writeAsString(str);
    return true;
  }

  @override
  Future<Map<String, dynamic>?> loadJson(String path) async {
    final File? file = await _getFile(path);
    String? str = (await file?.readAsString());

    try {
      if (str != null && str.length > 2) {
        //TODO: Investigate and fix real cause.
        /* This happends rarely but is annoying enough.
         The first " is replaced with a }.
         I made a lazy fix.

         FormatException (FormatException: Unexpected character (at character 3)
         {}aliments":{"652656957":{"name":"q","referenceSize":1.0,"referenceFields":...
           ^ */
        if (str[1] == "}") {
          str = str.replaceRange(1, 2, '"');
        }
        return jsonDecode(str);
      }
    } finally {}
    return null;
  }

  @override
  Future<bool> deleteLocal() async {
    final dir = Directory(await FileHandler.localPath);
    await dir.delete(recursive: true);
    return true;
  }
}
