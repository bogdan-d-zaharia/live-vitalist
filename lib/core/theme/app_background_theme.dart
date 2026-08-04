import 'package:flutter/material.dart';

class AppBackgroundTheme extends ThemeExtension<AppBackgroundTheme> {
  const AppBackgroundTheme({
    required this.colors,
    required this.washColor,
    this.cycleDuration = const Duration(seconds: 8),
  });

  final List<Color> colors;
  final Color washColor;
  final Duration cycleDuration;

  static const light = AppBackgroundTheme(
    colors: [
      Color.fromARGB(200, 255, 255, 255),
      Color.fromARGB(60, 124, 225, 93),
      Color.fromARGB(200, 255, 255, 255),
      Color.fromARGB(80, 112, 251, 70),
    ],
    washColor: Colors.white,
  );

  static const dark = AppBackgroundTheme(
    colors: [
      Color.fromARGB(200, 0, 0, 0),
      Color.fromARGB(30, 124, 225, 93),
      Color.fromARGB(200, 0, 0, 0),
      Color.fromARGB(40, 215, 251, 70),
    ],
    washColor: Color(0xFF121212),
  );

  static AppBackgroundTheme of(BuildContext context) =>
      Theme.of(context).extension<AppBackgroundTheme>() ?? light;

  @override
  AppBackgroundTheme copyWith({
    List<Color>? colors,
    Color? washColor,
    Duration? cycleDuration,
  }) {
    return AppBackgroundTheme(
      colors: colors ?? this.colors,
      washColor: washColor ?? this.washColor,
      cycleDuration: cycleDuration ?? this.cycleDuration,
    );
  }

  @override
  AppBackgroundTheme lerp(covariant AppBackgroundTheme? other, double t) {
    if (other == null) return this;

    final colorCount = colors.length < other.colors.length
        ? colors.length
        : other.colors.length;

    return AppBackgroundTheme(
      colors: [
        for (var i = 0; i < colorCount; i++)
          Color.lerp(colors[i], other.colors[i], t)!,
      ],
      washColor: Color.lerp(washColor, other.washColor, t)!,
      cycleDuration: t < 0.5 ? cycleDuration : other.cycleDuration,
    );
  }
}
