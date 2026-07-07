import 'dart:convert';
import 'dart:io';
import 'package:live_vitalist/json_handler.dart';
import 'package:live_vitalist/storage/data/file_handler.dart';
import 'package:live_vitalist/storage/data/firebase_handler.dart';
import 'package:live_vitalist/storage/domain/storage_handler.dart';
import 'package:path/path.dart' as p;

///     LOAD                    : local || DOWNLOAD
///     SAVE                    : local && SYNC
///
///     DOWNLOAD  [INTERNET]    : local = cloud
///     - used to download old information
///       or after reinstalling.
///
///     SYNC      [INTERNET]    : cloud = local
///     - used to upload to cloud after no internet
///       or after creating an account.
///
///               [     IMPORTED      ]
///           [           LOCAL           ]
///     [                 CLOUD                 ]
final class StorageSolution implements IStorageHandler {
  static bool isFirebase = false;
  late IStorageHandler localMethod;
  late IStorageHandler cloudMethod;

  // #region Singleton
  StorageSolution._privateConstructor(
      {required this.localMethod, required this.cloudMethod});
  static final StorageSolution _instance = StorageSolution._privateConstructor(
    localMethod: FileHandler(),
    cloudMethod: FirebaseHandler(),
  );
  static StorageSolution get instance {
    return _instance;
  }
  // #endregion

  @override
  Future<bool> saveJson(String path, Map<String, dynamic> json) async {
    if (!await localMethod.saveJson(path, json)) return false;
    if (isFirebase) return cloudMethod.saveJson(path, json);
    return true;
  }

  /// Check `StorageHandler` doc.
  @override
  Future<Map<String, dynamic>?> loadJson(String path) async {
    final Map<String, dynamic>? fileJson = await localMethod.loadJson(path);
    //TODO: I don't think `convertIntsToDoubles` is needed because
    // it only saves doubles locally.
    // It could if downloaded directly from internet.
    // Perhaps `convertIntsToDoubles` after internet.loadJson.
    if (fileJson != null) return JsonHandler.convertIntsToDoubles(fileJson);

    /* DOWNLOAD */
    final Map<String, dynamic>? firebaseJson =
        JsonHandler.convertIntsToDoubles(await cloudMethod.loadJson(path));
    if (firebaseJson != null) {
      bool isADayDataThatIsOlderThanAWeek = false;

      final List<String> x = path.split('_');
      if (x.length >= 3) {
        final int? day = int.tryParse(x[0]);
        final int? month = int.tryParse(x[1]);
        final int? year = int.tryParse(x[2]);

        if (day != null && month != null && year != null) {
          isADayDataThatIsOlderThanAWeek =
              DateTime.now().difference(DateTime(year, month, day)) >
                  Duration(days: 7);
        }
      }

      if (!isADayDataThatIsOlderThanAWeek) {
        localMethod.saveJson(path, firebaseJson);
      }

      return firebaseJson;
    }

    return null;
  }

  Future<Map<String, dynamic>> loadSources() async {
    return {
      'local': await localMethod.loadJson('alimentBank') ?? {},
      'cloud': await cloudMethod.loadJson('alimentBank') ?? {},
    };
  }

  Future<void> syncAll() async {
    final dir = Directory(await FileHandler.localPath);
    for (File file in dir.listSync().whereType<File>()) {
      final fileName = p.basenameWithoutExtension(file.path);
      if (!file.existsSync() || fileName.contains('_backup')) continue;

      Map<String, dynamic>? json;
      try {
        json = JsonHandler.forceStringKeys(jsonDecode(file.readAsStringSync()));
        // ignore: empty_catches
      } catch (e) {}

      if (json != null) {
        await cloudMethod.saveJson(fileName, json);
      }
    }
  }
}
