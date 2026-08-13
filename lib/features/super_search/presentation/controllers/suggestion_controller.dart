import 'dart:async';

import 'package:live_vitalist/features/super_search/domain/super_bar_suggestion.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'suggestion_controller.g.dart';

@riverpod
class SuggestionController extends _$SuggestionController {
  Timer? _timer;

  @override
  int build(SuperBarSuggestions suggestions) {
    _timer?.cancel();
    ref.onDispose(() => _timer?.cancel());

    if (suggestions.items.isEmpty) return 0;

    _scheduleNext(suggestions.items, 0);
    return 0;
  }

  void _scheduleNext(List<SuperBarSuggestion> suggestions, int currentIndex) {
    if (suggestions.length < 2) return;

    _timer = Timer(suggestions[currentIndex].duration, () {
      final nextIndex = (currentIndex + 1) % suggestions.length;
      state = nextIndex;
      _scheduleNext(suggestions, nextIndex);
    });
  }
}
