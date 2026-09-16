import 'package:flutter/material.dart';

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
      constraints: BoxConstraints(minWidth: 140.0, maxWidth: 200.0),
      items: itemBuilder(context),
    );
    if (selected == null || !context.mounted) return;
    onSelected(selected);
  }

  @override
  Widget build(BuildContext context) => GestureDetector(
        behavior: HitTestBehavior.opaque,
        onLongPressStart: (details) => _show(context, details.globalPosition),
        child: child,
      );
}
