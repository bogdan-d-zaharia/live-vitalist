import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:live_vitalist/aliment/data/aliment_bank.dart';
import 'package:live_vitalist/aliment/domain/aliment.dart';
import 'package:live_vitalist/core/presentation/widgets/custom_card.dart';
import 'package:live_vitalist/day/data/day_provider.dart';
import 'package:live_vitalist/meals_journal/presentation/aliment_editing_extensions.dart';
import 'package:live_vitalist/meals_journal/presentation/widgets/aliment_widget.dart';
import 'package:live_vitalist/meals_journal/presentation/widgets/element_widget.dart';
import 'package:live_vitalist/notification_handler.dart';
import 'package:live_vitalist/palette.dart';
import 'package:live_vitalist/settings/data/settings_data.dart';

class MealEditor extends ConsumerWidget {
  const MealEditor({
    required this.mealName,
    required this.date,
    super.key,
  });

  final String mealName;
  final DateTime date;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final day = ref.watch(dayCacheProvider)[date]!;
    final dayNotifier = ref.read(dayCacheProvider.notifier);
    final meal = day.meals.firstWhere((m) => m.name == mealName);
    final bank = ref.watch(alimentBankProvider);
    final bankNotifier = ref.read(alimentBankProvider.notifier);

    Widget alimentToWidget(Aliment aliment) {
      return AlimentWidget(
        aliment: aliment,
        deleteAliment: () {
          dayNotifier.removeAliment(date, mealName, aliment);
        },
        onTap: () async {
          final newAliment = await aliment.pushEditingScreen(context);
          if (newAliment != null) {
            dayNotifier.updateAliment(date, mealName, aliment, newAliment);
          }
        },
        onLongPress: () async {
          if (aliment is InstancedAliment) {
            final newData =
                await aliment.readDataRef(bank).pushEditingScreen(context);
            if (newData != null) {
              bankNotifier.setAliment(aliment.alimentID, newData);
            }
          } else if (aliment is TemporaryAliment) {
            final newData =
                await aliment.alimentData.pushEditingScreen(context);
            if (newData != null) {
              dayNotifier.updateAliment(date, mealName, aliment,
                  aliment.copyWith(alimentData: newData));
            }
          }
        },
      );
    }

    final addInstanced = ElementWidget(
      title: {
        'ENG': 'Add aliment',
        'ROU': 'Adaugare aliment',
      }[SettingsData.language]!,
      subTitle: '',
      onTap: () async {
        final newAliment =
            await InstancedAliment.empty.pushEditingScreen(context);

        if (newAliment != null && newAliment.alimentID != '') {
          dayNotifier.addAliment(date, mealName, newAliment);
        }
      },
      additional: [],
    );

    final addTemporary = ElementWidget(
      title: {
        'ENG': 'Add temporary aliment',
        'ROU': 'Adaugare aliment temporar',
      }[SettingsData.language]!,
      subTitle: '',
      onTap: () async {
        final TemporaryAliment? newAliment =
            await TemporaryAliment.empty.pushEditingScreen(context);

        if (newAliment != null) {
          dayNotifier.addAliment(date, mealName, newAliment);
        }
      },
      additional: [],
    );

    final Widget divider = Divider(
      color: Palette.divGrey,
      thickness: 0.5,
      height: 0.0,
    );

    final List<Widget> elements = [
      ...meal.aliments.map(alimentToWidget),
      addInstanced,
      addTemporary,
    ].expand((element) => [element, divider]).toList()
      ..removeLast();

    return Scaffold(
      appBar: AppBar(
        title: Text(mealName),
        actions: [
          TextButton(
            onPressed: () => NotificationHandler.showListNotification(
                meal.aliments, bank, mealName),
            child: Text('Show Notification'),
          ),
          SizedBox(width: 12.0),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: ListView(
          children: [
            CustomCard(
              title: 'Aliments',
              child: Column(children: elements),
            ),
            SizedBox(height: 12.0),
          ],
        ),
      ),
    );
  }
}
