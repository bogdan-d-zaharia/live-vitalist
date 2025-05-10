import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:live_vitalist/aliment/aliment_bank_provider.dart';
import 'package:live_vitalist/day/day_provider.dart';
import 'aliment/aliment.dart';
import 'custom_card.dart';
import 'day/day.dart';
import 'nutrient/nutrient.dart';
import 'nutrient/nutrient_provider.dart';
import 'palette.dart';
import 'settings_data.dart';
import 'string_input.dart';
import 'icon_button.dart';

class NutrientDisplay extends ConsumerStatefulWidget {
  const NutrientDisplay({super.key});

  @override
  ConsumerState<NutrientDisplay> createState() => _NutrientDisplayState();
}

class _NutrientDisplayState extends ConsumerState<NutrientDisplay> {
  bool isEditMode = false;
  String newNutriKey = '';

  @override
  Widget build(BuildContext context) {
    final nutrientState = ref.watch(nutrientStateProvider);
    final NutrientStateNotifier nutrientNotifier =
        ref.read(nutrientStateProvider.notifier);

    return isEditMode
        ? _buildEditMode(context, nutrientState, nutrientNotifier)
        : _buildViewMode(context, nutrientState);
  }

  Widget _buildViewMode(BuildContext context, NutrientState state) {
    final days = ref.watch(cachedSelectedDaysProvider);
    final bank = ref.watch(alimentBankProvider);

    final avgDay = Day.sumDays(days);
    final intake = avgDay.readIntake(bank);
    final numDays = days.length;

    final keys = _filteredAndSortedKeys(state, intake, numDays);
    final widgets = keys.map((key) {
      final field = state.data[key]!;
      final value = (intake[key] ?? 0.0) / numDays;
      return _buildNutrientTile(context, field, key, value, bank, numDays);
    }).toList();

    return CustomCard(
      logo: const Icon(Icons.bar_chart_rounded),
      title: 'Nutrients',
      action: _buildActionButtons(),
      child: Column(
        children: _insertDividers(widgets),
      ),
    );
  }

