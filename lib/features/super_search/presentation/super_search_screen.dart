import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:live_vitalist/features/super_search/domain/super_search_state.dart';
import 'package:live_vitalist/features/super_search/presentation/controllers/super_search_controller.dart';
import 'package:live_vitalist/features/super_search/presentation/utils/add_aliment_actions.dart';
import 'package:live_vitalist/features/super_search/presentation/widgets/search_overlay.dart';
import 'package:live_vitalist/features/super_search/presentation/widgets/super_bar.dart';

class SuperSearchScreen extends ConsumerStatefulWidget {
  final bool isHomeRoute;

  const SuperSearchScreen({
    super.key,
    required this.isHomeRoute,
  });

  @override
  ConsumerState<SuperSearchScreen> createState() => _SuperSearchScreenState();
}

class _SuperSearchScreenState extends ConsumerState<SuperSearchScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<SuperSearchState>(superSearchProvider, (previous, next) {
      if (previous?.isActive == true && !next.isActive) {
        _searchController.clear();
        FocusManager.instance.primaryFocus?.unfocus();
      }
    });

    final searchNotifier = ref.read(superSearchProvider.notifier);
    final isActiveProvider = superSearchProvider.select((s) => s.isActive);
    final isVisible = widget.isHomeRoute || ref.watch(isActiveProvider);

    return Stack(
      children: [
        Positioned.fill(child: SearchOverlay()),
        AnimatedPositioned(
          duration: Duration(milliseconds: 500),
          curve: Curves.easeOutCubic,
          left: 12.0,
          right: 12.0,
          bottom: isVisible ? 20.0 : -80.0,
          child: TextFieldTapRegion(
            child: SuperBar(
              controller: _searchController,
              onEnter: searchNotifier.enter,
              onExit: searchNotifier.exit,
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
    );
  }
}
