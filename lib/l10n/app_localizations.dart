import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[Locale('en')];

  /// No description provided for @nutrientKcals.
  ///
  /// In en, this message translates to:
  /// **'Calories'**
  String get nutrientKcals;

  /// No description provided for @nutrientProtein.
  ///
  /// In en, this message translates to:
  /// **'Protein'**
  String get nutrientProtein;

  /// No description provided for @nutrientCarbs.
  ///
  /// In en, this message translates to:
  /// **'Carbohydrates'**
  String get nutrientCarbs;

  /// No description provided for @nutrientSugars.
  ///
  /// In en, this message translates to:
  /// **'Sugars'**
  String get nutrientSugars;

  /// No description provided for @nutrientFibers.
  ///
  /// In en, this message translates to:
  /// **'Fibers'**
  String get nutrientFibers;

  /// No description provided for @nutrientFats.
  ///
  /// In en, this message translates to:
  /// **'Fats'**
  String get nutrientFats;

  /// No description provided for @nutrientOmega3.
  ///
  /// In en, this message translates to:
  /// **'Omega-3'**
  String get nutrientOmega3;

  /// No description provided for @nutrientOmega6.
  ///
  /// In en, this message translates to:
  /// **'Omega-6'**
  String get nutrientOmega6;

  /// No description provided for @nutrientSaturatedFats.
  ///
  /// In en, this message translates to:
  /// **'Saturated fats'**
  String get nutrientSaturatedFats;

  /// No description provided for @nutrientCholesterol.
  ///
  /// In en, this message translates to:
  /// **'Cholesterol'**
  String get nutrientCholesterol;

  /// No description provided for @nutrientSodium.
  ///
  /// In en, this message translates to:
  /// **'Sodium'**
  String get nutrientSodium;

  /// No description provided for @nutrientPotassium.
  ///
  /// In en, this message translates to:
  /// **'Potassium'**
  String get nutrientPotassium;

  /// No description provided for @nutrientVitaminA.
  ///
  /// In en, this message translates to:
  /// **'Vitamin A (Retinol)'**
  String get nutrientVitaminA;

  /// No description provided for @nutrientVitaminB1.
  ///
  /// In en, this message translates to:
  /// **'Vitamin B1 (Thiamin)'**
  String get nutrientVitaminB1;

  /// No description provided for @nutrientVitaminB2.
  ///
  /// In en, this message translates to:
  /// **'Vitamin B2 (Riboflavin)'**
  String get nutrientVitaminB2;

  /// No description provided for @nutrientVitaminB3.
  ///
  /// In en, this message translates to:
  /// **'Vitamin B3 (Niacin)'**
  String get nutrientVitaminB3;

  /// No description provided for @nutrientVitaminB4.
  ///
  /// In en, this message translates to:
  /// **'Vitamin B4 (Choline)'**
  String get nutrientVitaminB4;

  /// No description provided for @nutrientVitaminB5.
  ///
  /// In en, this message translates to:
  /// **'Vitamin B5 (Pantothenic acid)'**
  String get nutrientVitaminB5;

  /// No description provided for @nutrientVitaminB6.
  ///
  /// In en, this message translates to:
  /// **'Vitamin B6 (Pyridoxine)'**
  String get nutrientVitaminB6;

  /// No description provided for @nutrientVitaminB7.
  ///
  /// In en, this message translates to:
  /// **'Vitamin B7 (Biotin)'**
  String get nutrientVitaminB7;

  /// No description provided for @nutrientVitaminB9.
  ///
  /// In en, this message translates to:
  /// **'Vitamin B9 (Folate)'**
  String get nutrientVitaminB9;

  /// No description provided for @nutrientVitaminB12.
  ///
  /// In en, this message translates to:
  /// **'Vitamin B12 (Cobalamin)'**
  String get nutrientVitaminB12;

  /// No description provided for @nutrientVitaminC.
  ///
  /// In en, this message translates to:
  /// **'Vitamin C (Ascorbic acid)'**
  String get nutrientVitaminC;

  /// No description provided for @nutrientVitaminD2.
  ///
  /// In en, this message translates to:
  /// **'Vitamin D2 (Ergocalciferol)'**
  String get nutrientVitaminD2;

  /// No description provided for @nutrientVitaminD3.
  ///
  /// In en, this message translates to:
  /// **'Vitamin D3 (Cholecalciferol)'**
  String get nutrientVitaminD3;

  /// No description provided for @nutrientVitaminE.
  ///
  /// In en, this message translates to:
  /// **'Vitamin E (Alpha-tocopherol)'**
  String get nutrientVitaminE;

  /// No description provided for @nutrientVitaminK1.
  ///
  /// In en, this message translates to:
  /// **'Vitamin K1 (Phylloquinone)'**
  String get nutrientVitaminK1;

  /// No description provided for @nutrientVitaminK2.
  ///
  /// In en, this message translates to:
  /// **'Vitamin K2 (Menaquinone)'**
  String get nutrientVitaminK2;

  /// No description provided for @nutrientCalcium.
  ///
  /// In en, this message translates to:
  /// **'Calcium'**
  String get nutrientCalcium;

  /// No description provided for @nutrientIron.
  ///
  /// In en, this message translates to:
  /// **'Iron'**
  String get nutrientIron;

  /// No description provided for @nutrientMagnesium.
  ///
  /// In en, this message translates to:
  /// **'Magnesium'**
  String get nutrientMagnesium;

  /// No description provided for @nutrientZinc.
  ///
  /// In en, this message translates to:
  /// **'Zinc'**
  String get nutrientZinc;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
