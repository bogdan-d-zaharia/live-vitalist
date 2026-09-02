import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:live_vitalist/features/aliment/data/aliment_bank.dart';
import 'package:live_vitalist/features/aliment/domain/aliment.dart';
import 'package:live_vitalist/features/aliment/domain/aliment_extensions.dart';
import 'package:live_vitalist/features/meals_journal/presentation/widgets/element_widget.dart';
import 'package:live_vitalist/features/aliment_editor/aliment_data_editor/presentation/widgets/food_image_picker.dart';
import 'package:live_vitalist/features/nutrient/data/nutrient_provider.dart';
import 'package:live_vitalist/features/nutrient_display/presentation/ui_helpers/nutrient_extensions.dart';
import 'package:live_vitalist/l10n/app_localizations.dart';

class AlimentWidget extends ConsumerWidget {
  const AlimentWidget({
    required this.aliment,
    required this.deleteAliment,
    required this.onTap,
    required this.onLongPress,
    super.key,
  });

  final Aliment aliment;
  final Function() deleteAliment;
  final Function() onTap;
  final Function() onLongPress;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final model = ref.watch(nutrientsProvider).data;
    final bank = ref.watch(alimentBankProvider);
    final kcalsLabel = model['kcals']?.resolveNutrientLabel(
          localization: AppLocalizations.of(context),
          nutrientKey: 'kcals',
          localeCode: Localizations.localeOf(context).languageCode,
        ) ??
        'Calories';

    final values = aliment.readFields(bank);
    final data = aliment.readDataRef(bank);
    return ElementWidget(
      title: data.name,
      subTitle:
          '${values['kcals']?.round() ?? 0} ${kcalsLabel.toLowerCase()}, ${aliment.servingSize} ${aliment.unit}',
      leading: FoodImageThumbnail(
        imageKey: data.image,
        fallbackName: data.name,
      ),
      onTap: onTap,
      onLongPress: onLongPress,
      additional: [
        VerticalDivider(
          color: Theme.of(context).dividerColor,
          thickness: 0.5,
          width: 0.0,
          indent: 8.0,
          endIndent: 8.0,
        ),
        //TODO: Used trial and error to replicate `AspectRatio` without
        // having the width vary.
        SizedBox(
          width: 53.0,
          child: InkWell(
            onTap: deleteAliment,
            child: Center(child: Icon(Icons.remove_rounded)),
          ),
        ),
      ],
    );
  }
}
