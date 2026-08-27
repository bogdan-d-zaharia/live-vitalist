import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:live_vitalist/core/presentation/widgets/selectable_icon_button.dart';
import 'package:live_vitalist/core/presentation/widgets/sized_icon_button.dart';
import 'package:live_vitalist/features/super_search/domain/super_bar_suggestion.dart';
import 'package:live_vitalist/features/super_search/presentation/controllers/suggestion_controller.dart';
import 'package:live_vitalist/features/super_search/presentation/widgets/animated_suggestion_hint.dart';
import 'package:live_vitalist/features/super_search/super_search_constants.dart';

class SuperBar extends ConsumerStatefulWidget {
  static const defaultSuggestions = SuperBarSuggestions(
    items: [
      SuperBarSuggestion(
        text: 'Search aliments',
        duration: Duration(seconds: 4),
      ),
      SuperBarSuggestion(
        text: 'Add an aliment',
        duration: Duration(seconds: 4),
      ),
    ],
  );

  final TextEditingController? controller;
  final bool isActive;
  final SuperBarSuggestions suggestions;
  final void Function()? onEnter;
  final void Function()? onExit;
  final void Function(String)? onChanged;
  final void Function(bool isTemp, bool isGen)? onAdd;

  const SuperBar({
    super.key,
    this.controller,
    required this.isActive,
    this.suggestions = defaultSuggestions,
    required this.onEnter,
    required this.onExit,
    required this.onChanged,
    required this.onAdd,
  });

  @override
  ConsumerState<SuperBar> createState() => _SuperBarState();
}

class _SuperBarState extends ConsumerState<SuperBar> {
  final FocusNode _focusNode = FocusNode();
  bool isTemp = false;
  bool isGen = false;

  @override
  void didUpdateWidget(covariant SuperBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!oldWidget.isActive && widget.isActive) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) _focusNode.requestFocus();
      });
    }
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  void onTemp() {
    setState(() {
      isTemp = !isTemp;
    });
  }

  void onGen() {
    setState(() {
      isGen = !isGen;
    });
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final barColor = Color.alphaBlend(
      colorScheme.primary.withValues(alpha: 0.04),
      colorScheme.surfaceContainerLow,
    );
    final suggestionIndex =
        ref.watch(suggestionControllerProvider(widget.suggestions));
    final suggestion = widget.suggestions.items.isEmpty
        ? null
        : widget.suggestions.items[suggestionIndex];
    final borderRadius = BorderRadius.circular(
      SuperSearchConstants.barHeight / 2.0,
    );

    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: borderRadius,
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withValues(alpha: 0.12),
            blurRadius: 18.0,
            offset: Offset(0.0, 6.0),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: borderRadius,
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
          child: Stack(
            children: [
              SearchBar(
                overlayColor: WidgetStateProperty.resolveWith((states) {
                  if (states.contains(WidgetState.pressed)) {
                    return colorScheme.surface.withValues(alpha: 0.24);
                  }

                  if (states.contains(WidgetState.hovered)) {
                    return colorScheme.surface.withValues(alpha: 0.18);
                  }

                  if (states.contains(WidgetState.focused)) {
                    return colorScheme.surface.withValues(alpha: 0.12);
                  }

                  return Colors.transparent;
                }),
                backgroundColor: WidgetStatePropertyAll(
                  barColor.withValues(alpha: 0.72),
                ),
                elevation: WidgetStatePropertyAll(0.0),
                shadowColor: WidgetStatePropertyAll(Colors.transparent),
                side: WidgetStatePropertyAll(
                  BorderSide(
                    color: colorScheme.outlineVariant.withValues(alpha: 0.5),
                  ),
                ),
                shape: WidgetStatePropertyAll(
                  RoundedRectangleBorder(borderRadius: borderRadius),
                ),
                controller: widget.controller,
                focusNode: _focusNode,
                onTap: widget.onEnter,
                onChanged: widget.onChanged,
                constraints: BoxConstraints(
                  minHeight: SuperSearchConstants.barHeight,
                ),
                padding: WidgetStatePropertyAll(
                  EdgeInsets.symmetric(
                    horizontal: SuperSearchConstants.barHorizontalPadding,
                  ),
                ),
                leading: SizedIconButton(
                  onPressed: () => widget.onAdd?.call(isTemp, isGen),
                  icon: Icon(Icons.add_rounded),
                  buttonSize: SuperSearchConstants.barButtonSize,
                  iconSize: SuperSearchConstants.barIconSize,
                ),
                trailing: [
                  SelectableIconButton(
                    isSelected: isTemp,
                    onPressed: onTemp,
                    icon: Icon(Icons.history_toggle_off_rounded),
                    selectedColor: Colors.black,
                    buttonSize: SuperSearchConstants.barButtonSize,
                    iconSize: SuperSearchConstants.barIconSize,
                  ),
                  SizedBox(width: SuperSearchConstants.barButtonPadding),
                  SelectableIconButton(
                    isSelected: isGen,
                    onPressed: onGen,
                    icon: Icon(Icons.auto_awesome_rounded),
                    selectedColor: Colors.deepPurple,
                    buttonSize: SuperSearchConstants.barButtonSize,
                    iconSize: SuperSearchConstants.barIconSize,
                  ),
                ],
              ),
              Positioned.fill(
                child: AnimatedSuggestionHint(
                  animationKey: suggestionIndex,
                  text: suggestion?.text,
                  duration: suggestion?.duration ?? Duration.zero,
                  controller: widget.controller,
                  padding: EdgeInsets.only(
                    left: SuperSearchConstants.barHorizontalPadding +
                        SuperSearchConstants.barButtonSize +
                        12.0,
                    right: SuperSearchConstants.barHorizontalPadding +
                        SuperSearchConstants.barButtonSize * 2.0 +
                        SuperSearchConstants.barButtonPadding +
                        12.0,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
