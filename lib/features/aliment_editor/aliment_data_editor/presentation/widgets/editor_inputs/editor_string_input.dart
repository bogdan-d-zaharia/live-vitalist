import 'package:flutter/material.dart';
import 'package:live_vitalist/l10n/app_localizations.dart';
import 'package:live_vitalist/features/aliment_editor/aliment_data_editor/presentation/widgets/editor_inputs/editor_input_decoration.dart';

class EditorStringInput extends StatelessWidget {
  final String label;
  final String value;
  final void Function(String) onChanged;
  final TextEditingController controller;

  const EditorStringInput(
    this.label,
    this.value,
    this.onChanged,
    this.controller, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 6.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: theme.textTheme.labelLarge?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          SizedBox(height: 8.0),
          TextField(
            style: theme.textTheme.bodyLarge,
            controller: controller,
            onChanged: onChanged,
            decoration: editorInputDecoration(
              context,
              hintText: AppLocalizations.of(context)
                  .alimentEditorEnterLabel(label.toLowerCase()),
              icon: label == 'Name'
                  ? Icons.restaurant_menu_rounded
                  : Icons.straighten_rounded,
            ),
          ),
        ],
      ),
    );
  }
}
