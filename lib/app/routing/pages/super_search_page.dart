import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:live_vitalist/features/super_search/presentation/widgets/search_overlay.dart';

class SuperSearchPage extends Page<void> {
  const SuperSearchPage({required super.key});

  @override
  Route<void> createRoute(BuildContext context) {
    return _SuperSearchRoute(settings: this);
  }
}

class _SuperSearchRoute extends PageRoute<void>
    with CupertinoRouteTransitionMixin<void> {
  _SuperSearchRoute({required super.settings});

  @override
  String? get title => null;

  @override
  bool get maintainState => true;

  @override
  bool get opaque => false;

  @override
  Color? get barrierColor => null;

  @override
  String? get barrierLabel => null;

  @override
  Widget buildContent(BuildContext context) {
    return const _SuperSearchPageContent();
  }
}

class _SuperSearchPageContent extends StatefulWidget {
  const _SuperSearchPageContent();

  @override
  State<_SuperSearchPageContent> createState() =>
      _SuperSearchPageContentState();
}

class _SuperSearchPageContentState extends State<_SuperSearchPageContent>
    with WidgetsBindingObserver {
  bool _keyboardVisible = false;
  bool _popScheduled = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _keyboardVisible = View.of(context).viewInsets.bottom > 0.0;
  }

  @override
  void didChangeMetrics() {
    final keyboardVisible = View.of(context).viewInsets.bottom > 0.0;
    final keyboardClosed = _keyboardVisible && !keyboardVisible;
    _keyboardVisible = keyboardVisible;

    if (defaultTargetPlatform != TargetPlatform.android ||
        !keyboardClosed ||
        _popScheduled) {
      return;
    }

    _popScheduled = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      final route = ModalRoute.of(context);
      if (route?.isCurrent ?? false) {
        Navigator.of(context).maybePop();
      }
      _popScheduled = false;
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return const SafeArea(child: SearchOverlay());
  }
}
