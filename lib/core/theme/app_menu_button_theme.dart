import 'package:flutter/material.dart';

class AppMenuButtonTheme extends ThemeExtension<AppMenuButtonTheme> {
  final ButtonStyle style;

  const AppMenuButtonTheme({required this.style});

  factory AppMenuButtonTheme.subtle(ColorScheme colors) => AppMenuButtonTheme(
        style: TextButton.styleFrom(
          foregroundColor: colors.onSurface,
          backgroundColor: Colors.transparent,
          disabledBackgroundColor: Colors.transparent,
          disabledForegroundColor: colors.onSurface.withValues(alpha: 0.5),
          padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 10.0),
          minimumSize: Size(0.0, 44.0),
          textStyle: TextStyle(fontSize: 14.0, fontWeight: FontWeight.w500),
          iconSize: 18.0,
          side: BorderSide.none,
          shape: StadiumBorder(),
        ),
      );

  @override
  AppMenuButtonTheme copyWith({ButtonStyle? style}) =>
      AppMenuButtonTheme(style: style ?? this.style);

  @override
  AppMenuButtonTheme lerp(covariant AppMenuButtonTheme? other, double t) {
    if (other == null) return this;
    return AppMenuButtonTheme(style: ButtonStyle.lerp(style, other.style, t)!);
  }
}
