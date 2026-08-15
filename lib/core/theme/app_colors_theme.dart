import 'package:flutter/material.dart';

class AppColorsTheme extends ThemeExtension<AppColorsTheme> {
  const AppColorsTheme({
    required this.select,
    required this.selectedLabelShadow,
  });

  final Color select;

  final Color selectedLabelShadow;

  static const light = AppColorsTheme(
    select: Color(0xFF84b8ad),
    selectedLabelShadow: Color(0x66000000),
  );

  static const dark = AppColorsTheme(
    select: Color(0xFF84b8ad),
    selectedLabelShadow: Color(0x99FFFFFF),
  );

  static AppColorsTheme of(BuildContext context) =>
      Theme.of(context).extension<AppColorsTheme>() ?? light;

  @override
  AppColorsTheme copyWith({
    Color? select,
    Color? selectedLabelShadow,
  }) {
    return AppColorsTheme(
      select: select ?? this.select,
      selectedLabelShadow: selectedLabelShadow ?? this.selectedLabelShadow,
    );
  }

  @override
  AppColorsTheme lerp(covariant AppColorsTheme? other, double t) {
    if (other == null) return this;

    return AppColorsTheme(
      select: Color.lerp(select, other.select, t)!,
      selectedLabelShadow:
          Color.lerp(selectedLabelShadow, other.selectedLabelShadow, t)!,
    );
  }
}
