import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:live_vitalist/core/utils/json_handler.dart';
import 'package:live_vitalist/core/storage/domain/storage_interfaces.dart';
import 'package:path_provider/path_provider.dart';

final class FileHandler implements IStorageHandler, ILocalHandler {
  // @override
  // late IStorageHandler? nextHandler;
  // FileHandler(this.nextHandler);

  final Map<String, Future<void>> _pendingWrites = {};

  static Future<String> get localPath async =>
      (await getApplicationSupportDirectory()).path;

  static Future<File?> _getFile(String path, {bool doCreate = false}) async {
    final localPath = await FileHandler.localPath;
    final filePath = '$localPath/$path.json';
    final file = File(filePath);

    if (!await file.exists()) {
      if (!doCreate) return null;

      await file.create(recursive: true);
    }

    return file;
  }

  @override
  Future<bool> saveLocal(String path, Map<String, dynamic> json) async {
    final str = jsonEncode(json.flattenDotNotation());
    final previousWrite = _pendingWrites[path] ?? Future.value();
    final writeCompleted = Completer<void>();
    _pendingWrites[path] = writeCompleted.future;

    await previousWrite;
    try {
      final file = await _getFile(path, doCreate: json.isNotEmpty);
      if (json.isEmpty) {
        if (file != null) await file.delete();
        return true;
      }

      final temporaryFile = File('${file!.path}.tmp');
      try {
        await temporaryFile.writeAsString(str, flush: true);
        await temporaryFile.rename(file.path);
      } catch (_) {
        if (await temporaryFile.exists()) await temporaryFile.delete();
        rethrow;
      }
      return true;
    } finally {
      writeCompleted.complete();
      if (identical(_pendingWrites[path], writeCompleted.future)) {
        _pendingWrites.remove(path);
      }
    }
  }

  @override
  Future<bool> saveJson(String path, Map<String, dynamic> json) =>
      saveLocal(path, json);

  @override
  Future<dynamic> loadLocal(String path) async {
    final File? file = await _getFile(path);
    final String? str = await file?.readAsString();

    if (str == null || str.length <= 2) return null;

    try {
      return jsonDecode(str);
    } catch (error, stackTrace) {
      FlutterError.reportError(
        FlutterErrorDetails(exception: error, stack: stackTrace),
      );
    }
    return null;
  }

  @override
  Future<Map<String, dynamic>?> loadJson(String path) async =>
      await loadLocal(path);

  @override
  Future<bool> deleteLocal() async {
    final dir = Directory(await FileHandler.localPath);
    await dir.delete(recursive: true);
    return true;
  }
}
