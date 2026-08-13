import 'package:flutter/material.dart';
import 'package:live_vitalist/features/aliment_editor/aliment_data_editor/presentation/widgets/editor_inputs/editor_input_decoration.dart';

class NewSynonymInput extends StatelessWidget {
  final TextEditingController nameController;
  final TextEditingController valueController;
  final Function() onAdd;

  const NewSynonymInput({
    required this.nameController,
    required this.valueController,
    required this.onAdd,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
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
                hintText: 'New unit',
                icon: Icons.add_circle_outline_rounded,
              ),
            ),
          ),
          SizedBox(width: 8.0),
          Expanded(
            flex: 1,
            child: TextField(
              controller: valueController,
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              textInputAction: TextInputAction.done,
              onSubmitted: (_) => onAdd(),
              decoration: editorInputDecoration(
                context,
                hintText: 'Amount',
              ),
            ),
          ),
          SizedBox(width: 8.0),
          IconButton.filled(
            tooltip: 'Add synonym',
            icon: Icon(Icons.add_rounded),
            onPressed: onAdd,
          )
        ],
      ),
    );
  }
}
