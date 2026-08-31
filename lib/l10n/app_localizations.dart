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

  /// No description provided for @actionSave.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get actionSave;

  /// No description provided for @actionCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get actionCancel;

  /// No description provided for @actionDelete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get actionDelete;

  /// No description provided for @actionContinue.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get actionContinue;

  /// No description provided for @actionTryAgain.
  ///
  /// In en, this message translates to:
  /// **'Try again'**
  String get actionTryAgain;

  /// No description provided for @actionRestore.
  ///
  /// In en, this message translates to:
  /// **'Restore'**
  String get actionRestore;

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

  /// No description provided for @onboardingGoalQuestion.
  ///
  /// In en, this message translates to:
  /// **'What is your main goal?'**
  String get onboardingGoalQuestion;

  /// No description provided for @onboardingGoalOptionLoseWeight.
  ///
  /// In en, this message translates to:
  /// **'Lose Weight'**
  String get onboardingGoalOptionLoseWeight;

  /// No description provided for @onboardingGoalOptionBuildMuscle.
  ///
  /// In en, this message translates to:
  /// **'Build Muscle'**
  String get onboardingGoalOptionBuildMuscle;

  /// No description provided for @onboardingGoalOptionImproveHealth.
  ///
  /// In en, this message translates to:
  /// **'Improve Health'**
  String get onboardingGoalOptionImproveHealth;

  /// No description provided for @onboardingGoalOptionImprovePerformance.
  ///
  /// In en, this message translates to:
  /// **'Improve Performance'**
  String get onboardingGoalOptionImprovePerformance;

  /// No description provided for @onboardingNutrientsQuestion.
  ///
  /// In en, this message translates to:
  /// **'What else are you tracking besides calories?'**
  String get onboardingNutrientsQuestion;

  /// No description provided for @onboardingNutrientsOptionMacrosTitle.
  ///
  /// In en, this message translates to:
  /// **'Macros'**
  String get onboardingNutrientsOptionMacrosTitle;

  /// No description provided for @onboardingNutrientsOptionMacrosFooter.
  ///
  /// In en, this message translates to:
  /// **'Protein · Carbs · Fats'**
  String get onboardingNutrientsOptionMacrosFooter;

  /// No description provided for @onboardingNutrientsOptionRiskFactorsTitle.
  ///
  /// In en, this message translates to:
  /// **'Risk Factors'**
  String get onboardingNutrientsOptionRiskFactorsTitle;

  /// No description provided for @onboardingNutrientsOptionRiskFactorsFooter.
  ///
  /// In en, this message translates to:
  /// **'Sat. Fats · Cholesterol'**
  String get onboardingNutrientsOptionRiskFactorsFooter;

  /// No description provided for @onboardingNutrientsOptionElectrolytesTitle.
  ///
  /// In en, this message translates to:
  /// **'Electrolytes'**
  String get onboardingNutrientsOptionElectrolytesTitle;

  /// No description provided for @onboardingNutrientsOptionElectrolytesFooter.
  ///
  /// In en, this message translates to:
  /// **'Sodium · Potassium'**
  String get onboardingNutrientsOptionElectrolytesFooter;

  /// No description provided for @onboardingNutrientsOptionVitaminsTitle.
  ///
  /// In en, this message translates to:
  /// **'Vitamins'**
  String get onboardingNutrientsOptionVitaminsTitle;

  /// No description provided for @onboardingNutrientsOptionVitaminsFooter.
  ///
  /// In en, this message translates to:
  /// **'A · B-Complex · C · D · E · K'**
  String get onboardingNutrientsOptionVitaminsFooter;

  /// No description provided for @onboardingNutrientsOptionMineralsTitle.
  ///
  /// In en, this message translates to:
  /// **'Minerals'**
  String get onboardingNutrientsOptionMineralsTitle;

  /// No description provided for @onboardingNutrientsOptionMineralsFooter.
  ///
  /// In en, this message translates to:
  /// **'Iron · Calcium · Magnesium · Zinc'**
  String get onboardingNutrientsOptionMineralsFooter;

  /// No description provided for @onboardingStreakQuestion.
  ///
  /// In en, this message translates to:
  /// **'Do you like having a streak?'**
  String get onboardingStreakQuestion;

  /// No description provided for @onboardingStreakOptionShowTitle.
  ///
  /// In en, this message translates to:
  /// **'Yes! I love streaks!'**
  String get onboardingStreakOptionShowTitle;

  /// No description provided for @onboardingStreakOptionShowFooter.
  ///
  /// In en, this message translates to:
  /// **'Keep me accountable daily'**
  String get onboardingStreakOptionShowFooter;

  /// No description provided for @onboardingStreakOptionHideTitle.
  ///
  /// In en, this message translates to:
  /// **'No, I find them annoying.'**
  String get onboardingStreakOptionHideTitle;

  /// No description provided for @onboardingStreakOptionHideFooter.
  ///
  /// In en, this message translates to:
  /// **'Just track my progress'**
  String get onboardingStreakOptionHideFooter;

  /// No description provided for @noConnectionDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'No internet access'**
  String get noConnectionDialogTitle;

  /// No description provided for @noConnectionDialogMessage.
  ///
  /// In en, this message translates to:
  /// **'Please connect to the internet in order to accept our Terms and Conditions, and with our Privacy Policy.'**
  String get noConnectionDialogMessage;

  /// No description provided for @googleConnectionDialogAccountNotFoundTitle.
  ///
  /// In en, this message translates to:
  /// **'Account not found'**
  String get googleConnectionDialogAccountNotFoundTitle;

  /// No description provided for @googleConnectionDialogAccountNotFoundMessage.
  ///
  /// In en, this message translates to:
  /// **'We could not find a Live Vitalist account connected to this Google account. Please complete the onboarding first.'**
  String get googleConnectionDialogAccountNotFoundMessage;

  /// No description provided for @googleConnectionDialogConnectionFailedTitle.
  ///
  /// In en, this message translates to:
  /// **'Google connection failed'**
  String get googleConnectionDialogConnectionFailedTitle;

  /// No description provided for @googleConnectionDialogConnectionFailedMessage.
  ///
  /// In en, this message translates to:
  /// **'We could not connect with Google. Please check your internet connection and try again.'**
  String get googleConnectionDialogConnectionFailedMessage;

  /// No description provided for @welcomeScreenTitle.
  ///
  /// In en, this message translates to:
  /// **'Welcome to Live Vitalist'**
  String get welcomeScreenTitle;

  /// No description provided for @welcomeScreenSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Let\'s set up your profile so we can tailor your nutrition and fitness journey to you.'**
  String get welcomeScreenSubtitle;

  /// No description provided for @welcomeScreenExistingAccount.
  ///
  /// In en, this message translates to:
  /// **'Have an account? {googleLink} instead.'**
  String welcomeScreenExistingAccount(String googleLink);

  /// No description provided for @welcomeScreenGoogleLink.
  ///
  /// In en, this message translates to:
  /// **'Connect with Google'**
  String get welcomeScreenGoogleLink;

  /// No description provided for @termsScreenTitle.
  ///
  /// In en, this message translates to:
  /// **'You\'re all set'**
  String get termsScreenTitle;

  /// No description provided for @termsScreenAgreement.
  ///
  /// In en, this message translates to:
  /// **'If you continue, you agree with our {termsLink} and {privacyLink}.'**
  String termsScreenAgreement(String termsLink, String privacyLink);

  /// No description provided for @termsScreenTermsLink.
  ///
  /// In en, this message translates to:
  /// **'Terms and Conditions'**
  String get termsScreenTermsLink;

  /// No description provided for @termsScreenPrivacyLink.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get termsScreenPrivacyLink;

  /// No description provided for @legalDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'Please Accept Our Terms'**
  String get legalDialogTitle;

  /// No description provided for @legalPrerequisites.
  ///
  /// In en, this message translates to:
  /// **'Before using Live Vitalist, please review and accept our {privacyLink} and {termsLink}.'**
  String legalPrerequisites(String privacyLink, String termsLink);

  /// No description provided for @legalPrivacyPolicy.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get legalPrivacyPolicy;

  /// No description provided for @legalTermsOfUse.
  ///
  /// In en, this message translates to:
  /// **'Terms of Use'**
  String get legalTermsOfUse;

  /// No description provided for @legalSettingsHint.
  ///
  /// In en, this message translates to:
  /// **'You can review the Privacy Policy and Terms of Use at any time from the app\'s Settings, accessible via the ⋮ menu in the top-right corner.'**
  String get legalSettingsHint;

  /// No description provided for @appRoutingErrorMessage.
  ///
  /// In en, this message translates to:
  /// **'The requested page could not be opened.'**
  String get appRoutingErrorMessage;

  /// No description provided for @appInitializationErrorMessage.
  ///
  /// In en, this message translates to:
  /// **'The application could not be initialized.'**
  String get appInitializationErrorMessage;

  /// No description provided for @calendarTitle.
  ///
  /// In en, this message translates to:
  /// **'Calendar'**
  String get calendarTitle;

  /// No description provided for @calendarMaximum.
  ///
  /// In en, this message translates to:
  /// **'Maximum'**
  String get calendarMaximum;

  /// No description provided for @calendarLeadingNutrient.
  ///
  /// In en, this message translates to:
  /// **'Leading nutrient'**
  String get calendarLeadingNutrient;

  /// No description provided for @calendarMinimum.
  ///
  /// In en, this message translates to:
  /// **'Minimum'**
  String get calendarMinimum;

  /// No description provided for @alimentJsonEditorTitle.
  ///
  /// In en, this message translates to:
  /// **'Aliment Json Editor'**
  String get alimentJsonEditorTitle;

  /// No description provided for @alimentEditorTitle.
  ///
  /// In en, this message translates to:
  /// **'Aliment Editor'**
  String get alimentEditorTitle;

  /// No description provided for @alimentEditorGenericTitle.
  ///
  /// In en, this message translates to:
  /// **'Editor'**
  String get alimentEditorGenericTitle;

  /// No description provided for @alimentEditorSaveChangesTitle.
  ///
  /// In en, this message translates to:
  /// **'Save changes?'**
  String get alimentEditorSaveChangesTitle;

  /// No description provided for @alimentEditorSaveChangesMessage.
  ///
  /// In en, this message translates to:
  /// **'Do you want to save this aliment?'**
  String get alimentEditorSaveChangesMessage;

  /// No description provided for @alimentEditorAddAliment.
  ///
  /// In en, this message translates to:
  /// **'Add Aliment'**
  String get alimentEditorAddAliment;

  /// No description provided for @alimentEditorSearchAliment.
  ///
  /// In en, this message translates to:
  /// **'Search aliment'**
  String get alimentEditorSearchAliment;

  /// No description provided for @alimentEditorServedAmount.
  ///
  /// In en, this message translates to:
  /// **'Served amount:'**
  String get alimentEditorServedAmount;

  /// No description provided for @alimentEditorSelectorTitle.
  ///
  /// In en, this message translates to:
  /// **'Aliment Selector'**
  String get alimentEditorSelectorTitle;

  /// No description provided for @alimentEditorNewUnit.
  ///
  /// In en, this message translates to:
  /// **'New unit'**
  String get alimentEditorNewUnit;

  /// No description provided for @alimentEditorUnitName.
  ///
  /// In en, this message translates to:
  /// **'Unit name'**
  String get alimentEditorUnitName;

  /// No description provided for @alimentEditorAmount.
  ///
  /// In en, this message translates to:
  /// **'Amount'**
  String get alimentEditorAmount;

  /// No description provided for @alimentEditorAddSynonym.
  ///
  /// In en, this message translates to:
  /// **'Add synonym'**
  String get alimentEditorAddSynonym;

  /// No description provided for @alimentEditorDeleteSynonym.
  ///
  /// In en, this message translates to:
  /// **'Delete synonym'**
  String get alimentEditorDeleteSynonym;

  /// No description provided for @alimentEditorEnterLabel.
  ///
  /// In en, this message translates to:
  /// **'Enter {label}'**
  String alimentEditorEnterLabel(String label);

  /// No description provided for @mealsJournalDeleteMealTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete meal?'**
  String get mealsJournalDeleteMealTitle;

  /// No description provided for @mealsJournalDeleteMealMessage.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this meal?'**
  String get mealsJournalDeleteMealMessage;

  /// No description provided for @mealsJournalTitle.
  ///
  /// In en, this message translates to:
  /// **'Meals Journal'**
  String get mealsJournalTitle;

  /// No description provided for @mealsJournalBreakfast.
  ///
  /// In en, this message translates to:
  /// **'Breakfast'**
  String get mealsJournalBreakfast;

  /// No description provided for @mealsJournalLunch.
  ///
  /// In en, this message translates to:
  /// **'Lunch'**
  String get mealsJournalLunch;

  /// No description provided for @mealsJournalDinner.
  ///
  /// In en, this message translates to:
  /// **'Dinner'**
  String get mealsJournalDinner;

  /// No description provided for @mealsJournalAddMeal.
  ///
  /// In en, this message translates to:
  /// **'Add Meal'**
  String get mealsJournalAddMeal;

  /// No description provided for @mealsJournalAddAliment.
  ///
  /// In en, this message translates to:
  /// **'Add aliment'**
  String get mealsJournalAddAliment;

  /// No description provided for @mealsJournalAddTemporaryAliment.
  ///
  /// In en, this message translates to:
  /// **'Add temporary aliment'**
  String get mealsJournalAddTemporaryAliment;

  /// No description provided for @mealsJournalShowNotification.
  ///
  /// In en, this message translates to:
  /// **'Show Notification'**
  String get mealsJournalShowNotification;

  /// No description provided for @mealsJournalAliments.
  ///
  /// In en, this message translates to:
  /// **'Aliments'**
  String get mealsJournalAliments;

  /// No description provided for @mealsJournalCalories.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 calorie} other{{count} calories}}'**
  String mealsJournalCalories(int count);

  /// No description provided for @mealsJournalNotificationTitle.
  ///
  /// In en, this message translates to:
  /// **'{mealName}: {count, plural, =1{1 aliment} other{{count} aliments}}'**
  String mealsJournalNotificationTitle(String mealName, int count);

  /// No description provided for @mealsJournalNotificationChannel.
  ///
  /// In en, this message translates to:
  /// **'Meal Summary'**
  String get mealsJournalNotificationChannel;

  /// No description provided for @mealsJournalNotificationChannelDescription.
  ///
  /// In en, this message translates to:
  /// **'Text-based notification with a list of aliments'**
  String get mealsJournalNotificationChannelDescription;

  /// No description provided for @mealsJournalNotificationSummary.
  ///
  /// In en, this message translates to:
  /// **'Meal summary'**
  String get mealsJournalNotificationSummary;

  /// No description provided for @mealsJournalNotificationBody.
  ///
  /// In en, this message translates to:
  /// **'Expand to view aliments'**
  String get mealsJournalNotificationBody;

  /// No description provided for @superSearchSearchAliments.
  ///
  /// In en, this message translates to:
  /// **'Search aliments'**
  String get superSearchSearchAliments;

  /// No description provided for @superSearchAliments.
  ///
  /// In en, this message translates to:
  /// **'Aliments'**
  String get superSearchAliments;

  /// No description provided for @superSearchNoAlimentsFound.
  ///
  /// In en, this message translates to:
  /// **'No aliments found'**
  String get superSearchNoAlimentsFound;

  /// No description provided for @superSearchTryAnotherName.
  ///
  /// In en, this message translates to:
  /// **'Try another name or check the spelling.'**
  String get superSearchTryAnotherName;

  /// No description provided for @superSearchAddToMeal.
  ///
  /// In en, this message translates to:
  /// **'Add to meal'**
  String get superSearchAddToMeal;

  /// No description provided for @superSearchWriteAlimentFirst.
  ///
  /// In en, this message translates to:
  /// **'Write the aliment in the search bar first.'**
  String get superSearchWriteAlimentFirst;

  /// No description provided for @superSearchAddAliments.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{Add aliment} other{Add {count} aliments}}'**
  String superSearchAddAliments(int count);

  /// No description provided for @superSearchResultCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{No results} =1{1 result} other{{count} results}}'**
  String superSearchResultCount(int count);

  /// No description provided for @nutrientDisplayTitle.
  ///
  /// In en, this message translates to:
  /// **'Nutrients'**
  String get nutrientDisplayTitle;

  /// No description provided for @nutrientDisplayAddNewNutrient.
  ///
  /// In en, this message translates to:
  /// **'Add new nutrient'**
  String get nutrientDisplayAddNewNutrient;

  /// No description provided for @nutrientDisplayAmount.
  ///
  /// In en, this message translates to:
  /// **'Amount:'**
  String get nutrientDisplayAmount;

  /// No description provided for @nutrientDisplayLowerLimit.
  ///
  /// In en, this message translates to:
  /// **'Lower Limit:'**
  String get nutrientDisplayLowerLimit;

  /// No description provided for @nutrientDisplayUpperLimit.
  ///
  /// In en, this message translates to:
  /// **'Upper Limit:'**
  String get nutrientDisplayUpperLimit;

  /// No description provided for @nutrientDisplayTopSources.
  ///
  /// In en, this message translates to:
  /// **'Top Sources'**
  String get nutrientDisplayTopSources;

  /// No description provided for @nutrientDisplayIntake.
  ///
  /// In en, this message translates to:
  /// **'{nutrient} intake'**
  String nutrientDisplayIntake(String nutrient);

  /// No description provided for @nutrientDisplayAmountValue.
  ///
  /// In en, this message translates to:
  /// **'Amount: {amount}'**
  String nutrientDisplayAmountValue(String amount);

  /// No description provided for @nutrientDisplayLowerLimitValue.
  ///
  /// In en, this message translates to:
  /// **'Lower Limit: {value}'**
  String nutrientDisplayLowerLimitValue(String value);

  /// No description provided for @nutrientDisplayUpperLimitValue.
  ///
  /// In en, this message translates to:
  /// **'Upper Limit: {value}'**
  String nutrientDisplayUpperLimitValue(String value);

  /// No description provided for @ratioBarsTitle.
  ///
  /// In en, this message translates to:
  /// **'Distribution Bars'**
  String get ratioBarsTitle;

  /// No description provided for @reportsNoData.
  ///
  /// In en, this message translates to:
  /// **'No data'**
  String get reportsNoData;

  /// No description provided for @reportsPreviousWeek.
  ///
  /// In en, this message translates to:
  /// **'Previous Week'**
  String get reportsPreviousWeek;

  /// No description provided for @reportsCurrentWeek.
  ///
  /// In en, this message translates to:
  /// **'Current Week'**
  String get reportsCurrentWeek;

  /// No description provided for @reportsConsistency.
  ///
  /// In en, this message translates to:
  /// **'Consistency'**
  String get reportsConsistency;

  /// No description provided for @reportsAverageDailyCalories.
  ///
  /// In en, this message translates to:
  /// **'Average daily calories'**
  String get reportsAverageDailyCalories;

  /// No description provided for @reportsWeekReportTitle.
  ///
  /// In en, this message translates to:
  /// **'Week {number} Report'**
  String reportsWeekReportTitle(int number);

  /// No description provided for @reportsWeekRange.
  ///
  /// In en, this message translates to:
  /// **'{start} – {end}'**
  String reportsWeekRange(String start, String end);

  /// No description provided for @reportsDaysOnTarget.
  ///
  /// In en, this message translates to:
  /// **'{count} / {total, plural, =1{1 day} other{{total} days}} on target'**
  String reportsDaysOnTarget(int count, int total);

  /// No description provided for @reportsMondayShort.
  ///
  /// In en, this message translates to:
  /// **'M'**
  String get reportsMondayShort;

  /// No description provided for @reportsTuesdayShort.
  ///
  /// In en, this message translates to:
  /// **'T'**
  String get reportsTuesdayShort;

  /// No description provided for @reportsWednesdayShort.
  ///
  /// In en, this message translates to:
  /// **'W'**
  String get reportsWednesdayShort;

  /// No description provided for @reportsThursdayShort.
  ///
  /// In en, this message translates to:
  /// **'T'**
  String get reportsThursdayShort;

  /// No description provided for @reportsFridayShort.
  ///
  /// In en, this message translates to:
  /// **'F'**
  String get reportsFridayShort;

  /// No description provided for @reportsSaturdayShort.
  ///
  /// In en, this message translates to:
  /// **'S'**
  String get reportsSaturdayShort;

  /// No description provided for @reportsSundayShort.
  ///
  /// In en, this message translates to:
  /// **'S'**
  String get reportsSundayShort;

  /// No description provided for @settingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTitle;

  /// No description provided for @settingsDocuments.
  ///
  /// In en, this message translates to:
  /// **'Documents'**
  String get settingsDocuments;

  /// No description provided for @settingsPrivacyPolicy.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get settingsPrivacyPolicy;

  /// No description provided for @settingsTermsOfUse.
  ///
  /// In en, this message translates to:
  /// **'Terms of Use'**
  String get settingsTermsOfUse;

  /// No description provided for @settingsSendFeedback.
  ///
  /// In en, this message translates to:
  /// **'Send Feedback'**
  String get settingsSendFeedback;

  /// No description provided for @settingsDataDeletion.
  ///
  /// In en, this message translates to:
  /// **'Data Deletion'**
  String get settingsDataDeletion;

  /// No description provided for @settingsConnectWithGoogle.
  ///
  /// In en, this message translates to:
  /// **'Connect with Google'**
  String get settingsConnectWithGoogle;

  /// No description provided for @settingsGoogleBackupMessage.
  ///
  /// In en, this message translates to:
  /// **'Backup your files to cloud or restore your data by connecting with Google.'**
  String get settingsGoogleBackupMessage;

  /// No description provided for @settingsUseMonthDayFormat.
  ///
  /// In en, this message translates to:
  /// **'Use M/D format'**
  String get settingsUseMonthDayFormat;

  /// No description provided for @settingsUseComplexCalendar.
  ///
  /// In en, this message translates to:
  /// **'Use complex calendar view'**
  String get settingsUseComplexCalendar;

  /// No description provided for @settingsShowMacroDistribution.
  ///
  /// In en, this message translates to:
  /// **'Show macro distribution'**
  String get settingsShowMacroDistribution;

  /// No description provided for @settingsShowOmegaBalance.
  ///
  /// In en, this message translates to:
  /// **'Show Omega-3 to Omega-6 balance'**
  String get settingsShowOmegaBalance;

  /// No description provided for @settingsAccountDeletion.
  ///
  /// In en, this message translates to:
  /// **'Account Deletion'**
  String get settingsAccountDeletion;

  /// No description provided for @settingsAccountAndDataDeletion.
  ///
  /// In en, this message translates to:
  /// **'Account and data deletion'**
  String get settingsAccountAndDataDeletion;

  /// No description provided for @settingsPermanentlyDeleteOnlineData.
  ///
  /// In en, this message translates to:
  /// **'Permanently delete online data'**
  String get settingsPermanentlyDeleteOnlineData;

  /// No description provided for @settingsPermanentlyDeleteAllData.
  ///
  /// In en, this message translates to:
  /// **'Permanently delete all data'**
  String get settingsPermanentlyDeleteAllData;

  /// No description provided for @settingsReauthenticateMessage.
  ///
  /// In en, this message translates to:
  /// **'You must authenticate first before we can delete your account associated with Google.'**
  String get settingsReauthenticateMessage;

  /// No description provided for @settingsReauthenticateAndDelete.
  ///
  /// In en, this message translates to:
  /// **'Re-authenticate and delete'**
  String get settingsReauthenticateAndDelete;

  /// No description provided for @settingsDeleteAllDescription.
  ///
  /// In en, this message translates to:
  /// **'You can delete your account and all data stored both online and on your device by using the button below. This will permanently remove everything linked to your account and reset the app.'**
  String get settingsDeleteAllDescription;

  /// No description provided for @settingsDeleteAllConfirmation.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete your account and all associated data? This will erase your online data and local storage. This action is permanent and cannot be undone.'**
  String get settingsDeleteAllConfirmation;

  /// No description provided for @settingsDeleteOnlineDescription.
  ///
  /// In en, this message translates to:
  /// **'You can delete your account and all data stored online by using the button below. Your data will be permanently removed from our servers, but app settings and local storage will remain on your device.'**
  String get settingsDeleteOnlineDescription;

  /// No description provided for @settingsDeleteOnlineConfirmation.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete your account and all data stored online? This action is permanent and cannot be undone.'**
  String get settingsDeleteOnlineConfirmation;

  /// No description provided for @settingsDeletionFailed.
  ///
  /// In en, this message translates to:
  /// **'Deletion failed, nothing was removed.'**
  String get settingsDeletionFailed;

  /// No description provided for @legalClosingApp.
  ///
  /// In en, this message translates to:
  /// **'Closing the app...'**
  String get legalClosingApp;

  /// No description provided for @legalExitApp.
  ///
  /// In en, this message translates to:
  /// **'Exit App'**
  String get legalExitApp;

  /// No description provided for @legalAgree.
  ///
  /// In en, this message translates to:
  /// **'I Agree'**
  String get legalAgree;
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
