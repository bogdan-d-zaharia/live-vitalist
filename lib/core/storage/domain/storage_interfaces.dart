abstract interface class IStorageHandler {
  Future<bool> saveJson(String path, Map<String, dynamic> json);
  Future<Map<String, dynamic>?> loadJson(String path);
}

abstract interface class ILocalHandler {
  Future<bool> saveLocal(String path, Map<String, dynamic> json);
  Future<dynamic> loadLocal(String path);
  Future<bool> deleteLocal();
}

abstract interface class ICloudHandler {
  Future<dynamic> loadCloud(String path);
  Future<bool> deleteAccount();
}
