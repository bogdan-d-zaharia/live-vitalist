import 'package:firebase_ai/firebase_ai.dart';
import 'package:live_vitalist/aliment/data/aliment_data_extensions.dart';
import 'package:live_vitalist/aliment/domain/aliment_data.dart';
import 'package:live_vitalist/super_search/prompt_template.dart';

/// Fills in the nutritional data of an aliment by asking Gemini, through
/// Firebase AI Logic, about the given input. The app never holds an API
/// key: Firebase authorizes and bills the request on the app's project.
abstract final class AlimentGenerator {
  static const String _model = 'gemini-flash-latest';

  /// Number of attempts before giving up when the model is momentarily
  /// unavailable (transient 500/503 server errors).
  static const int _maxAttempts = 3;

  /// Base wait between attempts; grows with each retry.
  static const Duration _retryBaseDelay = Duration(seconds: 2);

  static Future<AlimentData> generate(String input) async {
    final prompt = promptTemplate.replaceFirst('<<input-ul>>', input);

    final model = FirebaseAI.googleAI().generativeModel(model: _model);
    final response = await _generateWithRetry(
      model,
      [Content.text(prompt)],
    );

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

  /// Runs [GenerativeModel.generateContent], retrying on transient server
  /// errors (the model reporting high demand) with an increasing delay.
  static Future<GenerateContentResponse> _generateWithRetry(
    GenerativeModel model,
    List<Content> content,
  ) async {
    for (var attempt = 1;; attempt++) {
      try {
        return await model.generateContent(content);
      } on ServerException {
        if (attempt >= _maxAttempts) rethrow;
        await Future.delayed(_retryBaseDelay * attempt);
      }
    }
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
