import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:live_vitalist/core/theme/palette.dart';

abstract final class ReportStyles {
  static TextStyle monitor = GoogleFonts.sourceSans3(
    color: Palette.gray,
    fontSize: 14.0,
    height: 1.2,
    letterSpacing: -0.5,
  );

  static TextStyle dayViewLabel = GoogleFonts.sourceSans3(
    color: Palette.gray,
    fontSize: 12.0,
    height: 0.0,
    letterSpacing: -0.5,
  );

  static TextStyle dayViewBold = GoogleFonts.poppins(
    color: Palette.lightGray,
    fontSize: 16.0,
    height: 0.8,
    letterSpacing: -0.5,
    fontWeight: FontWeight.w500,
  );
}