  Widget _buildEditMode(BuildContext context, NutrientState state,
      NutrientStateNotifier nutrientNotifier) {
    final widgets = state.order.map((key) {
      final field = state.data[key]!;
      final label = field.translations[SettingsData.language]!;
      final unit = field.unit;
      final lower = field.lowerLimit;
      final upper = field.upperLimit;

      return InkWell(
        key: ValueKey(key),
        onTap: () async {
          final fields = {
            'Label': label,
            'Upper limit': upper,
            'Lower limit': lower,
            'Unit': unit,
          };

          final isModified = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Scaffold(
                appBar: AppBar(
                  title: Palette.dimParentheses(
                      label, Theme.of(context).textTheme.headlineSmall),
                ),
                body: FieldsInput(fields: fields),
              ),
            ),
          );

          if (isModified) {
            final updated = field.copyWith(
              unit: fields['Unit'] as String,
              lowerLimit: fields['Lower limit'] as double?,
              upperLimit: fields['Upper limit'] as double?,
              translations: {
                ...field.translations,
                SettingsData.language: fields['Label'] as String,
              },
            );

            nutrientNotifier.update(key, updated);
          }
        },
        child: Row(
          children: [
            const Icon(Icons.drag_indicator_rounded),
            Expanded(
              child: Palette.dimParentheses(
                  label, Theme.of(context).textTheme.bodyMedium),
            ),
            Switch(
              value: !field.tags.contains('disabled'),
              onChanged: (val) {
                nutrientNotifier.toggleTag(key, 'disabled');
              },
            ),
          ],
        ),
      );
    }).toList();

    return CustomCard(
      logo: const Icon(Icons.bar_chart_rounded),
      title: 'Nutrients',
      action: _buildActionButtons(),
      child: Column(
        children: [
          ReorderableListView(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            onReorder: (oldIndex, newIndex) {
              setState(() {
                nutrientNotifier.reorder(oldIndex, newIndex);
              });
            },
            children: widgets,
          ),
          const Divider(),
          SizedBox(
            width: double.infinity,
            child: TextButton(
              onPressed: () {
                _showNewNutrientDialog(context, nutrientNotifier);
              },
              child: const Text('Add new nutrient'),
            ),
          ),
        ],
      ),
    );
  }

  List<String> _filteredAndSortedKeys(
      NutrientState state, Map<String, double> intake, int numDays) {
    List<String> keys = state.order
        .where((key) => !state.data[key]!.tags.contains('disabled'))
        .toList();

    if (SettingsData.isSmartHide) {
      keys = keys.where((key) {
        final value = (intake[key] ?? 0.0) / numDays;
        final lower = state.data[key]!.lowerLimit;
        final upper = state.data[key]!.upperLimit;
        return (lower != null && value < lower) ||
            (upper != null && value > upper * 0.9);
      }).toList();
    }

    if (SettingsData.sort != 0) {
      keys.sort((a, b) {
        final aValue = (intake[a] ?? 0.0) / numDays;
        final bValue = (intake[b] ?? 0.0) / numDays;
        final aCat = _aCat(aValue, state.data[a]!);
        final bCat = _aCat(bValue, state.data[b]!);
        return SettingsData.sort == 1
            ? _compareDescending(
                aCat, aValue, state.data[a]!, bCat, bValue, state.data[b]!)
            : _compareAscending(
                aCat, aValue, state.data[a]!, bCat, bValue, state.data[b]!);
      });
    }

    return keys;
  }

  int _aCat(double intake, Nutrient field) {
    final lower = field.lowerLimit;
    final upper = field.upperLimit;

    if (lower != null && intake < lower) return 0;
    if (upper != null && intake < upper) return 2;
    if (upper != null && intake >= upper) return 3;
    if (lower != null) return 4;
    return 5;
  }

  int _compareAscending(int catA, double intakeA, Nutrient fieldA, int catB,
      double intakeB, Nutrient fieldB) {
    if (catA != catB) return catA - catB;
    return intakeA.compareTo(intakeB);
  }

  int _compareDescending(int catA, double intakeA, Nutrient fieldA, int catB,
      double intakeB, Nutrient fieldB) {
    if (catA != catB) return catB - catA;
    return intakeB.compareTo(intakeA);
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        MyIconButton(
          onTap: () {
            setState(() {
              SettingsData.sort = SettingsData.sort == 1
                  ? -1
                  : (SettingsData.sort == -1 ? 0 : 1);
            });
          },
          icon: Icon(
            SettingsData.sort == -1
                ? Icons.keyboard_arrow_up
                : Icons.keyboard_arrow_down,
            color: SettingsData.sort != 0 ? Colors.green : null,
            size: 26.0,
          ),
        ),
        const SizedBox(width: 8),
        MyIconButton(
          onTap: () {
            setState(
                () => SettingsData.isSmartHide = !SettingsData.isSmartHide);
          },
          icon: Icon(
            Icons.select_all,
            color: SettingsData.isSmartHide ? Colors.green : null,
            size: 21.0,
          ),
        ),
        const SizedBox(width: 8),
        MyIconButton(
          onTap: () => setState(() => isEditMode = !isEditMode),
          icon: Icon(
            Icons.edit,
            color: isEditMode ? Colors.green : null,
            size: 21.0,
          ),
        ),
      ],
    );
  }

  Widget _buildNutrientTile(BuildContext context, Nutrient field, String key,
      double intake, AlimentBankState bank, int numDays) {
    final label = field.translations[SettingsData.language]!;
    final unit = field.unit;
    final lower = field.lowerLimit;
    final upper = field.upperLimit;

    final topAliments = Day.sumDays([Day()]) // Placeholder fallback
        .topIntakeAliments(key, bank)
        .map((a, v) => MapEntry(a, v / numDays));

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(8.0),
        clipBehavior: Clip.hardEdge,
        child: InkWell(
          onTap: () => _showDetailDialog(
              context, label, intake, lower, upper, topAliments),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 6.0),
            child: NutrientBar(
              label: label,
              unit: unit,
              amount: intake,
              lowerLimit: lower,
              upperLimit: upper,
            ),
          ),
        ),
      ),
    );
  }

  void _showDetailDialog(
    BuildContext context,
    String label,
    double intake,
    double? lower,
    double? upper,
    Map<Aliment, double> topSources,
  ) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('$label Intake'),
        content: ListView(
          shrinkWrap: true,
          children: [
            Text('Amount: ${intake.toStringAsFixed(2)}'),
            if (lower != null) Text('Lower Limit: ${lower.toStringAsFixed(2)}'),
            if (upper != null) Text('Upper Limit: ${upper.toStringAsFixed(2)}'),
            const Divider(),
            const Text('Top Sources:'),
            for (final entry in topSources.entries)
              Text(
                  '${entry.key.readDataRef(ref.read(alimentBankProvider)).name}: '
                  '${entry.value.toStringAsFixed(2)}'),
          ],
        ),
      ),
    );
  }

  List<Widget> _insertDividers(List<Widget> widgets) {
    final divided = <Widget>[];
    for (int i = 0; i < widgets.length; i++) {
      divided.add(widgets[i]);
      if (i < widgets.length - 1) {
        divided.add(Divider(
          color: Colors.black.withOpacity(0.1),
          thickness: 0.5,
          height: 0.0,
        ));
      }
    }
    return divided;
  }

  void _showNewNutrientDialog(
      BuildContext context, NutrientStateNotifier notifier) {
    showDialog(
      context: context,
      builder: (_) => Dialog(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Expanded(
            child: StringInput(
              initString: 'new_nutrient_key',
              submit: (newKey) {
                final key = newKey.trim();
                if (key.isEmpty) return;

                final newNutrient = Nutrient(
                  unit: 'g',
                  lowerLimit: null,
                  upperLimit: null,
                  tags: [],
                  translations: {SettingsData.language: key},
                );

                notifier.addNutrient(key, newNutrient);
                Navigator.pop(context);
              },
            ),
          ),
        ),
      ),
    );
  }
}

