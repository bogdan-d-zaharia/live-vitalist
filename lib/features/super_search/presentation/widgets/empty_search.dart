import 'package:flutter/material.dart';
import 'package:live_vitalist/l10n/app_localizations.dart';

class EmptySearch extends StatelessWidget {
  final VoidCallback onCreateAliment;
  const EmptySearch({super.key, required this.onCreateAliment});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final theme = Theme.of(context);

    return Center(
      key: ValueKey('empty-search'),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.search_off_rounded,
              size: 48.0,
              color: theme.colorScheme.onSurfaceVariant,
            ),
            SizedBox(height: 16.0),
            Text(
              l.superSearchNoAlimentsFound,
              textAlign: TextAlign.center,
              style: theme.textTheme.titleMedium,
            ),
            SizedBox(height: 6.0),
            Text(
              l.superSearchTryAnotherName,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            SizedBox(height: 20.0),
            FilledButton.icon(
              onPressed: onCreateAliment,
              icon: Icon(Icons.add_rounded),
              label: Text(l.alimentEditorAddAliment),
            ),
          ],
        ),
      ),
    );
  }
}
