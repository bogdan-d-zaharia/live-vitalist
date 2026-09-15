import 'package:flutter/material.dart';
import 'package:live_vitalist/core/presentation/widgets/tonal_icon.dart';

class CustomAlertDialog extends StatelessWidget {
  final Icon? icon;
  final Widget? title;
  final Widget? content;
  final List<Widget>? actions;

  const CustomAlertDialog({
    super.key,
    this.icon,
    this.title,
    this.content,
    this.actions,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      insetPadding: EdgeInsets.all(24.0),
      title: switch (true) {
        _ when title != null && icon != null => Row(
            children: [
              TonalIcon(icon: icon!),
              SizedBox(width: 16.0),
              Expanded(child: title!),
            ],
          ),
        _ when title != null => title,
        _ when icon != null => TonalIcon(icon: icon!),
        _ => null,
      },
      content: content,
      actions: actions,
    );
  }
}
