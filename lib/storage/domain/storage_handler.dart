abstract interface class IStorageHandler {
  Future<bool> saveJson(String path, Map<String, dynamic> json);
  Future<Map<String, dynamic>?> loadJson(String path);
  Future<bool> delete();
}
