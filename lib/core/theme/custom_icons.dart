import 'package:flutter/material.dart';

class CustomIcons {
  CustomIcons._();

  static const String _fontFamily = 'Live Vitalist Icons';

  static const IconData logo = IconData(0xE100, fontFamily: _fontFamily);

  //#region // * Onboarding * //
  static const IconData weight = IconData(0xE000, fontFamily: _fontFamily);
  static const IconData muscle = IconData(0xE001, fontFamily: _fontFamily);
  static const IconData health = IconData(0xE002, fontFamily: _fontFamily);
  static const IconData performance = IconData(0xE003, fontFamily: _fontFamily);

  static const IconData macros = IconData(0xE010, fontFamily: _fontFamily);
  static const IconData riskFactors = IconData(0xE011, fontFamily: _fontFamily);
  static const IconData electrolytes =
      IconData(0xE012, fontFamily: _fontFamily);
  static const IconData vitamins = IconData(0xE013, fontFamily: _fontFamily);
  static const IconData minerals = IconData(0xE014, fontFamily: _fontFamily);

  static const IconData streakOn = IconData(0xE020, fontFamily: _fontFamily);
  static const IconData streakOff = IconData(0xE021, fontFamily: _fontFamily);
  //#endregion // * Onboarding * //
}
