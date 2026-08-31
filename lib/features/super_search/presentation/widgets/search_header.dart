import 'package:flutter/material.dart';
import 'package:live_vitalist/l10n/app_localizations.dart';

class SearchHeader extends StatelessWidget {
  const SearchHeader({
    required this.query,
    required this.resultCount,
    super.key,
  });

  final String query;
  final int resultCount;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final resultLabel = l.superSearchResultCount(resultCount);
    final doShowCount = query.trim().isNotEmpty;

    return Row(
      children: [
        Icon(Icons.search_rounded),
        SizedBox(width: 8.0),
        Text(
          l.superSearchAliments,
          style: theme.textTheme.bodyLarge
              ?.copyWith(color: theme.colorScheme.onSurface),
        ),
        Spacer(),
        AnimatedOpacity(
          duration: Duration(milliseconds: 100),
          opacity: doShowCount ? 1.0 : 0.0,
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(12.0),
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 10.0,
                vertical: 4.0,
              ),
              child: Text(resultLabel, style: theme.textTheme.labelMedium),
            ),
          ),
        ),
      ],
    );
  }
}
