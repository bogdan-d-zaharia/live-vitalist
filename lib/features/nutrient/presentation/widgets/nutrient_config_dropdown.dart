import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:live_vitalist/core/presentation/widgets/custom_alert_dialog.dart';
import 'package:live_vitalist/core/theme/app_menu_button_theme.dart';
import 'package:live_vitalist/core/presentation/widgets/long_press_action_menu.dart';
import 'package:live_vitalist/features/day/data/day_provider.dart';
import 'package:live_vitalist/features/nutrient/data/nutrient_provider.dart';
import 'package:live_vitalist/features/nutrient/domain/nutrient_config_header.dart';
import 'package:live_vitalist/features/nutrient/presentation/ui_helpers/nutrient_config_labels.dart';
import 'package:live_vitalist/l10n/app_localizations.dart';

enum _ActionType { select, rename, duplicate, add, remove }

class _ConfigAction {
  final _ActionType type;
  final NutrientConfigHeader? header;

  const _ConfigAction(this.type, [this.header]);
}

class NutrientConfigDropdown extends ConsumerStatefulWidget {
  const NutrientConfigDropdown({super.key});

  @override
  ConsumerState<NutrientConfigDropdown> createState() =>
      _NutrientConfigDropdownState();
}

class _NutrientConfigDropdownState
    extends ConsumerState<NutrientConfigDropdown> {
  bool _busy = false;
  final _menuKey = GlobalKey<PopupMenuButtonState<_ConfigAction>>();

  Future<void> _apply(_ConfigAction action, List<DateTime> dates) async {
    final l = AppLocalizations.of(context);
    setState(() => _busy = true);
    try {
      final configs = ref.read(nutrientConfigsListProvider.notifier);
      String? id;
      switch (action.type) {
        case _ActionType.remove:
          final confirmed = await showDialog<bool>(
            context: context,
            builder: (dialogContext) => CustomAlertDialog(
              icon: Icon(Icons.delete_outline_rounded),
              title: Text(l.nutrientConfigDeleteTitle),
              content: Text(l.nutrientConfigDeleteConfirmation(
                nutrientConfigName(action.header!, l),
              )),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(dialogContext).pop(false),
                  child: Text(l.actionCancel),
                ),
                TextButton(
                  onPressed: () => Navigator.of(dialogContext).pop(true),
                  child: Text(l.actionDelete),
                ),
              ],
            ),
          );
          if (confirmed != true || !mounted) return;
          await configs.remove(action.header!.id);
          return;
        case _ActionType.rename:
          final header = action.header!;
          final name = await showDialog<String>(
            context: context,
            builder: (_) =>
                _RenameConfigDialog(name: nutrientConfigName(header, l)),
          );
          if (name == null || !mounted) return;
          await configs.rename(header.id, name);
          return;
        case _ActionType.duplicate:
          id = await configs.create(
            name:
                l.nutrientConfigCopyName(nutrientConfigName(action.header!, l)),
            sourceId: action.header!.id,
          );
        case _ActionType.add:
          id = await configs.create(name: l.nutrientConfigNewName);
        case _ActionType.select:
          id = action.header?.id;
      }
      if (!mounted) return;
      await ref.read(dayCacheProvider.notifier).setNutrientConfig(dates, id);
      if (id == null) return;
      await configs.use(id);
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(nutrientConfigError(error, l))),
      );
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final headers = ref.watch(nutrientConfigsListProvider);
    final selection = ref.watch(nutrientConfigSelectionProvider);
    if ((!headers.hasValue || !selection.hasValue) &&
        (headers.isLoading || selection.isLoading)) {
      return Padding(
        padding: EdgeInsets.all(12.0),
        child: SizedBox(
            width: 20.0,
            height: 20.0,
            child: CircularProgressIndicator(strokeWidth: 2.0)),
      );
    }
    if (!headers.hasValue || !selection.hasValue) {
      return IconButton(
        icon: Icon(Icons.refresh_rounded),
        onPressed: () {
          ref.invalidate(nutrientConfigsListProvider);
          ref.invalidate(nutrientConfigSelectionProvider);
        },
      );
    }
    final configs = headers.requireValue;
    final selected = selection.requireValue;
    final matching = configs.where((header) => header.id == selected.id);
    final defaultName = nutrientConfigName(configs.first, l);
    final autoLabel = l.nutrientConfigAuto(defaultName);
    final label = switch (true) {
      _ when selected.isMixed => l.nutrientConfigMixed(defaultName),
      _ when selected.id == null || matching.isEmpty => autoLabel,
      _ => nutrientConfigName(matching.first, l),
    };
    final dates = [...ref.watch(selectedDatesProvider)];
    final enabled = !_busy && !headers.isLoading && !selection.isLoading;
    return PopupMenuButton<_ConfigAction>(
      key: _menuKey,
      tooltip: l.nutrientConfigTitle,
      enabled: enabled,
      position: PopupMenuPosition.under,
      clipBehavior: Clip.antiAlias,
      onSelected: (action) => _apply(action, dates),
      itemBuilder: (context) => [
        PopupMenuItem(
          value: _ConfigAction(_ActionType.select),
          child: _ConfigMenuLabel(
            label: autoLabel,
            isSelected: !selected.isMixed && selected.id == null,
          ),
        ),
        PopupMenuDivider(),
        ...configs.map((header) => PopupMenuItem<_ConfigAction>(
              value: _ConfigAction(_ActionType.select, header),
              padding: EdgeInsets.zero,
              child: Builder(
                  builder: (itemContext) => LongPressActionMenu<_ConfigAction>(
                        itemBuilder: (menuContext) => [
                          LongPressActionMenuItem(
                            context: menuContext,
                            value: _ConfigAction(_ActionType.rename, header),
                            icon: Icons.edit_rounded,
                            label: l.nutrientConfigRename,
                          ),
                          LongPressActionMenuItem(
                            context: menuContext,
                            value: _ConfigAction(_ActionType.duplicate, header),
                            icon: Icons.copy_rounded,
                            label: l.nutrientConfigDuplicate,
                          ),
                          LongPressActionMenuItem(
                            context: menuContext,
                            value: _ConfigAction(_ActionType.remove, header),
                            icon: Icons.delete_outline_rounded,
                            label: l.actionDelete,
                            enabled: configs.length > 1,
                            isDestructive: true,
                          ),
                        ],
                        onSelected: (action) =>
                            Navigator.of(itemContext).pop(action),
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 16.0, vertical: 12.0),
                          child: _ConfigMenuLabel(
                            label: nutrientConfigName(header, l),
                            isSelected:
                                !selected.isMixed && selected.id == header.id,
                          ),
                        ),
                      )),
            )),
        PopupMenuDivider(),
        PopupMenuItem(
          value: _ConfigAction(_ActionType.add),
          child: Row(children: [
            Icon(Icons.add_rounded),
            SizedBox(width: 8.0),
            Flexible(child: Text(l.nutrientConfigAdd))
          ]),
        ),
      ],
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 8.0),
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.sizeOf(context).width * 0.42,
          ),
          child: TextButton(
            style: Theme.of(context).extension<AppMenuButtonTheme>()?.style,
            onPressed:
                enabled ? () => _menuKey.currentState?.showButtonMenu() : null,
            child: Row(mainAxisSize: MainAxisSize.min, children: [
              Flexible(
                  child: Text(label,
                      maxLines: 1, overflow: TextOverflow.ellipsis)),
              SizedBox(width: 6.0),
              Icon(Icons.expand_more_rounded),
            ]),
          ),
        ),
      ),
    );
  }
}

