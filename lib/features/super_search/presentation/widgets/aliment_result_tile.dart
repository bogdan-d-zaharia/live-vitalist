import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:live_vitalist/core/localization/localization_provider.dart';
import 'package:live_vitalist/core/presentation/widgets/mini_card.dart';
import 'package:live_vitalist/core/theme/app_colors_theme.dart';
import 'package:live_vitalist/core/presentation/widgets/data_input/number_input.dart';
import 'package:live_vitalist/features/aliment/data/aliment_data_extensions.dart';
import 'package:live_vitalist/features/aliment_bank/data/aliment_bank.dart';
import 'package:live_vitalist/features/aliment/domain/aliment_data.dart';
import 'package:live_vitalist/features/super_search/domain/pending_aliment.dart';
import 'package:live_vitalist/features/super_search/presentation/controllers/super_search_controller.dart';

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
    final searchState = ref.watch(superSearchProvider);
    final notifier = ref.read(superSearchProvider.notifier);

    final data = bank.aliments[widget.alimentID];
    if (data == null) return const SizedBox.shrink();

    final pending = searchState.selection
        .where((item) => item.alimentID == widget.alimentID)
        .firstOrNull;

    return MiniCard(
      child: Column(
        children: [
          InkWell(
            onTap: () => notifier.toggle(
              PendingAliment(
                alimentID: widget.alimentID,
                servingSize: 1.0,
                unit: data.unit,
              ),
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
              child: Row(
                children: [
                  Expanded(
                      child: Text(data.readName(languageCode), softWrap: true)),
                  if (pending != null)
                    Icon(
                      Icons.check_rounded,
                      color: AppColorsTheme.of(context).select,
                    ),
                ],
              ),
            ),
          ),
          if (pending != null)
            Padding(
              padding: EdgeInsets.only(left: 16.0, right: 16.0, bottom: 12.0),
              child: _buildAmountRow(data, pending),
            ),
        ],
      ),
    );
  }

  Widget _buildAmountRow(AlimentData data, PendingAliment pending) {
    final units = [data.unit, ...data.unitSynonyms.keys];

    return Row(
      children: [
        NumberInput(
          inputWidth: 70.0,
          getValue: () => pending.servingSize,
          setValue: (val) {
            if (val >= 0.0) pending.servingSize = val;
          },
        ),
        SizedBox(width: 12.0),
        Expanded(
          child: DropdownMenu<String>(
            key: ValueKey(pending.unit),
            expandedInsets: EdgeInsets.zero,
            requestFocusOnTap: false,
            initialSelection:
                units.contains(pending.unit) ? pending.unit : null,
            dropdownMenuEntries: units.map((unit) {
              return DropdownMenuEntry(value: unit, label: unit);
            }).toList(),
            onSelected: (unit) {
              if (unit != null) {
                setState(() => pending.unit = unit);
              }
            },
          ),
        ),
      ],
    );
  }
}
