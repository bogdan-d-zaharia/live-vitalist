import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:live_vitalist/core/localization/localization_provider.dart';
import 'package:live_vitalist/core/presentation/widgets/mini_card.dart';
import 'package:live_vitalist/core/theme/app_colors_theme.dart';
import 'package:live_vitalist/core/presentation/widgets/data_input/number_input.dart';
import 'package:live_vitalist/features/aliment/data/aliment_data_extensions.dart';
import 'package:live_vitalist/features/aliment/domain/aliment.dart';
import 'package:live_vitalist/features/aliment/domain/aliment_data.dart';
import 'package:live_vitalist/features/aliment_bank/data/aliment_bank.dart';
import 'package:live_vitalist/features/super_search/presentation/controllers/super_search_controller.dart';
import 'package:live_vitalist/features/aliment_editor/aliment_data_editor/presentation/widgets/food_image_picker.dart';

class AlimentResultTile extends ConsumerStatefulWidget {
  const AlimentResultTile({required this.alimentID, super.key});

  final String alimentID;

  @override
  ConsumerState<AlimentResultTile> createState() => _AlimentResultTileState();
}

class _AlimentResultTileState extends ConsumerState<AlimentResultTile> {
  @override
  Widget build(BuildContext context) {
    final languageCode = ref.watch(localizationProvider);
    final bank = ref.watch(alimentBankProvider);
    final catalogs = ref.watch(alimentCatalogsProvider);
    final searchState = ref.watch(superSearchProvider);
    final notifier = ref.read(superSearchProvider.notifier);

    final data = bank.aliments[widget.alimentID];
    if (data == null) return const SizedBox.shrink();

    final idSegments = widget.alimentID.split('-');
    final catalogKey = idSegments.first;
    final isAiEnhanced = idSegments.length > 1 && idSegments[1] == 'ai';

    final catalog = catalogs[catalogKey];
    final presentation = catalog?.presentations[languageCode] ??
        catalog?.presentations['en'] ??
        catalog?.presentations.values.firstOrNull;
    final sourceTitle = presentation?.sourceTitle.trim();
    final name = data.readName(languageCode);

    final selectedAliment = searchState.selection
        .where((item) => item.alimentID == widget.alimentID)
        .firstOrNull;

    return MiniCard(
      child: Column(
        children: [
          InkWell(
            onTap: () => notifier.toggle(
              InstancedAliment(
                alimentID: widget.alimentID,
                servingSize: 1.0,
                unit: data.unit,
              ),
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
              child: Row(
                children: [
                  FoodImageThumbnail(
                    imageKey: data.image,
                    fallbackName: name,
                  ),
                  SizedBox(width: 14.0),
                  Expanded(
                    child: Wrap(
                      spacing: 4.0,
                      alignment: WrapAlignment.spaceBetween,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        Text(name),
                        if (sourceTitle != null && sourceTitle.isNotEmpty)
                          _AlimentSource(
                            sourceTitle: sourceTitle,
                            isAiEnhanced: isAiEnhanced,
                          ),
                      ],
                    ),
                  ),
                  if (selectedAliment != null)
                    Icon(
                      Icons.check_rounded,
                      color: AppColorsTheme.of(context).select,
                    ),
                ],
              ),
            ),
          ),
          if (selectedAliment != null)
            Padding(
              padding: EdgeInsets.only(left: 16.0, right: 16.0, bottom: 12.0),
              child: _buildAmountRow(data, selectedAliment),
            ),
        ],
      ),
    );
  }

  Widget _buildAmountRow(AlimentData data, InstancedAliment selectedAliment) {
    final units = [data.unit, ...data.unitSynonyms.keys];
    final notifier = ref.read(superSearchProvider.notifier);

    return Row(
      children: [
        NumberInput(
          inputWidth: 70.0,
          getValue: () => selectedAliment.servingSize,
          setValue: (val) {
            if (val < 0.0) return;
            notifier.updateAliment(selectedAliment.copyWith(servingSize: val));
          },
        ),
        SizedBox(width: 12.0),
        Expanded(
          child: DropdownMenu<String>(
            key: ValueKey(selectedAliment.unit),
            expandedInsets: EdgeInsets.zero,
            requestFocusOnTap: false,
            initialSelection: units.contains(selectedAliment.unit)
                ? selectedAliment.unit
                : null,
            dropdownMenuEntries: units.map((unit) {
              return DropdownMenuEntry(value: unit, label: unit);
            }).toList(),
            onSelected: (unit) {
              if (unit == null) return;
              notifier.updateAliment(selectedAliment.copyWith(unit: unit));
            },
          ),
        ),
      ],
    );
  }
}

class _AlimentSource extends StatelessWidget {
  const _AlimentSource({
    required this.sourceTitle,
    required this.isAiEnhanced,
  });

  final String sourceTitle;
  final bool isAiEnhanced;

  @override
  Widget build(BuildContext context) {
    final style = Theme.of(context).textTheme.bodySmall?.copyWith(
          color: Theme.of(context)
              .colorScheme
              .onSurfaceVariant
              .withValues(alpha: 0.6),
        );

    final text = Text(sourceTitle, style: style);
    if (!isAiEnhanced) return text;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (isAiEnhanced) ...[
          Icon(
            Icons.auto_awesome_rounded,
            size: 14.0,
            color: style?.color,
          ),
          SizedBox(width: 2.0),
        ],
        text,
      ],
    );
  }
}
