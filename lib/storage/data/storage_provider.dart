import 'package:live_vitalist/json_handler.dart';
import 'package:live_vitalist/storage/data/file_handler.dart';
import 'package:live_vitalist/storage/data/firebase_handler.dart';
import 'package:live_vitalist/storage/domain/storage_handler.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'storage_provider.g.dart';

typedef Data = Map<String, dynamic>;

@riverpod
class Storage extends _$Storage implements IStorageHandler {
  String path = '';
  Data data = {};

  late ResponseChain<Future<Data?>> loadChain;
  late ResponseChain<Future<bool>> saveChain;
  late ResponseChain<Future<bool>> deletionChain;

  Future<Data?> mergeFutureData(
    Future<Data?> superior,
    Future<Data?> inferior,
  ) async {
    final s = await superior;
    final i = await inferior;
    if (i == null) return s;
    if (s == null) return i;
    return JsonHandler.mergeBaseAddon<String>(s, i);
  }

  @override
  void build() {
    final fileHandler = FileHandler();
    final firebaseHandler = FirebaseHandler();

    final firebaseLoad = ResponseChain<Future<Data?>>(
      respond: () => firebaseHandler.loadJson(path),
    );
    final fileLoad = ResponseChain<Future<Data?>>(
      respond: () => fileHandler.loadJson(path),
      subordinate: firebaseLoad,
      resolve: mergeFutureData,
    );
    loadChain = fileLoad;

    final firebaseSave = ResponseChain<Future<bool>>(
      respond: () => firebaseHandler.saveJson(path, data),
    );
    final fileSave = ResponseChain<Future<bool>>(
      respond: () => fileHandler.saveJson(path, data),
      subordinate: firebaseSave,
      resolve: (superior, inferior) async {
        return (await superior) && (await inferior);
      },
    );
    saveChain = fileSave;

    final firebaseDeletion = ResponseChain<Future<bool>>(
      respond: firebaseHandler.delete,
    );
    final fileDeletion = ResponseChain<Future<bool>>(
      respond: fileHandler.delete,
      subordinate: firebaseDeletion,
      resolve: (superior, inferior) async {
        return (await superior) && (await inferior);
      },
    );
    deletionChain = fileDeletion;
  }

  @override
  Future<bool> saveJson(String path, Map<String, dynamic> json) {
    this.path = path;
    data = json;
    return saveChain.chainResponse();
  }

  @override
  Future<Map<String, dynamic>?> loadJson(String path) {
    this.path = path;
    return loadChain.chainResponse();
  }

  @override
  Future<bool> delete() {
    return deletionChain.chainResponse();
  }
}
