abstract interface class INetwork {
  Future<void> post(String path, dynamic data);
  Future<dynamic> get(String path);
}
