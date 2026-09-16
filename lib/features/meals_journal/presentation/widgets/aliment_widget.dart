import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:live_vitalist/features/nutrient/presentation/widgets/nutrient_async_status.dart';
import 'package:live_vitalist/core/localization/localization_provider.dart';
import 'package:live_vitalist/features/aliment/data/aliment_data_extensions.dart';
import 'package:live_vitalist/features/aliment_bank/data/aliment_bank.dart';
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
    final languageCode = ref.watch(localizationProvider);

    final nutrientAsync = ref.watch(nutrientsProvider);
    if (nutrientAsync.isLoading ||
        nutrientAsync.hasError ||
        !nutrientAsync.hasValue) {
      return NutrientAsyncStatus(value: nutrientAsync);
    }
    final model = nutrientAsync.requireValue.data;
    final bank = ref.watch(alimentBankProvider);
    final kcalsLabel = model['kcals']?.resolveNutrientLabel(
          localization: AppLocalizations.of(context),
          nutrientKey: 'kcals',
          localeCode: Localizations.localeOf(context).languageCode,
        ) ??
        'Calories';

    final values = aliment.readFields(bank);
    final data = aliment.readDataRef(bank);
    final name = data.readName(languageCode);
    return ElementWidget(
      title: name,
      subTitle:
          '${values['kcals']?.round() ?? 0} ${kcalsLabel.toLowerCase()}, ${aliment.servingSize} ${aliment.unit}',
      leading: FoodImageThumbnail(
        imageKey: data.image,
        fallbackName: name,
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
