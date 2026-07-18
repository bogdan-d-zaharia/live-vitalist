import 'package:flutter/material.dart';
import 'package:live_vitalist/aliment/domain/aliment_data.dart';

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

    return DropdownButton<String>(
      isExpanded: true,
      value: units.contains(currentUnit) ? currentUnit : null,
      items: units.map((unit) {
        return DropdownMenuItem(
          value: unit,
          child: SizedBox(width: 300.0, child: Text(unit)),
        );
      }).toList(),
      onChanged: (unit) {
        if (unit != null) onChanged(unit);
      },
    );
  }
}
