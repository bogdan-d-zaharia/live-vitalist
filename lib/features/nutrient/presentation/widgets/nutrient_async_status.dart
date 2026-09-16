import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:live_vitalist/features/day/data/day_provider.dart';
import 'package:live_vitalist/features/nutrient/data/nutrient_provider.dart';
import 'package:live_vitalist/features/nutrient/presentation/ui_helpers/nutrient_config_labels.dart';
import 'package:live_vitalist/l10n/app_localizations.dart';

class NutrientAsyncStatus extends ConsumerWidget {
  final AsyncValue<Object?> value;

  const NutrientAsyncStatus({required this.value, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: Center(
        child: value.hasError
            ? IconButton(
                tooltip: nutrientConfigError(value.error, l),
                icon: Icon(Icons.refresh_rounded),
                onPressed: () {
                  ref.invalidate(nutrientConfigProvider);
                  ref.invalidate(nutrientConfigsListProvider);
                  ref.invalidate(dayRecordProvider);
                  ref.invalidate(nutrientsProvider);
                },
              )
            : CircularProgressIndicator(),
      ),
    );
  }
}
