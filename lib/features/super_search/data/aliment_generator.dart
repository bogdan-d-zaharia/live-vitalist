import 'package:firebase_ai/firebase_ai.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:live_vitalist/core/firebase/app_check_provider.dart';
import 'package:live_vitalist/features/aliment/data/aliment_data_extensions.dart';
import 'package:live_vitalist/features/aliment/domain/aliment_data.dart';
import 'package:live_vitalist/features/super_search/prompt_template.dart';

part 'aliment_generator.g.dart';

/// Fills in the nutritional data of an aliment by asking Gemini, through
/// Firebase AI Logic, about the given input. The app never holds an API
/// key: Firebase authorizes and bills the request on the app's project.

@Riverpod(keepAlive: true)
class AlimentGenerator extends _$AlimentGenerator {
  @override
  void build() {}

  static const String _model = 'gemini-flash-latest';

  Future<AlimentData> generate(String input) async {
    await ref.read(appCheckProvider.future);

    final prompt = promptTemplate.replaceFirst('<<input-ul>>', input);

    final model = FirebaseAI.googleAI().generativeModel(model: _model);
    final response = await model.generateContent([Content.text(prompt)]);

    final text = response.text;
    if (text == null || text.isEmpty) {
      throw StateError('Gemini did not return any text.');
    }

    return AlimentData.fromJson(
      AlimentData.empty.fromExpandedJsonWithCommentsToJsonMap(
        _extractJsonObject(text),
      ),
    );
  }

  /// Cuts out the outermost `{...}`, dropping markdown fences and any
  /// text the model wrote around the JSON.
  static String _extractJsonObject(String text) {
    final start = text.indexOf('{');
    final end = text.lastIndexOf('}');
    if (start == -1 || end <= start) {
      throw FormatException('No JSON object found in the response:\n$text');
    }
    return text.substring(start, end + 1);
  }
}
