import 'package:flutter/cupertino.dart';

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
    return const IgnorePointer(child: SizedBox.expand());
  }
}
