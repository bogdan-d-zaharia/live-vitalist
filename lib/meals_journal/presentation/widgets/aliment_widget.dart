import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:live_vitalist/aliment/data/aliment_bank.dart';
import 'package:live_vitalist/aliment/domain/aliment.dart';
import 'package:live_vitalist/aliment/domain/aliment_extensions.dart';
import 'package:live_vitalist/meals_journal/presentation/widgets/element_widget.dart';
import 'package:live_vitalist/nutrient/data/nutrient_provider.dart';
import 'package:live_vitalist/palette.dart';
import 'package:live_vitalist/settings/data/settings_data.dart';

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

    final values = aliment.readFields(bank);
    return ElementWidget(
      title: aliment.readDataRef(bank).name,
      subTitle:
          '${values['kcals']?.round() ?? 0} ${model['kcals']?.translations[SettingsData.language]?.toLowerCase() ?? ''}, ${aliment.servingSize} ${aliment.unit}',
      onTap: onTap,
      onLongPress: onLongPress,
      additional: [
        VerticalDivider(
          color: Palette.divGrey,
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
