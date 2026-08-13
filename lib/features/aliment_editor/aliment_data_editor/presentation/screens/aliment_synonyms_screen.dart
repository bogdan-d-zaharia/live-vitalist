import 'package:flutter/material.dart';
import 'package:live_vitalist/features/aliment/domain/aliment_data.dart';
import 'package:live_vitalist/features/aliment_editor/aliment_data_editor/presentation/widgets/unit_synonyms_editor.dart';

class AlimentSynonymsScreen extends StatelessWidget {
  final AlimentData data;
  final ValueChanged<AlimentData> onDataChanged;

  const AlimentSynonymsScreen({
    required this.data,
    required this.onDataChanged,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.symmetric(horizontal: 24.0),
      children: [
        Text(
          'Unit synonyms',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        SizedBox(height: 12.0),
        UnitSynonymsEditor(
          synonyms: data.unitSynonyms,
          onChanged: (synonyms) => onDataChanged(
            data.copyWith(unitSynonyms: synonyms),
          ),
        ),
      ],
    );
  }
}
