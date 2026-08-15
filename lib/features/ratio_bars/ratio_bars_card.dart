import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:live_vitalist/features/aliment/data/aliment_bank.dart';
import 'package:live_vitalist/features/day/data/day_provider.dart';
import 'package:live_vitalist/features/day/domain/day_extensions.dart';
import 'package:live_vitalist/features/ratio_bars/presentation/widgets/ratio_bars.dart';
import 'package:live_vitalist/features/ratio_bars/presentation/widgets/ratio_bars_models.dart';
import 'package:live_vitalist/features/settings/data/settings_data.dart';

class RatioBarsCard extends ConsumerWidget {
  const RatioBarsCard({super.key});

  static const _carbColor = Colors.blue;
  static const _fatColor = Colors.yellow;
  static const _proteinColor = Colors.red;
  static const _omega6Color = Colors.purple;
  static const _omega3Color = Colors.orange;

  String formatNumber(double value) {
    return value.toStringAsFixed(2).replaceAll(RegExp(r'([.]*0+)(?!.*\d)'), '');
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bank = ref.watch(alimentBankProvider);
    final intake = ref.watch(syncAverageDayProvider).readIntake(bank);

    final omega6 = intake['omega6'] ?? 0.0;
    final omega3 = intake['omega3'] ?? 0.0;
    String omegaBalance = 'Omega-6 to Omega-3 balance';
    final balance = omega6 / omega3;
    if (balance.isFinite) {
      omegaBalance = "$omegaBalance: ${formatNumber(balance)} / 1";
    }

    return RatioBars(
      bars: [
        if (SettingsData.isShowCalorieDistribution)
          RatioBar(
            'Macro distribution (% calories)',
            [
              RatioBarElement(
                'Carbs',
                (intake['carbs'] ?? 0.0) * 4.0,
                _carbColor,
              ),
              RatioBarElement(
                'Fats',
                (intake['fats'] ?? 0.0) * 9.0,
                _fatColor,
              ),
              RatioBarElement(
                'Protein',
                (intake['protein'] ?? 0.0) * 4.0,
                _proteinColor,
              ),
            ],
          ),
        if (SettingsData.isShowOmegaBalance)
          RatioBar(
            omegaBalance,
            [
              RatioBarElement(
                  'Omega-6', omega6, _omega6Color.withValues(alpha: 0.8)),
              RatioBarElement('Omega-3', omega3, _omega3Color),
            ],
          ),
      ],
    );
  }
}
