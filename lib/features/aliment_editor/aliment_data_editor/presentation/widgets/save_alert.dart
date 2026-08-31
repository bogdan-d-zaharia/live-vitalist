import 'package:flutter/material.dart';
import 'package:live_vitalist/l10n/app_localizations.dart';

class SaveAlert extends StatelessWidget {
  const SaveAlert({super.key});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return AlertDialog(
      title: Text(l.alimentEditorSaveChangesTitle),
      content: Text(l.alimentEditorSaveChangesMessage),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: Text(l.actionCancel),
        ),
        ElevatedButton(
          onPressed: () => Navigator.pop(context, true),
          child: Text(l.actionSave),
        ),
      ],
    );
  }
}
