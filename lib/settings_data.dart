import 'package:shared_preferences/shared_preferences.dart';

abstract final class SettingsData {
  static late SharedPreferencesWithCache _prefs;

  static Future<void> init() async {
    _prefs = await SharedPreferencesWithCache.create(
        cacheOptions: SharedPreferencesWithCacheOptions());
  }

  /* The set and get work sync
     because there is a table manipulated under the hood. */
  static bool get isMonthDay => _prefs.getBool('isMonthDay') ?? false;
  static set isMonthDay(bool val) => _prefs.setBool('isMonthDay', val);

  static bool get isLoggedIn => _prefs.getBool('isLoggedIn') ?? false;
  static set isLoggedIn(bool val) => _prefs.setBool('isLoggedIn', val);

  static String get language => _prefs.getString('language') ?? 'ENG';
  static set language(String val) => _prefs.setString('language', val);

  static bool get isComplexCalendar =>
      _prefs.getBool('isComplexCalendar') ?? false;
  static set isComplexCalendar(bool val) =>
      _prefs.setBool('isComplexCalendar', val);

  static int get sort => _prefs.getInt('sort') ?? 0;
  static set sort(int val) => _prefs.setInt('sort', val);

  static bool get isSmartHide => _prefs.getBool('isSmartHide') ?? false;
  static set isSmartHide(bool val) => _prefs.setBool('isSmartHide', val);

  static bool get isShowOmegaBalance =>
      _prefs.getBool('isShowOmegaBalance') ?? false;
  static set isShowOmegaBalance(bool val) =>
      _prefs.setBool('isShowOmegaBalance', val);

  static Future<void> deleteAll() async {
    await _prefs.clear();
  }
}
