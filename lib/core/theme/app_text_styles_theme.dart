import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:live_vitalist/core/theme/app_colors_theme.dart';
import 'package:live_vitalist/core/theme/palette.dart';

class AppTextStylesTheme extends ThemeExtension<AppTextStylesTheme> {
  const AppTextStylesTheme({
    required this.dayViewRegular,
    required this.highlight,
  });

  final TextStyle dayViewRegular;
  final TextStyle highlight;

  static final light = AppTextStylesTheme(
    dayViewRegular: GoogleFonts.sourceSans3(
      color: Palette.gray,
      fontSize: 16.0,
      height: 1.2,
      letterSpacing: -0.5,
    ),
    highlight: GoogleFonts.poppins(
      color: AppColorsTheme.light.select,
      fontSize: 16.0,
      height: 1.2,
      letterSpacing: -0.5,
    ),
  );

  static final dark = AppTextStylesTheme(
    dayViewRegular: GoogleFonts.sourceSans3(
      color: Palette.gray,
      fontSize: 16.0,
      height: 1.2,
      letterSpacing: -0.5,
    ),
    highlight: GoogleFonts.poppins(
      color: AppColorsTheme.dark.select,
      fontSize: 16.0,
      height: 1.2,
      letterSpacing: -0.5,
    ),
  );

  static AppTextStylesTheme of(BuildContext context) =>
      Theme.of(context).extension<AppTextStylesTheme>() ?? light;

  @override
  AppTextStylesTheme copyWith({
    TextStyle? dayViewRegular,
    TextStyle? highlight,
  }) {
    return AppTextStylesTheme(
      dayViewRegular: dayViewRegular ?? this.dayViewRegular,
      highlight: highlight ?? this.highlight,
    );
  }

  @override
  AppTextStylesTheme lerp(covariant AppTextStylesTheme? other, double t) {
    if (other == null) return this;

    return AppTextStylesTheme(
      dayViewRegular: TextStyle.lerp(dayViewRegular, other.dayViewRegular, t)!,
      highlight: TextStyle.lerp(highlight, other.highlight, t)!,
    );
  }
}
