import 'json_handler.dart';

Future<void> main() async {
  final Map<String, dynamic> local = {
    'a': 1,
    'b': [2]
  };
  final Map<String, dynamic> internet = {};

  final merged = JsonHandler.mergeBaseAddon(local, internet);
  print(merged);
}
