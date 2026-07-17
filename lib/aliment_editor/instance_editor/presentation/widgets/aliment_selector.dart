import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:diacritic/diacritic.dart';

import 'package:live_vitalist/aliment/data/aliment_bank.dart';
import 'package:live_vitalist/aliment_editor/instance_editor/widgets/add_aliment_button.dart';
import 'package:live_vitalist/aliment_editor/instance_editor/widgets/selector_search_bar.dart';
import 'package:live_vitalist/core/presentation/widgets/mini_card.dart';
import 'package:live_vitalist/core/theme/palette.dart';

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
              children: const [
                BackButton(),
                Text('Aliment Selector', style: TextStyle(fontSize: 20.0)),
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
            const Divider(height: 24.0, color: Palette.divGrey),
            Expanded(
              child: ListView(
                children: filteredKeys.map((id) {
                  final name = bank.aliments[id]!.name;
                  return MiniCard(
                    child: InkWell(
                      onTap: () => Navigator.pop(context, id),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16.0, vertical: 12.0),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(name),
                        ),
                      ),
                    ),
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
