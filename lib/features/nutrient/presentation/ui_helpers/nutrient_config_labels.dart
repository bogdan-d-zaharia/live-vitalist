import 'package:live_vitalist/features/nutrient/domain/nutrient_config_failure.dart';
import 'package:live_vitalist/features/nutrient/domain/nutrient_config_header.dart';
import 'package:live_vitalist/l10n/app_localizations.dart';

String nutrientConfigName(NutrientConfigHeader header, AppLocalizations l) =>
    header.name ?? l.nutrientConfigDefaultName;

String nutrientConfigError(Object? error, AppLocalizations l) =>
    switch (error) {
      NutrientConfigFailure(
        reason: NutrientConfigFailureReason.notFound,
        :final configId
      ) =>
        l.nutrientConfigNotFound(configId ?? ''),
      NutrientConfigFailure(
        reason: NutrientConfigFailureReason.selectionChanged
      ) =>
        l.nutrientConfigSelectionChanged,
      NutrientConfigFailure(reason: NutrientConfigFailureReason.dayChanged) =>
        l.nutrientConfigDayChanged,
      NutrientConfigFailure(reason: NutrientConfigFailureReason.lastConfig) =>
        l.nutrientConfigLastConfig,
      _ => l.nutrientConfigUpdateFailed,
    };
