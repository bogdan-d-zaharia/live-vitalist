import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:live_vitalist/aliment/data/aliment_bank.dart';
import 'package:live_vitalist/day/data/day_provider.dart';
import 'package:live_vitalist/day/domain/day_extensions.dart';
import 'package:live_vitalist/core/theme/palette.dart';
import 'package:live_vitalist/ratio_bars/presentation/widgets/ratio_bars.dart';
import 'package:live_vitalist/ratio_bars/presentation/widgets/ratio_bars_models.dart';
import 'package:live_vitalist/settings/data/settings_data.dart';

class RatioBarsCard extends ConsumerWidget {
  const RatioBarsCard({super.key});

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
        RatioBar(
          'Macro distribution (% calories)',
          [
            RatioBarElement(
              'Carbs',
              (intake['carbs'] ?? 0.0) * 4.0,
              Palette.carbBlue,
            ),
            RatioBarElement(
              'Fats',
              (intake['fats'] ?? 0.0) * 9.0,
              Palette.fatYellow,
            ),
            RatioBarElement(
              'Protein',
              (intake['protein'] ?? 0.0) * 4.0,
              Palette.proteinRed,
            ),
          ],
        ),
        if (SettingsData.isShowOmegaBalance)
          RatioBar(
            omegaBalance,
            [
              RatioBarElement(
                  'Omega-6', omega6, Colors.purple.withValues(alpha: 0.8)),
              RatioBarElement('Omega-3', omega3, Colors.orange),
            ],
          ),
      ],
    );
  }
}
