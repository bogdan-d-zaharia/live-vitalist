abstract interface class IStorageHandler {
  Future<bool> saveJson(String path, Map<String, dynamic> json);
  Future<Map<String, dynamic>?> loadJson(String path);
  // abstract int priority;
}

// abstract interface class IChainOfResponsibility<T> {
//   abstract T? nextHandler;
// }

// abstract interface class IStorageMethod
//     implements IStorageHandler, IChainOfResponsibility<IStorageHandler> {}
