import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

abstract final class Palette {
  static bool isDarkMode(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark;

  static RichText dimParentheses(String label, TextStyle? style) {
    style = style ?? TextStyle();

    var x = label.indexOf('(');
    x = x != -1 ? x : label.length;

    final label1 = label.substring(0, x);
    final label2 = label.substring(x);

    return RichText(
      overflow: TextOverflow.ellipsis,
      maxLines: 1,
      text: TextSpan(
        children: [
          TextSpan(text: label1, style: style),
          TextSpan(
            text: label2,
            style: style.copyWith(
              color: Colors.grey,
              fontSize: style.fontSize != null ? style.fontSize! - 2.5 : null,
            ),
          ),
        ],
      ),
    );
  }

  // #region //* COLORS *//
  static const Color divGrey = Color.fromRGBO(158, 158, 158, 0.25);
  // static const Color brightLightGray = Color.fromRGBO(224, 224, 224, 1);

  static const Color almostWhite = Color.fromRGBO(204, 204, 204, 1);
  static const Color lightGray = Color(0xFFbfbfbf);
  static const Color gray = Color(0xFF999999);
  static const Color darkGray = Color(0xFF2d2f33);
  static const Color blueGray = Color(0xFF242528);

  static const Color selectGreen = Color(0xFF84b8ad);

  //TODO: Make them static and implement, so that we have greyer colors.
  // final Color red = Color.lerp(Colors.red, Colors.grey, 0.1)!;
  // final Color blue = Color.lerp(Colors.blue, Colors.grey, 0.1)!;
  // final Color yellow = Color.lerp(Colors.yellow, Colors.grey, 0.1)!;

  static const Color proteinRed = Colors.red;
  static const Color carbBlue = Colors.blue;
  static const Color fatYellow = Colors.yellow;

  // Fufillment
  static const greenTransparent = Color(0xCCb9ea93);
  static const green = Color(0xFFa3e673);
  static const greenGradientColors = [
    Color(0xFF94e500),
    Color(0xFFb2ff7f),
  ];
  static const redTransparent = Color(0x80ff774c);
  static const red = Color(0xFFff7c4c);
  // #endregion

  // #region //* TEXT STYLES *//
  static TextStyle header = GoogleFonts.roboto(
    color: Palette.almostWhite,
    fontSize: 20.0,
    height: 1.2,
  );

  static TextStyle highlight = GoogleFonts.poppins(
    color: Palette.selectGreen,
    fontSize: 16.0,
    height: 1.2,
    letterSpacing: -0.5,
  );

  static TextStyle calendarItem = GoogleFonts.poppins(
    color: Colors.black,
    fontSize: 15.0,
    height: 0.8,
    letterSpacing: -0.5,
    fontWeight: FontWeight.w300,
  );

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

  static TextStyle dayViewRegular = GoogleFonts.sourceSans3(
    color: Palette.gray,
    fontSize: 16.0,
    height: 1.2,
    letterSpacing: -0.5,
  );

  static TextStyle dayViewBold = GoogleFonts.poppins(
    color: Palette.lightGray,
    fontSize: 16.0,
    height: 0.8,
    letterSpacing: -0.5,
    fontWeight: FontWeight.w500,
  );
  // #endregion

  // #region //* THEMES *//
  static final darkMode = const TextTheme().copyWith(
    //TODO: Import the fonts as assets directly
    //in order to be bundled locally.
    bodyLarge: GoogleFonts.sourceSans3(
      color: Colors.white,
      fontSize: 20.0,
      fontWeight: FontWeight.bold,
      height: 1.2,
      letterSpacing: -0.5,
    ),
    bodyMedium: GoogleFonts.sourceSans3(
      color: Palette.almostWhite,
      fontSize: 18.0,
      fontWeight: FontWeight.normal,
      height: 1.2,
      letterSpacing: -0.5,
    ),
  );
  // #endregion

  // #region //* CARD THEMES *//
  static final darkModeCard = CardTheme(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    color: Palette.blueGray,
  );
  // #endregion
}
