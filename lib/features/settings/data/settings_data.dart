import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

enum Sort {
  unsorted,
  ascending,
  descending,
}

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

  static bool get hasCompletedOnboarding =>
      _prefs.getBool('isLoggedIn') ?? false;
  static set hasCompletedOnboarding(bool val) =>
      _prefs.setBool('isLoggedIn', val);

  static String get termsVersion => _prefs.getString('termsVersion') ?? '';
  static set termsVersion(String val) => _prefs.setString('termsVersion', val);

  static String get privacyVersion => _prefs.getString('privacyVersion') ?? '';
  static set privacyVersion(String val) =>
      _prefs.setString('privacyVersion', val);

  static String? get language => _prefs.getString('language');
  static set language(String? val) => val != null
      ? _prefs.setString('language', val)
      : _prefs.remove('language');

  static bool get isComplexCalendar =>
      _prefs.getBool('isComplexCalendar') ?? false;
  static set isComplexCalendar(bool val) =>
      _prefs.setBool('isComplexCalendar', val);

  static Sort get sort => Sort.values[_prefs.getInt('sort')?.clamp(0, 2) ?? 0];
  static set sort(Sort val) => _prefs.setInt('sort', val.index);

  static bool get isSmartHide => _prefs.getBool('isSmartHide') ?? false;
  static set isSmartHide(bool val) => _prefs.setBool('isSmartHide', val);

  static bool get isShowOmegaBalance =>
      _prefs.getBool('isShowOmegaBalance') ?? false;
  static set isShowOmegaBalance(bool val) =>
      _prefs.setBool('isShowOmegaBalance', val); //isShowCalorieDistribution

  static bool get isShowCalorieDistribution =>
      _prefs.getBool('isShowCalorieDistribution') ?? false;
  static set isShowCalorieDistribution(bool val) =>
      _prefs.setBool('isShowCalorieDistribution', val);

  static bool get hasAcceptedAiAlimentDisclaimer =>
      _prefs.getBool('hasAcceptedAiAlimentDisclaimer') ?? false;
  static set hasAcceptedAiAlimentDisclaimer(bool val) =>
      _prefs.setBool('hasAcceptedAiAlimentDisclaimer', val);

  static bool get isShowNutrientProgress =>
      _prefs.getBool('isShowNutrientProgress') ?? false;
  static set isShowNutrientProgress(bool val) =>
      _prefs.setBool('isShowNutrientProgress', val);

  static DateTime? get lastWeekReportReadDate {
    final str = _prefs.getString('lastWeekReportReadDate');
    if (str == null) return null;
    return DateFormat('yyyy-MM-dd').tryParse(str);
  }

  static set lastWeekReportReadDate(DateTime? date) {
    if (date == null) return;
    final str = DateFormat('yyyy-MM-dd').format(date);
    _prefs.setString('lastWeekReportReadDate', str);
  }

  static Future<void> deleteAll() async {
    await _prefs.clear();
  }
}
