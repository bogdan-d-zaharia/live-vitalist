import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:live_vitalist/aliment/aliment_bank.dart';
import 'package:live_vitalist/custom_card.dart';
import 'package:live_vitalist/icon_button.dart';
import 'package:live_vitalist/string_input.dart';
import 'package:live_vitalist/super_search/domain/pending_aliment.dart';
import 'package:live_vitalist/super_search/presentation/controllers/aliment_search_controller.dart';

class SelectedAlimentTile extends ConsumerStatefulWidget {
  const SelectedAlimentTile({required this.pending, super.key});

  final PendingAliment pending;

  @override
  ConsumerState<SelectedAlimentTile> createState() =>
      _SelectedAlimentTileState();
}

class _SelectedAlimentTileState extends ConsumerState<SelectedAlimentTile> {
  PendingAliment get pending => widget.pending;

  @override
  Widget build(BuildContext context) {
    final bank = ref.watch(alimentBankProvider);
    final data = bank.aliments[pending.alimentID];
    if (data == null) return const SizedBox.shrink();

    final units = [data.unit, ...data.unitSynonyms.keys];

    return MiniCard(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(child: Text(data.name, softWrap: true)),
                MyIconButton(
                  onTap: () => ref
                      .read(alimentSearchProvider.notifier)
                      .remove(pending.alimentID),
                  icon: const Icon(Icons.remove_rounded),
                ),
              ],
            ),
            const SizedBox(height: 4.0),
            Row(
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
            ),
          ],
        ),
      ),
    );
  }
}
