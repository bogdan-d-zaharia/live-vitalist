import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:live_vitalist/core/presentation/widgets/custom_card.dart';
import 'package:live_vitalist/nutrient_display/presentation/widgets/action_buttons.dart';
import 'package:live_vitalist/nutrient_display/presentation/controllers/nutrient_display_controller.dart';
import 'package:live_vitalist/nutrient_display/presentation/widgets/nutrient_display_edit.dart';
import 'package:live_vitalist/nutrient_display/presentation/widgets/nutrient_display_view.dart';

class NutrientDisplay extends ConsumerWidget {
  const NutrientDisplay({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(nutrientDisplayControllerProvider);

    return CustomCard(
      logo: const Icon(Icons.bar_chart_rounded),
      title: 'Nutrients',
      action: ActionButtons(),
      child: state.isEditMode ? NutrientDisplayEdit() : NutrientDisplayView(),
    );
  }
}
