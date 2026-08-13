import 'package:flutter/material.dart';
import 'package:live_vitalist/features/aliment_editor/aliment_data_editor/presentation/widgets/editor_inputs/editor_input_decoration.dart';

class UnitSynonymInput extends StatelessWidget {
  final TextEditingController nameController;
  final TextEditingController valueController;
  final Function(String newKey) onRename;
  final Function(double value) onValueChanged;
  final Function() onDelete;

  const UnitSynonymInput({
    required this.nameController,
    required this.valueController,
    required this.onRename,
    required this.onValueChanged,
    required this.onDelete,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    void submitValue(String rawValue) {
      final parsed = double.tryParse(rawValue.trim());
      if (parsed == null || parsed <= 0) return;
      onValueChanged(parsed);
    }

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: TextField(
              controller: nameController,
              textInputAction: TextInputAction.next,
              decoration: editorInputDecoration(
                context,
                hintText: 'Unit name',
                icon: Icons.sell_outlined,
              ),
              onSubmitted: onRename,
            ),
          ),
          SizedBox(width: 8.0),
          Expanded(
            flex: 1,
            child: TextField(
              controller: valueController,
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              textInputAction: TextInputAction.done,
              decoration: editorInputDecoration(
                context,
                hintText: 'Amount',
              ),
              onSubmitted: submitValue,
            ),
          ),
          SizedBox(width: 8.0),
          IconButton.filledTonal(
            tooltip: 'Delete synonym',
            icon: Icon(Icons.delete_outline_rounded),
            onPressed: onDelete,
          ),
        ],
      ),
    );
  }
}
