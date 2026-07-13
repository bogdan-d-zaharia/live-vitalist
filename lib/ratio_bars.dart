import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:live_vitalist/day/domain/day_extensions.dart';

import 'aliment/data/aliment_bank.dart';
import 'core/presentation/widgets/custom_card.dart';
import 'day/data/day_provider.dart';
import 'labels_widget.dart';
import 'palette.dart';
import 'settings_data.dart';

class RatioBarElement {
  const RatioBarElement(
    this.label,
    this.amount,
    this.color,
  );

  final String label;
  final double amount;
  final Color color;
}

class RatioBar {
  const RatioBar(
    this.text,
    this.elements,
  );

  final String text;
  final List<RatioBarElement> elements;
}

class Bar extends StatelessWidget {
  const Bar({
    super.key,
    required this.elements,
    this.height = 12.0,
    this.radius = 7.0,
    this.fontSize = 11.0,
  });

  final List<RatioBarElement> elements;
  final double height;
  final double radius;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    final double total =
        elements.map((e) => e.amount).fold(0.0, (a, b) => a + b);
    if (total == 0.0) {
      return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(radius),
          color: Colors.grey,
        ),
        height: height,
      );
    } else {
      return Container(
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(radius)),
        clipBehavior: Clip.antiAlias,
        height: height,
        child: Row(
          children: elements.map(
            (e) {
              final s = '${(e.amount * 100.0 / total).toStringAsFixed(0)}%';
              return Expanded(
                flex: (e.amount * 1e3).round(),
                child: Container(
                  color: e.color,
                  child: switch (s != '0%') {
                    true => Center(
                        child: Text(
                          s,
                          style: Palette.dayViewRegular.copyWith(
                            fontSize: fontSize,
                            color: Colors.black.withValues(alpha: 0.6),
                          ),
                        ),
                      ),
                    false => null,
                  },
                ),
              );
            },
          ).toList(),
        ),
      );
    }
  }
}

class RatioBars extends StatelessWidget {
  const RatioBars({
    required this.bars,
    super.key,
  });

  final List<RatioBar> bars;

  @override
  Widget build(BuildContext context) {
    final List<dynamic> barWids = [
      for (var bar in bars)
        [
          Text(bar.text),
          SizedBox(height: 4.0),
          Bar(elements: bar.elements),
          SizedBox(height: 4.0),
          Row(
              children: LabelsWidget.labels(Map.fromEntries(
                      bar.elements.map((e) => MapEntry(e.label, e.color))))
                  .map((e) => Flexible(child: e))
                  .toList()),
        ]
    ];

    for (var i = barWids.length - 1; i > 0; --i) {
      barWids.insert(i, SizedBox(height: 20.0));
    }

    final List<Widget> children = [
      for (var a in barWids)
        if (a is List) ...a else a
    ];

    return CustomCard(
      logo: Icon(Icons.stacked_bar_chart_rounded),
      title: 'Distribution Bars',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children,
      ),
    );
  }
}

class ConsumerRatioBars extends ConsumerWidget {
  const ConsumerRatioBars({super.key});

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
