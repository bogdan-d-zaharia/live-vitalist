import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:live_vitalist/core/localization/domain/language_domain.dart';
import 'package:live_vitalist/core/localization/localization_provider.dart';

// TODO: Add `Automatic` for SettingsData.language == null

class LanguageDropdown extends ConsumerWidget {
  const LanguageDropdown({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final code = ref.watch(localizationProvider);

    return DropdownMenu<String>(
      key: ValueKey(code),
      expandedInsets: EdgeInsets.zero,
      initialSelection: code,
      dropdownMenuEntries: availableLanguages.entries
          .map((kv) => DropdownMenuEntry(value: kv.key, label: kv.value))
          .toList(),
      onSelected: (newCode) {
        if (newCode == null) return;
        ref.read(localizationProvider.notifier).setLanguage(newCode);
      },
    );
  }
}
