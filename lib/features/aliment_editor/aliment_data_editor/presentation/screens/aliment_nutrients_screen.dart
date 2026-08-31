import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:live_vitalist/features/aliment/domain/aliment_data.dart';
import 'package:live_vitalist/features/aliment_editor/aliment_data_editor/presentation/widgets/editor_inputs/nutrient_input.dart';
import 'package:live_vitalist/features/nutrient/data/nutrient_provider.dart';

class AlimentNutrientsScreen extends ConsumerWidget {
  final AlimentData data;

  const AlimentNutrientsScreen({
    required this.data,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final nutrients = ref.watch(nutrientsProvider);
    final selectedNutrients = nutrients.order.where((key) =>
        key != 'kcals' && !nutrients.data[key]!.tags.contains('disabled'));

    return ListView(
      padding: EdgeInsets.symmetric(horizontal: 24.0),
      children: selectedNutrients
          .map((key) => NutrientInput(key, nutrients, data))
          .toList(),
    );
  }
}
