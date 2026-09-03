import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:live_vitalist/features/super_search/presentation/controllers/super_search_controller.dart';
import 'package:live_vitalist/features/super_search/presentation/controllers/add_aliment_controller.dart';
import 'package:live_vitalist/features/super_search/presentation/utils/super_search_navigation.dart';
import 'package:live_vitalist/features/super_search/presentation/widgets/super_bar.dart';

class SuperSearchBarOverlay extends ConsumerStatefulWidget {
  final bool isHomeRoute;
  final bool isSearchRoute;

  const SuperSearchBarOverlay({
    super.key,
    required this.isHomeRoute,
    required this.isSearchRoute,
  });

  @override
  ConsumerState<SuperSearchBarOverlay> createState() =>
      _SuperSearchBarOverlayState();
}

class _SuperSearchBarOverlayState extends ConsumerState<SuperSearchBarOverlay> {
  final TextEditingController _searchController = TextEditingController();
  bool _isOpeningSearch = false;

  Future<void> _openSearch() async {
    if (_isOpeningSearch || widget.isSearchRoute) return;

    _isOpeningSearch = true;
    try {
      await SuperSearchNavigation.open(context, ref);
    } finally {
      _isOpeningSearch = false;
    }
  }

  @override
  void didUpdateWidget(covariant SuperSearchBarOverlay oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.isSearchRoute && !widget.isSearchRoute) {
      _searchController.clear();
      FocusManager.instance.primaryFocus?.unfocus();
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isActive = widget.isSearchRoute;
    final hasThreeButtonNavigation =
        MediaQuery.viewPaddingOf(context).bottom >= 40.0;

    return SafeArea(
      child: Stack(
        children: [
          AnimatedPositioned(
            duration: Duration(milliseconds: 500),
            curve: Curves.easeOutCubic,
            left: 12.0,
            right: 12.0,
            bottom: switch (true) {
              _ when isActive => 20.0,
              _ when widget.isHomeRoute =>
                hasThreeButtonNavigation ? 20.0 : 0.0,
              _ => -80.0,
            },
            child: TextFieldTapRegion(
              child: SuperBar(
                controller: _searchController,
                isActive: isActive,
                onEnter: _openSearch,
                onExit: () => SuperSearchNavigation.close(context),
                onChanged: (query) =>
                    ref.read(superSearchProvider.notifier).setQuery(query),
                onAdd: () => ref
                    .read(addAlimentProvider.notifier)
                    .add(context, _searchController.text),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