class _ConfigMenuLabel extends StatelessWidget {
  final String label;
  final bool isSelected;

  const _ConfigMenuLabel({required this.label, required this.isSelected});

  @override
  Widget build(BuildContext context) => Row(children: [
        Expanded(
            child: Text(label, maxLines: 1, overflow: TextOverflow.ellipsis)),
        SizedBox(width: 12.0),
        SizedBox(
          width: 24.0,
          child: isSelected
              ? Icon(Icons.check_rounded,
                  color: Theme.of(context).colorScheme.primary)
              : null,
        ),
      ]);
}

class _RenameConfigDialog extends StatefulWidget {
  final String name;

  const _RenameConfigDialog({required this.name});

  @override
  State<_RenameConfigDialog> createState() => _RenameConfigDialogState();
}

class _RenameConfigDialogState extends State<_RenameConfigDialog> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.name);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _submit() {
    final name = _controller.text.trim();
    if (name.isEmpty) return;
    Navigator.of(context).pop(name);
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return AlertDialog(
      title: Text(l.nutrientConfigRename),
      content: TextField(
        controller: _controller,
        autofocus: true,
        maxLength: 80,
        textInputAction: TextInputAction.done,
        onSubmitted: (_) => _submit(),
      ),
      actions: [
        TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(l.actionCancel)),
        TextButton(onPressed: _submit, child: Text(l.actionSave)),
      ],
    );
  }
}
