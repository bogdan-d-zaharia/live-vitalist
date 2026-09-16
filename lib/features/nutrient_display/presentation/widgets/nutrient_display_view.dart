import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:live_vitalist/features/nutrient/presentation/widgets/nutrient_async_status.dart';
import 'package:live_vitalist/core/localization/localization_provider.dart';
import 'package:live_vitalist/features/aliment_bank/data/aliment_bank.dart';
import 'package:live_vitalist/features/day/data/day_provider.dart';
import 'package:live_vitalist/features/day/domain/day_extensions.dart';
import 'package:live_vitalist/features/nutrient/data/nutrient_provider.dart';
import 'package:live_vitalist/features/nutrient/domain/nutrient_state.dart';
import 'package:live_vitalist/features/nutrient_display/presentation/ui_helpers/nutrient_sorting_logic.dart';
import 'package:live_vitalist/features/nutrient_display/presentation/ui_helpers/nutrient_extensions.dart';
import 'package:live_vitalist/features/nutrient_display/presentation/widgets/nutrient_tile.dart';
import 'package:live_vitalist/l10n/app_localizations.dart';

class NutrientDisplayView extends ConsumerWidget {
  const NutrientDisplayView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final languageCode = ref.watch(localizationProvider);

    final dayAsync = ref.watch(averageDayProvider);
    if (!dayAsync.hasValue) {
      return NutrientAsyncStatus(value: dayAsync);
    }
    final avgDay = dayAsync.requireValue;
    final bank = ref.watch(alimentBankProvider);
    final nutrientAsync = ref.watch(nutrientsProvider);
    if (!nutrientAsync.hasValue) {
      return NutrientAsyncStatus(value: nutrientAsync);
    }
    final rawState = nutrientAsync.requireValue;
    if (rawState.order.isEmpty) return SizedBox.shrink();
    final state = NutrientState(
      data: {...rawState.data}..remove(rawState.order.first),
      order: rawState.order.sublist(1),
    );

    final intake = avgDay.readIntake(bank);

    final l = AppLocalizations.of(context);
    final localeCode = Localizations.localeOf(context).languageCode;
    final keys = filteredAndSortedKeys(state, intake);
    final widgets = keys.map((key) {
      final field = state.data[key]!;
      final value = (intake[key] ?? 0.0);
      final label = field.resolveNutrientLabel(
        localization: l,
        nutrientKey: key,
        localeCode: localeCode,
      );
      return NutrientTile(
        intake: field.toIntake(label, value),
        nutrientName: key,
        bank: bank,
        day: avgDay,
        languageCode: languageCode,
      );
    }).toList();

    return Column(children: _insertDividers(widgets));
  }

  List<Widget> _insertDividers(List<Widget> widgets) {
    final divided = <Widget>[];
    for (int i = 0; i < widgets.length; i++) {
      divided.add(widgets[i]);
      if (i < widgets.length - 1) {
        divided.add(Divider(
          color: Colors.black.withValues(alpha: 0.1),
          thickness: 0.5,
          height: 0.0,
        ));
      }
    }
    return divided;
  }
}
