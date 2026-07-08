abstract interface class IStorageHandler {
  Future<bool> saveJson(String path, Map<String, dynamic> json);
  Future<Map<String, dynamic>?> loadJson(String path);
  Future<bool> delete();
}

class ResponseChain<T> {
  final T Function() respond;
  final ResponseChain<T>? subordinate;
  final T Function(T superior, T inferior)? resolve;

  ResponseChain({
    required this.respond,
    this.subordinate,
    this.resolve,
  });

  T chainResponse() {
    final superior = respond();
    final inferior = subordinate?.respond();
    if (inferior == null || resolve == null) return superior;
    return resolve!(superior, inferior);
  }
}
