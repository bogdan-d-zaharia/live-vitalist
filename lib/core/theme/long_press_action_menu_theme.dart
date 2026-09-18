import 'dart:ui' show lerpDouble;

import 'package:flutter/material.dart';

class LongPressActionMenuTheme
    extends ThemeExtension<LongPressActionMenuTheme> {
  final PopupMenuThemeData menuTheme;
  final BoxConstraints constraints;
  final double itemHeight;
  final EdgeInsets itemPadding;
  final double iconSize;
  final double iconSpacing;

  const LongPressActionMenuTheme({
    required this.menuTheme,
    required this.constraints,
    required this.itemHeight,
    required this.itemPadding,
    required this.iconSize,
    required this.iconSpacing,
  });

  factory LongPressActionMenuTheme.compact(ColorScheme colors) =>
      LongPressActionMenuTheme(
        menuTheme: PopupMenuThemeData(
          color: colors.surfaceContainerLow,
          surfaceTintColor: Colors.transparent,
          shadowColor: colors.shadow.withValues(alpha: 0.24),
          elevation: 5.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
            side:
                BorderSide(color: colors.outlineVariant.withValues(alpha: 0.6)),
          ),
          menuPadding: EdgeInsets.symmetric(vertical: 4.0),
          textStyle: TextStyle(
            fontSize: 14.0,
            fontWeight: FontWeight.w500,
            color: colors.onSurface,
          ),
        ),
        constraints: BoxConstraints(minWidth: 156.0, maxWidth: 176.0),
        itemHeight: 40.0,
        itemPadding: EdgeInsets.symmetric(horizontal: 12.0),
        iconSize: 18.0,
        iconSpacing: 10.0,
      );

  static LongPressActionMenuTheme of(BuildContext context) =>
      Theme.of(context).extension<LongPressActionMenuTheme>() ??
      LongPressActionMenuTheme.compact(Theme.of(context).colorScheme);

  @override
  LongPressActionMenuTheme copyWith({
    PopupMenuThemeData? menuTheme,
    BoxConstraints? constraints,
    double? itemHeight,
    EdgeInsets? itemPadding,
    double? iconSize,
    double? iconSpacing,
  }) =>
      LongPressActionMenuTheme(
        menuTheme: menuTheme ?? this.menuTheme,
        constraints: constraints ?? this.constraints,
        itemHeight: itemHeight ?? this.itemHeight,
        itemPadding: itemPadding ?? this.itemPadding,
        iconSize: iconSize ?? this.iconSize,
        iconSpacing: iconSpacing ?? this.iconSpacing,
      );

  @override
  LongPressActionMenuTheme lerp(
      covariant LongPressActionMenuTheme? other, double t) {
    if (other == null) return this;
    return LongPressActionMenuTheme(
      menuTheme: PopupMenuThemeData.lerp(menuTheme, other.menuTheme, t)!,
      constraints: BoxConstraints.lerp(constraints, other.constraints, t)!,
      itemHeight: lerpDouble(itemHeight, other.itemHeight, t)!,
      itemPadding: EdgeInsets.lerp(itemPadding, other.itemPadding, t)!,
      iconSize: lerpDouble(iconSize, other.iconSize, t)!,
      iconSpacing: lerpDouble(iconSpacing, other.iconSpacing, t)!,
    );
  }
}
