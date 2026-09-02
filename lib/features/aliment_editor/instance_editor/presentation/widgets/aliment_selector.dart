import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:live_vitalist/l10n/app_localizations.dart';
import 'package:diacritic/diacritic.dart';

import 'package:live_vitalist/features/aliment_bank/data/aliment_bank.dart';
import 'package:live_vitalist/features/aliment_editor/instance_editor/presentation/widgets/add_aliment_button.dart';
import 'package:live_vitalist/features/aliment_editor/instance_editor/presentation/widgets/selector_search_bar.dart';
import 'package:live_vitalist/features/aliment_editor/aliment_data_editor/presentation/widgets/food_image_picker.dart';
import 'package:live_vitalist/core/presentation/widgets/mini_card.dart';

class Selector extends ConsumerStatefulWidget {
  const Selector({super.key});
  @override
  ConsumerState<Selector> createState() => _SelectorState();
}

class _SelectorState extends ConsumerState<Selector> {
  final TextEditingController controller = TextEditingController();
  String searchTerm = '';

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final bank = ref.watch(alimentBankProvider);
    final notifier = ref.read(alimentBankProvider.notifier);

    final filteredKeys = bank.order.where((id) {
      final name = bank.aliments[id]!.name;
      return removeDiacritics(name.toLowerCase())
          .contains(removeDiacritics(searchTerm.toLowerCase()));
    }).toList();

    return MiniCard(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 12.0),
        child: Column(
          children: [
            Row(
              children: [
                BackButton(),
                Text(l.alimentEditorSelectorTitle,
                    style: TextStyle(fontSize: 20.0)),
              ],
            ),
            SelectorSearchBar(
              controller: controller,
              onChanged: (text) {
                if (text != searchTerm) {
                  setState(() => searchTerm = text);
                }
              },
            ),
            AddAlimentButton(
              notifier: notifier,
              onAdded: () => setState(() {}),
            ),
            Divider(
              height: 24.0,
              color: Theme.of(context).dividerColor,
            ),
            Expanded(
              child: ListView(
                children: filteredKeys.map((id) {
                  final aliment = bank.aliments[id]!;
                  return _AlimentTile(
                    name: aliment.name,
                    imageKey: aliment.image,
                    onTap: () => Navigator.pop(context, id),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AlimentTile extends StatelessWidget {
  const _AlimentTile({
    required this.name,
    required this.imageKey,
    required this.onTap,
  });

  final String name;
  final String? imageKey;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return MiniCard(
      child: Semantics(
        button: true,
        label: name,
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(10.0, 10.0, 14.0, 10.0),
            child: Row(
              children: [
                FoodImageThumbnail(
                  imageKey: imageKey,
                  fallbackName: name,
                  size: 56.0,
                ),
                const SizedBox(width: 14.0),
                Expanded(
                  child: Text(
                    name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      height: 1.15,
                    ),
                  ),
                ),
                const SizedBox(width: 8.0),
                Icon(
                  Icons.chevron_right_rounded,
                  size: 22.0,
                  color: colors.onSurfaceVariant.withValues(alpha: 0.65),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
