import 'dart:convert';
import 'dart:io';

import 'json_handler.dart';

Future<void> main() async {
  // final file = File('c:\\Users\\bogda\\Desktop\\alimentBank.json');
  // final str = file.readAsStringSync();
  // final x = JsonHandler.processJson(jsonDecode(str)["aliments"]);

  // final map1 = Map.fromEntries(x.entries.take(20));
  // final map2 = Map.fromEntries(x.entries.skip(20).take(20));
  // final map3 = Map.fromEntries(x.entries.skip(40));

  // final file1 = File('c:\\Users\\bogda\\Desktop\\alimentBank1.json');
  // final file2 = File('c:\\Users\\bogda\\Desktop\\alimentBank2.json');
  // final file3 = File('c:\\Users\\bogda\\Desktop\\alimentBank3.json');

  // file1.writeAsStringSync(JsonHandler.decodeIndented({"aliments": map1}));
  // file2.writeAsStringSync(JsonHandler.decodeIndented({"aliments": map2}));
  // file3.writeAsStringSync(JsonHandler.decodeIndented({"aliments": map3}));

  final file = File('c:\\Users\\bogda\\Desktop\\w\\alimentBank - Copie.json');
  final str = file.readAsStringSync();
  final x = JsonHandler.processJson(jsonDecode(str));
  final y = JsonHandler.mapToListRecursive(x);

  final file2 =
      File('c:\\Users\\bogda\\Desktop\\w\\alimentBank - Copie - Copie.json');
  file2.writeAsStringSync(JsonHandler.decodeIndented(y));
}
