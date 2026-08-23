import 'package:flutter/material.dart';
import 'package:live_vitalist/features/aliment/domain/aliment_data.dart';

class UnitDropdown extends StatelessWidget {
  final AlimentData data;
  final String currentUnit;
  final Function(String) onChanged;

  const UnitDropdown({
    required this.data,
    required this.currentUnit,
    required this.onChanged,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final units = [data.unit, ...data.unitSynonyms.keys];

    final selectedUnit = units.contains(currentUnit) ? currentUnit : null;

    return DropdownMenu<String>(
      key: ValueKey(selectedUnit),
      expandedInsets: EdgeInsets.zero,
      initialSelection: selectedUnit,
      dropdownMenuEntries: units.map((unit) {
        return DropdownMenuEntry(value: unit, label: unit);
      }).toList(),
      onSelected: (unit) {
        if (unit != null) onChanged(unit);
      },
    );
  }
}
