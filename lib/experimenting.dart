import 'dart:convert';
import 'dart:io';

import 'package:path/path.dart' as p;

import 'json_handler.dart';

Future<void> main() async {
  final localPath = 'c:\\Users\\bogda\\Desktop\\MicroHealth_0_0_7_archive';

  final Map<String, dynamic> json = {};

  void saveJson(String path, Map<String, dynamic> map) {
    json[path] = JsonHandler.mapToListRecursive(map);
  }

  final dir = Directory(localPath);
  for (File file in dir.listSync().whereType<File>()) {
    final fileName = p.basenameWithoutExtension(file.path);
    print(fileName);
    if (!file.existsSync() || fileName.contains('_backup')) continue;

    Map<String, dynamic>? json;
    try {
      json = JsonHandler.forceStringKeys(jsonDecode(file.readAsStringSync()));
      // ignore: empty_catches
    } catch (e) {}

    if (json != null) {
      saveJson(fileName, json);
    }
  }

  print(json);

  File('$localPath\\json.json').writeAsStringSync(jsonEncode(json));

  // final file1 =
  //     File('c:\\Users\\bogda\\Desktop\\MicroHealth_0_0_7_archive\\json.json');
  // // final file2 = File('c:\\Users\\bogda\\Downloads\\json2.json');

  // dynamic json1 = jsonDecode(file1.readAsStringSync());
  // json1 =
  // // final Map json2 = jsonDecode(file2.readAsStringSync());
  // // print(json1);
  // json1 = jsonEncode(json1);
  // // print('\n\n\n${json1.containsKey('12_04_2025')}\n\n');
  // // print(json2.keys);
  // // print('\n\n\n${json1.containsKey('12_04_2025')}\n\n');

  // // final Set keyunion = json1.keys.toSet()..addAll(json2.keys);
  // // final Set key1dif =
  // //     json1.keys.where((key) => !keyunion.contains(key)).toSet();
  // // final Set key2dif =
  // //     json2.keys.where((key) => !keyunion.contains(key)).toSet();

  // // print(keyunion);
  // // print('\n\n\n\n\n');
  // // print(key1dif);
  // // print('\n\n\n\n\n');
  // // print(key2dif);

  // File('$localPath\\json1.json').writeAsStringSync(json1);
}
