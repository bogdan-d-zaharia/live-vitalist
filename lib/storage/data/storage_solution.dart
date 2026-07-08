import 'package:live_vitalist/storage/domain/storage_handler.dart';

final class StorageSolution implements IStorageHandler {
  static bool isFirebase = false;

  final ResponseChain<Future<Map<String, dynamic>?>> loadChain;
  final ResponseChain<Future<bool>> saveChain;
  final ResponseChain<Future<bool>> deletionChain;

  StorageSolution({
    required this.loadChain,
    required this.saveChain,
    required this.deletionChain,
  });

  @override
  Future<bool> saveJson(String path, Map<String, dynamic> json) async {
    return saveChain.chainResponse();
  }

  /// Check `StorageHandler` doc.
  @override
  Future<Map<String, dynamic>?> loadJson(String path) async {
    return loadChain.chainResponse();
  }

  @override
  Future<bool> delete() async {
    return deletionChain.chainResponse();
  }

  // Future<Map<String, dynamic>> loadSources() async {
  //   return {
  //     'local': await localMethod.loadJson('alimentBank') ?? {},
  //     'cloud': await cloudMethod.loadJson('alimentBank') ?? {},
  //   };
  // }

  // Future<void> syncAll() async {
  //   final dir = Directory(await localMethod.localPath);
  //   for (File file in dir.listSync().whereType<File>()) {
  //     final fileName = p.basenameWithoutExtension(file.path);
  //     if (!file.existsSync() || fileName.contains('_backup')) continue;

  //     Map<String, dynamic>? json;
  //     try {
  //       json = JsonHandler.forceStringKeys(jsonDecode(file.readAsStringSync()));
  //       // ignore: empty_catches
  //     } catch (e) {}

  //     if (json != null) {
  //       await cloudMethod.saveJson(fileName, json);
  //     }
  //   }
  // }
}
