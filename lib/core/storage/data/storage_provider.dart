import 'package:firebase_auth/firebase_auth.dart';
import 'package:live_vitalist/core/auth/data/apple_credential_source.dart';
import 'package:live_vitalist/core/auth/domain/credential_source.dart';
import 'package:live_vitalist/core/auth/data/google_credential_source.dart';
import 'package:live_vitalist/core/storage/data/file_handler.dart';
import 'package:live_vitalist/core/storage/data/firebase_handler.dart';
import 'package:live_vitalist/core/storage/domain/storage_interfaces.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'storage_provider.g.dart';

@riverpod
class Storage extends _$Storage
    implements IStorageHandler, ILocalHandler, ICloudHandler {
  // We don't have to verify if the user is connected,
  // because `FirebaseHandler` verifies that automatically when used.

  late FileHandler _fileHlr;
  late FirebaseHandler _firebaseHlr;

  @override
  void build() {
    _fileHlr = FileHandler();
    _firebaseHlr = FirebaseHandler(_credentialsForUser);
  }

  CredentialSource _credentialsForUser(User user) {
    final ids = user.providerData.map((provider) => provider.providerId);
    return switch (ids) {
      final ids when ids.contains('apple.com') =>
        ref.read(appleCredentialSourceProvider),
      final ids when ids.contains('google.com') =>
        ref.read(googleCredentialSourceProvider),
      _ => throw UnsupportedError(
          'No supported credential source for this account'),
    };
  }

  @override
  Future<bool> saveLocal(String path, Map<String, dynamic> json) =>
      _fileHlr.saveLocal(path, json);

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

  @override
  Future<dynamic> loadCloud(String path) {
    return _firebaseHlr.loadCloud(path);
  }

  @override
  Future<dynamic> loadLocal(String path) {
    return _fileHlr.loadLocal(path);
  }
}
