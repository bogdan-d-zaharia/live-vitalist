import 'package:live_vitalist/core/storage/data/file_handler.dart';
import 'package:live_vitalist/core/storage/data/firebase_handler.dart';
import 'package:live_vitalist/core/storage/domain/storage_handler.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'storage_provider.g.dart';

@riverpod
class Storage extends _$Storage implements IStorageHandler {
  // We don't have to verify if the user is connected,
  // because `FirebaseHandler` verifies that automatically when used.

  late FileHandler _fileHlr;
  late FirebaseHandler _firebaseHlr;

  @override
  void build() {
    _fileHlr = FileHandler();
    _firebaseHlr = FirebaseHandler();
  }

  @override
  Future<bool> saveJson(String path, Map<String, dynamic> json) async {
    final local = await _fileHlr.saveJson(path, json);
    final cloud = await _firebaseHlr.saveJson(path, json);
    return local && cloud;
  }

  @override
  Future<Map<String, dynamic>?> loadJson(String path) async {
    final localData = await _fileHlr.loadJson(path);
    if (localData != null) return localData;
    return _firebaseHlr.loadJson(path);
  }

  @override
  Future<bool> delete() async {
    final local = await _fileHlr.delete();
    final cloud = await _firebaseHlr.delete();
    return local && cloud;
  }
}
