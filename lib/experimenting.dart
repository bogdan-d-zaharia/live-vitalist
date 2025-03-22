import 'file_handler.dart';

Future<void> main() async {
  await FileHandler.saveJson({'c': 'd'}, date: DateTime(2025, 02, 23));
  // final x = await FileHandler.loadJson(date: DateTime(2025, 02, 22));
  // print(x.toString());
}
