import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:live_vitalist/features/nutrient/data/nutrient_provider.dart';
import 'package:live_vitalist/features/nutrient_display/presentation/ui_helpers/nutrient_extensions.dart';
import 'package:live_vitalist/features/nutrient_display/presentation/ui_helpers/nutrients_editing_logic.dart';
import 'package:live_vitalist/features/nutrient_display/presentation/widgets/dimmed_parentheses_text.dart';
import 'package:live_vitalist/l10n/app_localizations.dart';

class NutrientDisplayEdit extends ConsumerWidget {
  const NutrientDisplayEdit({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final nutrientsState = ref.watch(nutrientsProvider);
    final nutrientsNotifier = ref.read(nutrientsProvider.notifier);
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
          if (updated != null) nutrientsNotifier.update(key, updated);
        },
        child: Row(
          children: [
            const Icon(Icons.drag_indicator_rounded),
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
          physics: const NeverScrollableScrollPhysics(),
          onReorder: nutrientsNotifier.reorder,
          children: widgets,
        ),
        const Divider(),
        SizedBox(
          width: double.infinity,
          child: TextButton(
            onPressed: () => showNewNutrientDialog(context),
            child: const Text('Add new nutrient'),
          ),
        ),
      ],
    );
  }
}
