import 'package:flutter/material.dart';
import 'package:live_vitalist/features/settings/data/settings_data.dart';
import 'package:live_vitalist/core/localization/domain/language_domain.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'localization_provider.g.dart';

@riverpod
class Localization extends _$Localization {
  @override
  String build() {
    var code = SettingsData.language;
    if (code == null) {
      code = WidgetsBinding.instance.platformDispatcher.locale.languageCode;
      if (!availableLanguages.containsKey(code)) {
        code = 'en';
      }
    }
    return code;
  }

  bool setLanguage(String newCode) {
    if (!availableLanguages.containsKey(newCode)) return false;
    SettingsData.language = newCode;
    state = newCode;
    return true;
  }
}
