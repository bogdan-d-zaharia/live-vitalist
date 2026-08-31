import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:live_vitalist/l10n/app_localizations.dart';
import 'package:live_vitalist/features/aliment/data/aliment_bank.dart';
import 'package:live_vitalist/features/aliment/domain/aliment.dart';
import 'package:live_vitalist/core/presentation/widgets/custom_card.dart';
import 'package:live_vitalist/features/day/data/day_provider.dart';
import 'package:live_vitalist/features/day/presentation/meal_localizations.dart';
import 'package:live_vitalist/features/meals_journal/presentation/aliment_editing_extensions.dart';
import 'package:live_vitalist/features/meals_journal/presentation/widgets/aliment_widget.dart';
import 'package:live_vitalist/features/meals_journal/presentation/widgets/custom_divider.dart';
import 'package:live_vitalist/features/meals_journal/presentation/widgets/element_widget.dart';
import 'package:live_vitalist/features/notifications/notification_handler.dart';
import 'package:live_vitalist/features/super_search/presentation/utils/super_search_navigation.dart';

class MealEditor extends ConsumerWidget {
  const MealEditor({
    required this.mealKey,
    required this.date,
    super.key,
  });

  final String mealKey;
  final DateTime date;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final day = ref.watch(dayCacheProvider)[date]!;
    final dayNotifier = ref.read(dayCacheProvider.notifier);
    final meal = day.meals.firstWhere((m) => m.key == mealKey);
    final bank = ref.watch(alimentBankProvider);
    final bankNotifier = ref.read(alimentBankProvider.notifier);

    Widget alimentToWidget(Aliment aliment) {
      return AlimentWidget(
        aliment: aliment,
        deleteAliment: () {
          dayNotifier.removeAliment(date, mealKey, aliment);
        },
        onTap: () async {
          final newAliment = await aliment.pushEditingScreen(context);
          if (newAliment != null) {
            dayNotifier.updateAliment(date, mealKey, aliment, newAliment);
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
            final newTemp = await aliment.pushEditingScreen(context);
            if (newTemp != null) {
              dayNotifier.updateAliment(date, mealKey, aliment, newTemp);
            }
          }
        },
      );
    }

    final addInstanced = ElementWidget(
      title: l.mealsJournalAddAliment,
      subTitle: '',
      onTap: () => SuperSearchNavigation.open(context, ref,
          date: date, mealName: meal.key),
      additional: [],
    );

    final addTemporary = ElementWidget(
      title: l.mealsJournalAddTemporaryAliment,
      subTitle: '',
      onTap: () async {
        final TemporaryAliment? newAliment =
            await TemporaryAliment.empty.pushEditingScreen(context);

        if (newAliment != null) {
          dayNotifier.addAliment(date, mealKey, newAliment);
        }
      },
      additional: [],
    );

    final List<Widget> elements = [
      ...meal.aliments.map(alimentToWidget),
      addInstanced,
      addTemporary,
    ].expand((element) => [element, CustomDivider()]).toList()
      ..removeLast();

    return Scaffold(
      appBar: AppBar(
        title: Text(meal.displayName(l)),
        actions: [
          TextButton(
            onPressed: () => NotificationHandler.showListNotification(
                meal.aliments, bank, meal.displayName(l), l),
            child: Text(l.mealsJournalShowNotification),
          ),
          SizedBox(width: 12.0),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: ListView(
          children: [
            CustomCard(
              title: l.mealsJournalAliments,
              child: Column(children: elements),
            ),
            SizedBox(height: 12.0),
          ],
        ),
      ),
    );
  }
}
