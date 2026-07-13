import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:live_vitalist/aliment/data/aliment_bank.dart';
import 'package:live_vitalist/aliment/domain/aliment_data.dart';
import 'package:live_vitalist/core/presentation/widgets/mini_card.dart';
import 'package:live_vitalist/palette.dart';
import 'package:live_vitalist/string_input.dart';
import 'package:live_vitalist/super_search/domain/pending_aliment.dart';
import 'package:live_vitalist/super_search/presentation/controllers/aliment_search_controller.dart';

class AlimentResultTile extends ConsumerStatefulWidget {
  const AlimentResultTile({required this.alimentID, super.key});

  final String alimentID;

  @override
  ConsumerState<AlimentResultTile> createState() => _AlimentResultTileState();
}

class _AlimentResultTileState extends ConsumerState<AlimentResultTile> {
  @override
  Widget build(BuildContext context) {
    final bank = ref.watch(alimentBankProvider);
    final searchState = ref.watch(alimentSearchProvider);
    final notifier = ref.read(alimentSearchProvider.notifier);

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
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
              child: Row(
                children: [
                  Expanded(child: Text(data.name, softWrap: true)),
                  if (pending != null)
                    const Icon(Icons.check_rounded, color: Palette.selectGreen),
                ],
              ),
            ),
          ),
          if (pending != null)
            Padding(
              padding: const EdgeInsets.only(
                  left: 16.0, right: 16.0, bottom: 12.0),
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
          getValue: () => pending.servingSize,
          setValue: (val) {
            if (val >= 0.0) pending.servingSize = val;
          },
        ),
        const SizedBox(width: 12.0),
        Expanded(
          child: DropdownButton<String>(
            isExpanded: true,
            value: units.contains(pending.unit) ? pending.unit : null,
            items: units.map((unit) {
              return DropdownMenuItem(
                value: unit,
                child: Text(unit),
              );
            }).toList(),
            onChanged: (unit) {
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
