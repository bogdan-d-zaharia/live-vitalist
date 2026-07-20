import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:live_vitalist/core/presentation/widgets/custom_icon_button.dart';
import 'package:live_vitalist/features/nutrient_display/presentation/controllers/nutrient_display_controller.dart';
import 'package:live_vitalist/features/settings/data/settings_data.dart';

class ActionButtons extends ConsumerWidget {
  const ActionButtons({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(nutrientDisplayControllerProvider);
    final notifier = ref.read(nutrientDisplayControllerProvider.notifier);

    return Row(
      children: [
        CustomIconButton(
          onTap: notifier.circleSort,
          icon: Icon(
            SettingsData.sort == -1
                ? Icons.keyboard_arrow_up
                : Icons.keyboard_arrow_down,
            color: SettingsData.sort != 0 ? Colors.green : null,
            size: 26.0,
          ),
        ),
        const SizedBox(width: 8),
        CustomIconButton(
          onTap: notifier.toggleSmartHide,
          icon: Icon(
            Icons.select_all,
            color: SettingsData.isSmartHide ? Colors.green : null,
            size: 21.0,
          ),
        ),
        const SizedBox(width: 8),
        CustomIconButton(
          onTap: notifier.toggleEditMode,
          icon: Icon(
            Icons.edit,
            color: state.isEditMode ? Colors.green : null,
            size: 21.0,
          ),
        ),
      ],
    );
  }
}
