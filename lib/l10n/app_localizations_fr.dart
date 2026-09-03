// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get actionSave => 'Enregistrer';

  @override
  String get actionCancel => 'Annuler';

  @override
  String get actionDelete => 'Supprimer';

  @override
  String get actionContinue => 'Continuer';

  @override
  String get actionTryAgain => 'Réessayer';

  @override
  String get actionRestore => 'Restaurer';

  @override
  String get nutrientKcals => 'Calories';

  @override
  String get nutrientProtein => 'Protéines';

  @override
  String get nutrientCarbs => 'Glucides';

  @override
  String get nutrientSugars => 'Sucres';

  @override
  String get nutrientFibers => 'Fibres';

  @override
  String get nutrientFats => 'Lipides';

  @override
  String get nutrientOmega3 => 'Oméga-3';

  @override
  String get nutrientOmega6 => 'Oméga-6';

  @override
  String get nutrientSaturatedFats => 'Graisses saturées';

  @override
  String get nutrientCholesterol => 'Cholestérol';

  @override
  String get nutrientSodium => 'Sodium';

  @override
  String get nutrientPotassium => 'Potassium';

  @override
  String get nutrientVitaminA => 'Vitamine A (rétinol)';

  @override
  String get nutrientVitaminB1 => 'Vitamine B1 (thiamine)';

  @override
  String get nutrientVitaminB2 => 'Vitamine B2 (riboflavine)';

  @override
  String get nutrientVitaminB3 => 'Vitamine B3 (niacine)';

  @override
  String get nutrientVitaminB4 => 'Vitamine B4 (choline)';

  @override
  String get nutrientVitaminB5 => 'Vitamine B5 (acide pantothénique)';

  @override
  String get nutrientVitaminB6 => 'Vitamine B6 (pyridoxine)';

  @override
  String get nutrientVitaminB7 => 'Vitamine B7 (biotine)';

  @override
  String get nutrientVitaminB9 => 'Vitamine B9 (folate)';

  @override
  String get nutrientVitaminB12 => 'Vitamine B12 (cobalamine)';

  @override
  String get nutrientVitaminC => 'Vitamine C (acide ascorbique)';

  @override
  String get nutrientVitaminD2 => 'Vitamine D2 (ergocalciférol)';

  @override
  String get nutrientVitaminD3 => 'Vitamine D3 (cholécalciférol)';

  @override
  String get nutrientVitaminE => 'Vitamine E (alpha-tocophérol)';

  @override
  String get nutrientVitaminK1 => 'Vitamine K1 (phylloquinone)';

  @override
  String get nutrientVitaminK2 => 'Vitamine K2 (ménaquinone)';

  @override
  String get nutrientCalcium => 'Calcium';

  @override
  String get nutrientIron => 'Fer';

  @override
  String get nutrientMagnesium => 'Magnésium';

  @override
  String get nutrientZinc => 'Zinc';

  @override
  String get onboardingGoalQuestion => 'Quel est votre objectif principal ?';

  @override
  String get onboardingGoalOptionLoseWeight => 'Perdre du poids';

  @override
  String get onboardingGoalOptionBuildMuscle => 'Prendre du muscle';

  @override
  String get onboardingGoalOptionImproveHealth => 'Améliorer la santé';

  @override
  String get onboardingGoalOptionImprovePerformance =>
      'Améliorer les performances';

  @override
  String get onboardingNutrientsQuestion =>
      'Que suivez-vous d\'autre que les calories ?';

  @override
  String get onboardingNutrientsOptionMacrosTitle => 'Macronutriments';

  @override
  String get onboardingNutrientsOptionMacrosFooter =>
      'Protéines · Glucides · Lipides';

  @override
  String get onboardingNutrientsOptionRiskFactorsTitle => 'Facteurs de risque';

  @override
  String get onboardingNutrientsOptionRiskFactorsFooter =>
      'Graisses sat. · Cholestérol';

  @override
  String get onboardingNutrientsOptionElectrolytesTitle => 'Électrolytes';

  @override
  String get onboardingNutrientsOptionElectrolytesFooter =>
      'Sodium · Potassium';

  @override
  String get onboardingNutrientsOptionVitaminsTitle => 'Vitamines';

  @override
  String get onboardingNutrientsOptionVitaminsFooter =>
      'A · Complexe B · C · D · E · K';

  @override
  String get onboardingNutrientsOptionMineralsTitle => 'Minéraux';

  @override
  String get onboardingNutrientsOptionMineralsFooter =>
      'Fer · Calcium · Magnésium · Zinc';

  @override
  String get onboardingStreakQuestion =>
      'Aimez-vous suivre une série de jours consécutifs ?';

  @override
  String get onboardingStreakOptionShowTitle => 'Oui ! J’adore les séries !';

  @override
  String get onboardingStreakOptionShowFooter =>
      'Aidez-moi à garder le rythme chaque jour';

  @override
  String get onboardingStreakOptionHideTitle => 'Non, je trouve ça agaçant.';

  @override
  String get onboardingStreakOptionHideFooter =>
      'Suivez simplement mes progrès';

  @override
  String get noConnectionDialogTitle => 'Pas d\'accès à Internet';

  @override
  String get noConnectionDialogMessage =>
      'Veuillez vous connecter à Internet afin d\'accepter nos Conditions générales et notre Politique de confidentialité.';

  @override
  String get googleConnectionDialogAccountNotFoundTitle => 'Compte introuvable';

  @override
  String get googleConnectionDialogAccountNotFoundMessage =>
      'Nous n’avons trouvé aucun compte Live Vitalist associé à ce compte Google. Veuillez d’abord terminer la configuration initiale.';

  @override
  String get googleConnectionDialogConnectionFailedTitle =>
      'Échec de la connexion à Google';

  @override
  String get googleConnectionDialogConnectionFailedMessage =>
      'Nous n\'avons pas pu nous connecter à Google. Vérifiez votre connexion Internet et réessayez.';

  @override
  String get welcomeScreenTitle => 'Bienvenue sur Live Vitalist';

  @override
  String get welcomeScreenSubtitle =>
      'Configurons votre profil afin de personnaliser votre parcours nutrition et fitness.';

  @override
  String welcomeScreenExistingAccount(String googleLink) {
    return 'Vous avez déjà un compte ? $googleLink.';
  }

  @override
  String get welcomeScreenGoogleLink => 'Se connecter avec Google';

  @override
  String get termsScreenTitle => 'Tout est prêt';

  @override
  String termsScreenAgreement(String termsLink, String privacyLink) {
    return 'En continuant, vous acceptez nos $termsLink et notre $privacyLink.';
  }

  @override
  String get termsScreenTermsLink => 'Conditions générales';

  @override
  String get termsScreenPrivacyLink => 'Politique de confidentialité';

  @override
  String get legalDialogTitle => 'Veuillez accepter nos conditions';

  @override
  String legalPrerequisites(String privacyLink, String termsLink) {
    return 'Avant d\'utiliser Live Vitalist, veuillez lire et accepter notre $privacyLink et nos $termsLink.';
  }

  @override
  String get legalPrivacyPolicy => 'Politique de confidentialité';

  @override
  String get legalTermsOfUse => 'Conditions d\'utilisation';

  @override
  String get legalSettingsHint =>
      'Vous pouvez consulter la Politique de confidentialité et les Conditions d\'utilisation à tout moment dans les Paramètres de l\'application, accessibles via le menu ⋮ en haut à droite.';

  @override
  String get appRoutingErrorMessage =>
      'La page demandée n\'a pas pu être ouverte.';

  @override
  String get appInitializationErrorMessage =>
      'L\'application n\'a pas pu être initialisée.';

  @override
  String get calendarTitle => 'Calendrier';

  @override
  String get calendarMaximum => 'Maximum';

  @override
  String get calendarLeadingNutrient => 'Nutriment dominant';

  @override
  String get calendarMinimum => 'Minimum';

  @override
  String get alimentJsonEditorTitle => 'Éditeur JSON d\'aliment';

  @override
  String get alimentEditorTitle => 'Éditeur d\'aliment';

  @override
  String get alimentEditorGenericTitle => 'Éditeur';

  @override
  String get alimentEditorSaveChangesTitle => 'Enregistrer les modifications ?';

  @override
  String get alimentEditorSaveChangesMessage =>
      'Voulez-vous enregistrer cet aliment ?';

  @override
  String get alimentEditorAddAliment => 'Ajouter un aliment';

  @override
  String get alimentEditorSearchAliment => 'Rechercher un aliment';

  @override
  String get alimentEditorServedAmount => 'Quantité servie :';

  @override
  String get alimentEditorSelectorTitle => 'Sélecteur d\'aliments';

  @override
  String get alimentEditorNewUnit => 'Nouvelle unité';

  @override
  String get alimentEditorUnitName => 'Nom de l\'unité';

  @override
  String get alimentEditorAmount => 'Quantité';

  @override
  String get alimentEditorAddSynonym => 'Ajouter un synonyme';

  @override
  String get alimentEditorDeleteSynonym => 'Supprimer le synonyme';

  @override
  String alimentEditorEnterLabel(String label) {
    return 'Saisir $label';
  }

  @override
  String get mealsJournalDeleteMealTitle => 'Supprimer le repas ?';

  @override
  String get mealsJournalDeleteMealMessage =>
      'Voulez-vous vraiment supprimer ce repas ?';

  @override
  String get mealsJournalTitle => 'Journal des repas';

  @override
  String get mealsJournalBreakfast => 'Petit-déjeuner';

  @override
  String get mealsJournalLunch => 'Déjeuner';

  @override
  String get mealsJournalDinner => 'Dîner';

  @override
  String get mealsJournalAddMeal => 'Ajouter un repas';

  @override
  String get mealsJournalAddAliment => 'Ajouter un aliment';

  @override
  String get mealsJournalAddTemporaryAliment => 'Ajouter un aliment temporaire';

  @override
  String get mealsJournalShowNotification => 'Afficher la notification';

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
    return '$mealName : $_temp0';
  }

  @override
  String get mealsJournalNotificationChannel => 'Résumé du repas';

  @override
  String get mealsJournalNotificationChannelDescription =>
      'Notification textuelle avec une liste d\'aliments';

  @override
  String get mealsJournalNotificationSummary => 'Résumé du repas';

  @override
  String get mealsJournalNotificationBody =>
      'Développez pour voir les aliments';

  @override
  String get superSearchSearchAliments => 'Rechercher des aliments';

  @override
  String get superSearchAliments => 'Aliments';

  @override
  String get superSearchNoAlimentsFound => 'Aucun aliment trouvé';

  @override
  String get superSearchTryAnotherName =>
      'Essayez un autre nom ou vérifiez l\'orthographe.';

  @override
  String get superSearchAddToMeal => 'Ajouter au repas';

  @override
  String get superSearchAiDisclaimerTitle =>
      'Données alimentaires créées par IA';

  @override
  String get superSearchAiDisclaimerMessage =>
      'Certains aliments sélectionnés contiennent des données générées ou améliorées par l’intelligence artificielle. Ces informations peuvent être incomplètes ou inexactes et ne remplacent pas des conseils nutritionnels ou médicaux vérifiés.';

  @override
  String get superSearchAiDisclaimerAgreeAndDoNotShowAgain =>
      'Accepter et ne plus afficher';

  @override
  String get superSearchWriteAlimentFirst =>
      'Saisissez d\'abord l\'aliment dans la barre de recherche.';

  @override
  String superSearchAddAliments(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Ajouter $count aliments',
      one: 'Ajouter un aliment',
    );
    return '$_temp0';
  }

  @override
  String superSearchResultCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count résultats',
      one: '1 résultat',
      zero: 'Aucun résultat',
    );
    return '$_temp0';
  }

  @override
  String get nutrientDisplayTitle => 'Nutriments';

  @override
  String get nutrientDisplayAddNewNutrient => 'Ajouter un nutriment';

  @override
  String get nutrientDisplayAmount => 'Quantité :';

  @override
  String get nutrientDisplayLowerLimit => 'Limite inférieure :';

  @override
  String get nutrientDisplayUpperLimit => 'Limite supérieure :';

  @override
  String get nutrientDisplayTopSources => 'Principales sources';

  @override
  String nutrientDisplayIntake(String nutrient) {
    return 'Apport en $nutrient';
  }

  @override
  String nutrientDisplayAmountValue(String amount) {
    return 'Quantité : $amount';
  }

  @override
  String nutrientDisplayLowerLimitValue(String value) {
    return 'Limite inférieure : $value';
  }

  @override
  String nutrientDisplayUpperLimitValue(String value) {
    return 'Limite supérieure : $value';
  }

  @override
  String get ratioBarsTitle => 'Barres de répartition';

  @override
  String get reportsNoData => 'Aucune donnée';

  @override
  String get reportsPreviousWeek => 'Semaine précédente';

  @override
  String get reportsCurrentWeek => 'Semaine en cours';

  @override
  String get reportsConsistency => 'Régularité';

  @override
  String get reportsAverageDailyCalories => 'Calories quotidiennes moyennes';

  @override
  String reportsWeekReportTitle(int number) {
    return 'Rapport de la semaine $number';
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
      other: '$total jours',
      one: '1 jour',
    );
    return '$count / $_temp0 dans l\'objectif';
  }

  @override
  String get reportsMondayShort => 'L';

  @override
  String get reportsTuesdayShort => 'M';

  @override
  String get reportsWednesdayShort => 'M';

  @override
  String get reportsThursdayShort => 'J';

  @override
  String get reportsFridayShort => 'V';

  @override
  String get reportsSaturdayShort => 'S';

  @override
  String get reportsSundayShort => 'D';

  @override
  String get settingsTitle => 'Paramètres';

  @override
  String get settingsDocuments => 'Documents';

  @override
  String get settingsPrivacyPolicy => 'Politique de confidentialité';

  @override
  String get settingsTermsOfUse => 'Conditions d\'utilisation';

  @override
  String get settingsSendFeedback => 'Envoyer des commentaires';

  @override
  String get settingsDataDeletion => 'Suppression des données';

  @override
  String get settingsConnectWithGoogle => 'Se connecter avec Google';

  @override
  String get settingsGoogleBackupMessage =>
      'Sauvegardez vos fichiers dans le cloud ou restaurez vos données en vous connectant à Google.';

  @override
  String get settingsUseMonthDayFormat => 'Utiliser le format mois/jour';

  @override
  String get settingsUseComplexCalendar =>
      'Utiliser la vue calendrier détaillée';

  @override
  String get settingsShowMacroDistribution =>
      'Afficher la répartition des macronutriments';

  @override
  String get settingsShowOmegaBalance =>
      'Afficher l\'équilibre Oméga-3 / Oméga-6';

  @override
  String get settingsAccountDeletion => 'Suppression du compte';

  @override
  String get settingsAccountAndDataDeletion =>
      'Suppression du compte et des données';

  @override
  String get settingsPermanentlyDeleteOnlineData =>
      'Supprimer définitivement les données en ligne';

  @override
  String get settingsPermanentlyDeleteAllData =>
      'Supprimer définitivement toutes les données';

  @override
  String get settingsReauthenticateMessage =>
      'Vous devez d\'abord vous authentifier à nouveau avant de pouvoir supprimer votre compte associé à Google.';

  @override
  String get settingsReauthenticateAndDelete =>
      'Se réauthentifier et supprimer';

  @override
  String get settingsDeleteAllDescription =>
      'Vous pouvez supprimer votre compte et toutes les données stockées en ligne et sur votre appareil à l\'aide du bouton ci-dessous. Cette action supprimera définitivement tout ce qui est lié à votre compte et réinitialisera l\'application.';

  @override
  String get settingsDeleteAllConfirmation =>
      'Voulez-vous vraiment supprimer votre compte et toutes les données associées ? Vos données en ligne et votre stockage local seront effacés. Cette action est définitive et irréversible.';

  @override
  String get settingsDeleteOnlineDescription =>
      'Vous pouvez supprimer votre compte et toutes les données stockées en ligne à l\'aide du bouton ci-dessous. Vos données seront définitivement supprimées de nos serveurs, mais les paramètres de l\'application et le stockage local resteront sur votre appareil.';

  @override
  String get settingsDeleteOnlineConfirmation =>
      'Voulez-vous vraiment supprimer votre compte et toutes les données stockées en ligne ? Cette action est définitive et irréversible.';

  @override
  String get settingsDeletionFailed =>
      'Échec de la suppression, rien n\'a été supprimé.';

  @override
  String get legalClosingApp => 'Fermeture de l\'application...';

  @override
  String get legalExitApp => 'Quitter l\'application';

  @override
  String get legalAgree => 'J\'accepte';
}