class NutrientBar extends StatelessWidget {
  const NutrientBar({
    required this.label,
    required this.unit,
    required this.amount,
    this.lowerLimit,
    this.upperLimit,
    this.icon,
    super.key,
  });

  final String label;
  final String unit;
  final double amount;
  final double? lowerLimit;
  final double? upperLimit;
  final Widget? icon;

  /// $1 is Right, $2 is Left.
  (String?, String?) calculateRLExcessTexts({int charSpacing = 2}) {
    ///! WARNING: Wizzardry
    final String spacing = String.fromCharCodes(
        List.generate(charSpacing, (i) => ' '.codeUnitAt(0)));

    double? absoluteExcess;

    if ((lowerLimit != null) && (amount < lowerLimit!)) {
      absoluteExcess = amount - lowerLimit!;
    } else if ((upperLimit != null) && (amount > upperLimit!)) {
      absoluteExcess = amount - upperLimit!;
    }

    double? relativeExcess;

    if ((lowerLimit != null) && (amount < lowerLimit!)) {
      relativeExcess = absoluteExcess! / lowerLimit!;
    } else if ((upperLimit != null) && (amount > upperLimit!)) {
      relativeExcess = absoluteExcess! / upperLimit!;
    }

    double? remaining;

    if (absoluteExcess == null && upperLimit != null) {
      remaining = upperLimit! - amount;
    }

    String? rightText;
    if (absoluteExcess != null) {
      rightText =
          '${absoluteExcess > 0 ? '+' : ''}${absoluteExcess.toStringAsFixed(1)} $unit$spacing';
    }
    if (remaining != null) {
      rightText = '${(remaining).toStringAsFixed(2)} $unit$spacing';
    }

    String? leftText;
    if (relativeExcess != null) {
      leftText =
          '$spacing${relativeExcess > 0 ? '+' : ''}${(relativeExcess * 100.0).toStringAsFixed(1)}%';
    }

    /// TODO: Maybe 0% -> 'lowerLimit'; 100% -> 'upperLimit'
    /// if (remaining != null) {
    ///   leftText = '${(remaining).toStringAsFixed(2)} $unit ';
    /// }

    (String?, String?) output = (rightText, leftText);

    return output;
  }

  Widget bar(BuildContext context,
      {double height = 15.0, double radius = 5.0, double fontSize = 12.0}) {
    if (lowerLimit == null && upperLimit == null) {
      return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(radius),
          color: Colors.grey,
        ),
        height: height,
      );
    } else {
      final double top = (upperLimit ?? lowerLimit!) * 1.5;
      final (String? rightText, String? leftText) =
          calculateRLExcessTexts(charSpacing: 3);

      /// TODO: Make reach corners round.
      return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(radius),
          color: Colors.orange,
        ),
        clipBehavior: Clip.antiAlias,
        height: height,
        child: Stack(
          alignment: Alignment.topLeft,
          fit: StackFit.expand,
          children: [
            FractionallySizedBox(
              alignment: Alignment.topLeft,
              widthFactor: (upperLimit ?? top) / top,
              child: Container(color: Colors.green),
            ),
            FractionallySizedBox(
              alignment: Alignment.topLeft,
              widthFactor: (lowerLimit ?? 0.0) / top,
              child: Container(color: Colors.lightGreen),
            ),
            FractionallySizedBox(
              alignment: Alignment.topRight,
              widthFactor: 1.0 - (amount.clamp(0.0, top) / top),
              child: Container(
                  color: (Palette.isDarkMode(context)
                          ? Colors.black
                          : Colors.white)
                      .withValues(alpha: 0.7)),
            ),
            if (rightText != null)
              Align(
                alignment: Alignment.centerRight,
                child: Text(
                  rightText,
                  style: Palette.dayViewRegular.copyWith(
                    fontSize: fontSize,
                    color: Colors.black.withValues(alpha: 0.6),
                  ),
                ),
              ),
            if (leftText != null)
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  leftText,
                  style: Palette.dayViewRegular.copyWith(
                    fontSize: fontSize,
                    color: Colors.black.withValues(alpha: 0.6),
                  ),
                ),
              ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Palette.dimParentheses(
                label, Theme.of(context).textTheme.bodyMedium),
            if (icon != null) icon!,
            if (icon != null) SizedBox(width: 4.0),
            Spacer(),
            Center(
              child: Text('${amount.toStringAsFixed(2)} $unit',
                  style: TextStyle(letterSpacing: -0.0)),
            ),
          ],
        ),
        SizedBox(height: 5.0),
        bar(context, height: 12.0, radius: 6.0, fontSize: 11.0),
      ],
    );
  }
}
