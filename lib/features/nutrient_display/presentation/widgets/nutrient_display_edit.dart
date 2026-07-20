import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:live_vitalist/core/theme/palette.dart';
import 'package:live_vitalist/features/nutrient/data/nutrient_provider.dart';
import 'package:live_vitalist/features/nutrient_display/presentation/ui_helpers/nutrients_editing_logic.dart';
import 'package:live_vitalist/features/settings/data/settings_data.dart';

class NutrientDisplayEdit extends ConsumerWidget {
  const NutrientDisplayEdit({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final nutrientsState = ref.watch(nutrientsProvider);
    final nutrientsNotifier = ref.read(nutrientsProvider.notifier);

    final widgets = nutrientsState.order.map((key) {
      final nutrient = nutrientsState.data[key]!;
      final label = nutrient.translations[SettingsData.language]!;

      return InkWell(
        key: ValueKey(key),
        onTap: () async {
          final updated = await editNutrient(context, nutrient);
          if (updated != null) nutrientsNotifier.update(key, updated);
        },
        child: Row(
          children: [
            const Icon(Icons.drag_indicator_rounded),
            Expanded(
              child: Palette.dimParentheses(
                  label, Theme.of(context).textTheme.bodyMedium),
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
