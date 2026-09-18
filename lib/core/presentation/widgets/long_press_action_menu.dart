import 'package:flutter/material.dart';
import 'package:live_vitalist/core/theme/long_press_action_menu_theme.dart';

class LongPressActionMenu<T> extends StatelessWidget {
  final Widget child;
  final List<PopupMenuEntry<T>> Function(BuildContext context) itemBuilder;
  final ValueChanged<T> onSelected;

  const LongPressActionMenu({
    required this.child,
    required this.itemBuilder,
    required this.onSelected,
    super.key,
  });

  Future<void> _show(BuildContext context, Offset position) async {
    final overlay =
        Navigator.of(context).overlay!.context.findRenderObject()! as RenderBox;
    final local = overlay.globalToLocal(position);
    final selected = await showMenu<T>(
      context: context,
      position: RelativeRect.fromRect(
        Rect.fromLTRB(
            local.dx - 12.0, local.dy - 24.0, local.dx + 12.0, local.dy + 24.0),
        Offset.zero & overlay.size,
      ),
      constraints: LongPressActionMenuTheme.of(context).constraints,
      clipBehavior: Clip.antiAlias,
      items: itemBuilder(context),
    );
    if (selected == null || !context.mounted) return;
    onSelected(selected);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final menuTheme = LongPressActionMenuTheme.of(context);
    return Theme(
      data: theme.copyWith(popupMenuTheme: menuTheme.menuTheme),
      child: Builder(
          builder: (menuContext) => GestureDetector(
                behavior: HitTestBehavior.opaque,
                onLongPressStart: (details) =>
                    _show(menuContext, details.globalPosition),
                child: child,
              )),
    );
  }
}

class LongPressActionMenuItem<T> extends PopupMenuItem<T> {
  LongPressActionMenuItem({
    required BuildContext context,
    required T value,
    required IconData icon,
    required String label,
    super.enabled = true,
    bool isDestructive = false,
    super.key,
  }) : super(
          value: value,
          height: LongPressActionMenuTheme.of(context).itemHeight,
          padding: LongPressActionMenuTheme.of(context).itemPadding,
          child: Row(children: [
            Icon(
              icon,
              size: LongPressActionMenuTheme.of(context).iconSize,
              color: !enabled
                  ? Theme.of(context).disabledColor
                  : isDestructive
                      ? Theme.of(context).colorScheme.error
                      : Theme.of(context).colorScheme.onSurfaceVariant,
            ),
            SizedBox(width: LongPressActionMenuTheme.of(context).iconSpacing),
            Flexible(
                child: Text(
              label,
              style: isDestructive && enabled
                  ? TextStyle(color: Theme.of(context).colorScheme.error)
                  : null,
            )),
          ]),
        );
}
