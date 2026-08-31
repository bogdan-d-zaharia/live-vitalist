// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get actionSave => 'Save';

  @override
  String get actionCancel => 'Cancel';

  @override
  String get actionDelete => 'Delete';

  @override
  String get actionContinue => 'Continue';

  @override
  String get actionTryAgain => 'Try again';

  @override
  String get actionRestore => 'Restore';

  @override
  String get nutrientKcals => 'Calories';

  @override
  String get nutrientProtein => 'Protein';

  @override
  String get nutrientCarbs => 'Carbohydrates';

  @override
  String get nutrientSugars => 'Sugars';

  @override
  String get nutrientFibers => 'Fibers';

  @override
  String get nutrientFats => 'Fats';

  @override
  String get nutrientOmega3 => 'Omega-3';

  @override
  String get nutrientOmega6 => 'Omega-6';

  @override
  String get nutrientSaturatedFats => 'Saturated fats';

  @override
  String get nutrientCholesterol => 'Cholesterol';

  @override
  String get nutrientSodium => 'Sodium';

  @override
  String get nutrientPotassium => 'Potassium';

  @override
  String get nutrientVitaminA => 'Vitamin A (Retinol)';

  @override
  String get nutrientVitaminB1 => 'Vitamin B1 (Thiamin)';

  @override
  String get nutrientVitaminB2 => 'Vitamin B2 (Riboflavin)';

  @override
  String get nutrientVitaminB3 => 'Vitamin B3 (Niacin)';

  @override
  String get nutrientVitaminB4 => 'Vitamin B4 (Choline)';

  @override
  String get nutrientVitaminB5 => 'Vitamin B5 (Pantothenic acid)';

  @override
  String get nutrientVitaminB6 => 'Vitamin B6 (Pyridoxine)';

  @override
  String get nutrientVitaminB7 => 'Vitamin B7 (Biotin)';

  @override
  String get nutrientVitaminB9 => 'Vitamin B9 (Folate)';

  @override
  String get nutrientVitaminB12 => 'Vitamin B12 (Cobalamin)';

  @override
  String get nutrientVitaminC => 'Vitamin C (Ascorbic acid)';

  @override
  String get nutrientVitaminD2 => 'Vitamin D2 (Ergocalciferol)';

  @override
  String get nutrientVitaminD3 => 'Vitamin D3 (Cholecalciferol)';

  @override
  String get nutrientVitaminE => 'Vitamin E (Alpha-tocopherol)';

  @override
  String get nutrientVitaminK1 => 'Vitamin K1 (Phylloquinone)';

  @override
  String get nutrientVitaminK2 => 'Vitamin K2 (Menaquinone)';

  @override
  String get nutrientCalcium => 'Calcium';

  @override
  String get nutrientIron => 'Iron';

  @override
  String get nutrientMagnesium => 'Magnesium';

  @override
  String get nutrientZinc => 'Zinc';

  @override
  String get onboardingGoalQuestion => 'What is your main goal?';

  @override
  String get onboardingGoalOptionLoseWeight => 'Lose Weight';

  @override
  String get onboardingGoalOptionBuildMuscle => 'Build Muscle';

  @override
  String get onboardingGoalOptionImproveHealth => 'Improve Health';

  @override
  String get onboardingGoalOptionImprovePerformance => 'Improve Performance';

  @override
  String get onboardingNutrientsQuestion =>
      'What else are you tracking besides calories?';

  @override
  String get onboardingNutrientsOptionMacrosTitle => 'Macros';

  @override
  String get onboardingNutrientsOptionMacrosFooter => 'Protein · Carbs · Fats';

  @override
  String get onboardingNutrientsOptionRiskFactorsTitle => 'Risk Factors';

  @override
  String get onboardingNutrientsOptionRiskFactorsFooter =>
      'Sat. Fats · Cholesterol';

  @override
  String get onboardingNutrientsOptionElectrolytesTitle => 'Electrolytes';

  @override
  String get onboardingNutrientsOptionElectrolytesFooter =>
      'Sodium · Potassium';

  @override
  String get onboardingNutrientsOptionVitaminsTitle => 'Vitamins';

  @override
  String get onboardingNutrientsOptionVitaminsFooter =>
      'A · B-Complex · C · D · E · K';

  @override
  String get onboardingNutrientsOptionMineralsTitle => 'Minerals';

  @override
  String get onboardingNutrientsOptionMineralsFooter =>
      'Iron · Calcium · Magnesium · Zinc';

  @override
  String get onboardingStreakQuestion => 'Do you like having a streak?';

  @override
  String get onboardingStreakOptionShowTitle => 'Yes! I love streaks!';

  @override
  String get onboardingStreakOptionShowFooter => 'Keep me accountable daily';

  @override
  String get onboardingStreakOptionHideTitle => 'No, I find them annoying.';

  @override
  String get onboardingStreakOptionHideFooter => 'Just track my progress';

  @override
  String get noConnectionDialogTitle => 'No internet access';

  @override
  String get noConnectionDialogMessage =>
      'Please connect to the internet in order to accept our Terms and Conditions, and with our Privacy Policy.';

  @override
  String get googleConnectionDialogAccountNotFoundTitle => 'Account not found';

  @override
  String get googleConnectionDialogAccountNotFoundMessage =>
      'We could not find a Live Vitalist account connected to this Google account. Please complete the onboarding first.';

  @override
  String get googleConnectionDialogConnectionFailedTitle =>
      'Google connection failed';

  @override
  String get googleConnectionDialogConnectionFailedMessage =>
      'We could not connect with Google. Please check your internet connection and try again.';

  @override
  String get welcomeScreenTitle => 'Welcome to Live Vitalist';

  @override
  String get welcomeScreenSubtitle =>
      'Let\'s set up your profile so we can tailor your nutrition and fitness journey to you.';

  @override
  String welcomeScreenExistingAccount(String googleLink) {
    return 'Have an account? $googleLink instead.';
  }

  @override
  String get welcomeScreenGoogleLink => 'Connect with Google';

  @override
  String get termsScreenTitle => 'You\'re all set';

  @override
  String termsScreenAgreement(String termsLink, String privacyLink) {
    return 'If you continue, you agree with our $termsLink and $privacyLink.';
  }

  @override
  String get termsScreenTermsLink => 'Terms and Conditions';

  @override
  String get termsScreenPrivacyLink => 'Privacy Policy';

  @override
  String get legalDialogTitle => 'Please Accept Our Terms';

  @override
  String legalPrerequisites(String privacyLink, String termsLink) {
    return 'Before using Live Vitalist, please review and accept our $privacyLink and $termsLink.';
  }

  @override
  String get legalPrivacyPolicy => 'Privacy Policy';

  @override
  String get legalTermsOfUse => 'Terms of Use';

  @override
  String get legalSettingsHint =>
      'You can review the Privacy Policy and Terms of Use at any time from the app\'s Settings, accessible via the ⋮ menu in the top-right corner.';

  @override
  String get appRoutingErrorMessage =>
      'The requested page could not be opened.';

  @override
  String get appInitializationErrorMessage =>
      'The application could not be initialized.';

  @override
  String get calendarTitle => 'Calendar';

  @override
  String get calendarMaximum => 'Maximum';

  @override
  String get calendarLeadingNutrient => 'Leading nutrient';

  @override
  String get calendarMinimum => 'Minimum';

  @override
  String get alimentJsonEditorTitle => 'Aliment Json Editor';

  @override
  String get alimentEditorTitle => 'Aliment Editor';

  @override
  String get alimentEditorGenericTitle => 'Editor';

  @override
  String get alimentEditorSaveChangesTitle => 'Save changes?';

  @override
  String get alimentEditorSaveChangesMessage =>
      'Do you want to save this aliment?';

  @override
  String get alimentEditorAddAliment => 'Add Aliment';

  @override
  String get alimentEditorSearchAliment => 'Search aliment';

  @override
  String get alimentEditorServedAmount => 'Served amount:';

  @override
  String get alimentEditorSelectorTitle => 'Aliment Selector';

  @override
  String get alimentEditorNewUnit => 'New unit';

  @override
  String get alimentEditorUnitName => 'Unit name';

  @override
  String get alimentEditorAmount => 'Amount';

  @override
  String get alimentEditorAddSynonym => 'Add synonym';

  @override
  String get alimentEditorDeleteSynonym => 'Delete synonym';

  @override
  String alimentEditorEnterLabel(String label) {
    return 'Enter $label';
  }

  @override
  String get mealsJournalDeleteMealTitle => 'Delete meal?';

  @override
  String get mealsJournalDeleteMealMessage =>
      'Are you sure you want to delete this meal?';

  @override
  String get mealsJournalTitle => 'Meals Journal';

  @override
  String get mealsJournalAddMeal => 'Add Meal';

  @override
  String get mealsJournalAddAliment => 'Add aliment';

  @override
  String get mealsJournalAddTemporaryAliment => 'Add temporary aliment';

  @override
  String get mealsJournalShowNotification => 'Show Notification';

  @override
  String get mealsJournalAliments => 'Aliments';

  @override
  String mealsJournalCalories(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count calories',
      one: '1 calorie',
    );
    return '$_temp0';
  }

  @override
  String mealsJournalNotificationTitle(String mealName, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count aliments',
      one: '1 aliment',
    );
    return '$mealName: $_temp0';
  }

  @override
  String get mealsJournalNotificationChannel => 'Meal Summary';

  @override
  String get mealsJournalNotificationChannelDescription =>
      'Text-based notification with a list of aliments';

  @override
  String get mealsJournalNotificationSummary => 'Meal summary';

  @override
  String get mealsJournalNotificationBody => 'Expand to view aliments';

  @override
  String get superSearchSearchAliments => 'Search aliments';

  @override
  String get superSearchAliments => 'Aliments';

  @override
  String get superSearchNoAlimentsFound => 'No aliments found';

  @override
  String get superSearchTryAnotherName =>
      'Try another name or check the spelling.';

  @override
  String get superSearchAddToMeal => 'Add to meal';

  @override
  String get superSearchWriteAlimentFirst =>
      'Write the aliment in the search bar first.';

  @override
  String superSearchAddAliments(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Add $count aliments',
      one: 'Add aliment',
    );
    return '$_temp0';
  }

  @override
  String superSearchResultCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count results',
      one: '1 result',
      zero: 'No results',
    );
    return '$_temp0';
  }

  @override
  String get nutrientDisplayTitle => 'Nutrients';

  @override
  String get nutrientDisplayAddNewNutrient => 'Add new nutrient';

  @override
  String get nutrientDisplayAmount => 'Amount:';

  @override
  String get nutrientDisplayLowerLimit => 'Lower Limit:';

  @override
  String get nutrientDisplayUpperLimit => 'Upper Limit:';

  @override
  String get nutrientDisplayTopSources => 'Top Sources';

  @override
  String nutrientDisplayIntake(String nutrient) {
    return '$nutrient intake';
  }

  @override
  String nutrientDisplayAmountValue(String amount) {
    return 'Amount: $amount';
  }

  @override
  String nutrientDisplayLowerLimitValue(String value) {
    return 'Lower Limit: $value';
  }

  @override
  String nutrientDisplayUpperLimitValue(String value) {
    return 'Upper Limit: $value';
  }

  @override
  String get ratioBarsTitle => 'Distribution Bars';

  @override
  String get reportsNoData => 'No data';

  @override
  String get reportsPreviousWeek => 'Previous Week';

  @override
  String get reportsCurrentWeek => 'Current Week';

  @override
  String get reportsConsistency => 'Consistency';

  @override
  String get reportsAverageDailyCalories => 'Average daily calories';

  @override
  String reportsWeekReportTitle(int number) {
    return 'Week $number Report';
  }

  @override
  String reportsWeekRange(String start, String end) {
    return '$start – $end';
  }

  @override
  String reportsDaysOnTarget(int count, int total) {
    String _temp0 = intl.Intl.pluralLogic(
      total,
      locale: localeName,
      other: '$total days',
      one: '1 day',
    );
    return '$count / $_temp0 on target';
  }

  @override
  String get reportsMondayShort => 'M';

  @override
  String get reportsTuesdayShort => 'T';

  @override
  String get reportsWednesdayShort => 'W';

  @override
  String get reportsThursdayShort => 'T';

  @override
  String get reportsFridayShort => 'F';

  @override
  String get reportsSaturdayShort => 'S';

  @override
  String get reportsSundayShort => 'S';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get settingsDocuments => 'Documents';

  @override
  String get settingsPrivacyPolicy => 'Privacy Policy';

  @override
  String get settingsTermsOfUse => 'Terms of Use';

  @override
  String get settingsSendFeedback => 'Send Feedback';

  @override
  String get settingsDataDeletion => 'Data Deletion';

  @override
  String get settingsConnectWithGoogle => 'Connect with Google';

  @override
  String get settingsGoogleBackupMessage =>
      'Backup your files to cloud or restore your data by connecting with Google.';

  @override
  String get settingsUseMonthDayFormat => 'Use M/D format';

  @override
  String get settingsUseComplexCalendar => 'Use complex calendar view';

  @override
  String get settingsShowMacroDistribution => 'Show macro distribution';

  @override
  String get settingsShowOmegaBalance => 'Show Omega-3 to Omega-6 balance';

  @override
  String get settingsAccountDeletion => 'Account Deletion';

  @override
  String get settingsAccountAndDataDeletion => 'Account and data deletion';

  @override
  String get settingsPermanentlyDeleteOnlineData =>
      'Permanently delete online data';

  @override
  String get settingsPermanentlyDeleteAllData => 'Permanently delete all data';

  @override
  String get settingsReauthenticateMessage =>
      'You must authenticate first before we can delete your account associated with Google.';

  @override
  String get settingsReauthenticateAndDelete => 'Re-authenticate and delete';

  @override
  String get settingsDeleteAllDescription =>
      'You can delete your account and all data stored both online and on your device by using the button below. This will permanently remove everything linked to your account and reset the app.';

  @override
  String get settingsDeleteAllConfirmation =>
      'Are you sure you want to delete your account and all associated data? This will erase your online data and local storage. This action is permanent and cannot be undone.';

  @override
  String get settingsDeleteOnlineDescription =>
      'You can delete your account and all data stored online by using the button below. Your data will be permanently removed from our servers, but app settings and local storage will remain on your device.';

  @override
  String get settingsDeleteOnlineConfirmation =>
      'Are you sure you want to delete your account and all data stored online? This action is permanent and cannot be undone.';

  @override
  String get settingsDeletionFailed => 'Deletion failed, nothing was removed.';

  @override
  String get legalClosingApp => 'Closing the app...';

  @override
  String get legalExitApp => 'Exit App';

  @override
  String get legalAgree => 'I Agree';
}
