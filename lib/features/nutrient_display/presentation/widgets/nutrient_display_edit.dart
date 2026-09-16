import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:live_vitalist/features/nutrient/presentation/widgets/nutrient_async_status.dart';
import 'package:live_vitalist/l10n/app_localizations.dart';
import 'package:live_vitalist/features/nutrient/data/nutrient_provider.dart';
import 'package:live_vitalist/features/nutrient_display/presentation/ui_helpers/nutrient_extensions.dart';
import 'package:live_vitalist/features/nutrient_display/presentation/ui_helpers/nutrients_editing_logic.dart';
import 'package:live_vitalist/features/nutrient_display/presentation/widgets/dimmed_parentheses_text.dart';

class NutrientDisplayEdit extends ConsumerWidget {
  const NutrientDisplayEdit({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final nutrientAsync = ref.watch(nutrientsProvider);
    if (!nutrientAsync.hasValue) {
      return NutrientAsyncStatus(value: nutrientAsync);
    }
    final nutrientsState = nutrientAsync.requireValue;
    final nutrientsNotifier =
        ref.read(nutrientConfigProvider(nutrientsState.configId!).notifier);
    final localization = AppLocalizations.of(context);
    final localeCode = Localizations.localeOf(context).languageCode;

    final widgets = nutrientsState.order.map((key) {
      final nutrient = nutrientsState.data[key]!;
      final label = nutrient.resolveNutrientLabel(
        localization: localization,
        nutrientKey: key,
        localeCode: localeCode,
      );

      return InkWell(
        key: ValueKey(key),
        onTap: () async {
          final updated = await editNutrient(context, nutrient, key);
          if (updated == null) return;
          await nutrientsNotifier.updateNutrient(key, updated);
        },
        child: Row(
          children: [
            Icon(Icons.drag_indicator_rounded),
            Expanded(
              child: DimmedParenthesesText(
                label: label,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
            Switch(
              value: !nutrient.tags.contains('disabled'),
              onChanged: (_) => nutrientsNotifier.toggleTag(key, 'disabled'),
            ),
          ],
        ),
      );
    }).toList();

    return Column(
      children: [
        ReorderableListView(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          onReorderItem: nutrientsNotifier.reorder,
          children: widgets,
        ),
        Divider(),
        SizedBox(
          width: double.infinity,
          child: TextButton(
            onPressed: () => showNewNutrientDialog(context),
            child: Text(l.nutrientDisplayAddNewNutrient),
          ),
        ),
      ],
    );
  }
}
