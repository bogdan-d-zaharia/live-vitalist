import 'package:flutter/material.dart';

InputDecoration editorInputDecoration(
  BuildContext context, {
  required String hintText,
  IconData? icon,
  Widget? suffix,
}) {
  final colors = Theme.of(context).colorScheme;
  final border = OutlineInputBorder(
    borderRadius: BorderRadius.circular(14.0),
    borderSide: BorderSide(color: colors.outlineVariant),
  );

  return InputDecoration(
    hintText: hintText,
    hintStyle: TextStyle(
      color: colors.onSurfaceVariant.withValues(alpha: 0.65),
    ),
    prefixIcon: icon == null ? null : Icon(icon, size: 20.0),
    suffixIcon: suffix,
    filled: true,
    fillColor: colors.surfaceContainerHighest.withValues(alpha: 0.45),
    contentPadding: EdgeInsets.symmetric(horizontal: 14.0, vertical: 12.0),
    enabledBorder: border,
    focusedBorder: border.copyWith(
      borderSide: BorderSide(color: colors.primary, width: 1.5),
    ),
  );
}
