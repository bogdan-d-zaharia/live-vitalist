import 'package:live_vitalist/core/storage/data/file_handler.dart';
import 'package:live_vitalist/core/storage/data/firebase_handler.dart';
import 'package:live_vitalist/core/storage/domain/storage_interfaces.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'storage_provider.g.dart';

@riverpod
class Storage extends _$Storage
    implements IStorageHandler, ILocalDeletion, ICloudDeletion {
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

  // TODO: Make .loadJson generic (and cast at return, implicitly or not)
  // and use .load('alimentBank/order')
  @override
  Future<Map<String, dynamic>?> loadJson(String path) async {
    final localData = await _fileHlr.loadJson(path);
    if (localData != null) return localData;
    return _firebaseHlr.loadJson(path);
  }

  @override
  Future<bool> deleteLocal() async => await _fileHlr.deleteLocal();
  @override
  Future<bool> deleteAccount() async => await _firebaseHlr.deleteAccount();

  // We try to remove the cloud data first,
  // if it is not successful, and the data wasn't erased,
  // we won't remove the local data, to keep its integrity
  // before the user might try again.
  Future<bool> deleteEverything() async {
    if (!await deleteAccount()) return false;
    return deleteLocal();
  }
}
