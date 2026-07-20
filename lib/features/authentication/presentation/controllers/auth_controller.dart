import 'package:live_vitalist/features/aliment/data/aliment_bank.dart';
import 'package:live_vitalist/features/nutrient/data/nutrient_provider.dart';
import 'package:live_vitalist/features/settings/data/settings_data.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_controller.g.dart';

enum AuthorizationEnum {
  required,
  accepted,
}

@riverpod
class AuthController extends _$AuthController {
  @override
  Future<AuthorizationEnum> build() async {
    if (!SettingsData.isLoggedIn) return AuthorizationEnum.required;
    return _enter();
  }

  Future<AuthorizationEnum> _enter() async {
    await ref.read(nutrientsProvider.notifier).load();
    await ref.read(alimentBankProvider.notifier).load();
    return AuthorizationEnum.accepted;
  }

  Future<void> accept() async {
    SettingsData.isLoggedIn = true;

    if (ref.mounted) {
      state = const AsyncLoading();
      state = await AsyncValue.guard(() => _enter());
    }
  }
}
