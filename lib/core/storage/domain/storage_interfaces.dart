abstract interface class IStorageHandler {
  Future<bool> saveJson(String path, Map<String, dynamic> json);
  Future<Map<String, dynamic>?> loadJson(String path);
}

abstract interface class ILocalDeletion {
  Future<bool> deleteLocal();
}

abstract interface class ICloudDeletion {
  Future<bool> deleteAccount();
}
