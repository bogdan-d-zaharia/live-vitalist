import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:live_vitalist/features/super_search/presentation/controllers/super_search_controller.dart';
import 'package:live_vitalist/features/super_search/presentation/utils/add_aliment_actions.dart';
import 'package:live_vitalist/features/super_search/presentation/utils/super_search_navigation.dart';
import 'package:live_vitalist/features/super_search/presentation/widgets/search_overlay.dart';
import 'package:live_vitalist/features/super_search/presentation/widgets/super_bar.dart';

class SuperSearchScreen extends ConsumerStatefulWidget {
  final bool isHomeRoute;
  final bool isSearchRoute;

  const SuperSearchScreen({
    super.key,
    required this.isHomeRoute,
    required this.isSearchRoute,
  });

  @override
  ConsumerState<SuperSearchScreen> createState() => _SuperSearchScreenState();
}

class _SuperSearchScreenState extends ConsumerState<SuperSearchScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void didUpdateWidget(covariant SuperSearchScreen oldWidget) {
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
    final searchNotifier = ref.read(superSearchProvider.notifier);
    final isActive = widget.isSearchRoute;
    final isVisible = widget.isHomeRoute;

    return SafeArea(
      child: Stack(
        children: [
          Positioned.fill(child: SearchOverlay(isActive: isActive)),
          AnimatedPositioned(
            duration: Duration(milliseconds: 500),
            curve: Curves.easeOutCubic,
            left: 12.0,
            right: 12.0,
            bottom: switch (true) {
              _ when isActive => 20.0,
              _ when isVisible => 0.0,
              _ => -80.0,
            },
            child: TextFieldTapRegion(
              child: SuperBar(
                controller: _searchController,
                isActive: isActive,
                onEnter: () => SuperSearchNavigation.open(context, ref),
                onExit: () => SuperSearchNavigation.close(context),
                onChanged: searchNotifier.setQuery,
                onAdd: (isTemp, isGen) {
                  if (isGen) {
                    AddAlimentActions.addGenerated(
                      context,
                      ref,
                      _searchController.text,
                      isTemp: isTemp,
                    );
                  } else if (isTemp) {
                    AddAlimentActions.addTemporary(context, ref);
                  } else {
                    AddAlimentActions.addInstanced(context, ref);
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
