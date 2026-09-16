import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:live_vitalist/features/nutrient/presentation/widgets/nutrient_async_status.dart';
import 'package:live_vitalist/core/localization/localization_provider.dart';
import 'package:live_vitalist/features/aliment/data/aliment_data_extensions.dart';
import 'package:live_vitalist/l10n/app_localizations.dart';
import 'package:live_vitalist/features/aliment/domain/aliment_data.dart';
import 'package:live_vitalist/features/aliment_editor/aliment_data_editor/presentation/widgets/editor_inputs/editor_string_input.dart';
import 'package:live_vitalist/features/aliment_editor/aliment_data_editor/presentation/widgets/editor_inputs/nutrient_input.dart';
import 'package:live_vitalist/features/aliment_editor/aliment_data_editor/presentation/widgets/food_image_picker.dart';
import 'package:live_vitalist/features/aliment_editor/aliment_data_editor/presentation/widgets/json_editor_button.dart';
import 'package:live_vitalist/features/aliment_editor/aliment_data_editor/presentation/widgets/save_alert.dart';
import 'package:live_vitalist/features/nutrient/data/nutrient_provider.dart';

class TemporaryAlimentEditor extends ConsumerStatefulWidget {
  final AlimentData initialData;

  const TemporaryAlimentEditor({required this.initialData, super.key});

  @override
  ConsumerState<TemporaryAlimentEditor> createState() =>
      _TemporaryAlimentEditorState();
}

class _TemporaryAlimentEditorState
    extends ConsumerState<TemporaryAlimentEditor> {
  AlimentData data = AlimentData.empty;

  late final String languageCode;
  late final TextEditingController _nameController;
  late bool _imageWasManuallySelected;

  String get dataName => data.readName(languageCode);

  @override
  void initState() {
    super.initState();
    data = AlimentData.fromJson(widget.initialData.toJson());
    languageCode = ref.read(localizationProvider);
    _nameController = TextEditingController(text: dataName);
    _imageWasManuallySelected = data.image != null;
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  bool get isModified =>
      jsonEncode(data.toJson()) != jsonEncode(widget.initialData.toJson());

  void _popSave() => Navigator.pop(context, data);
  void _popCancel() => Navigator.pop(context, null);

  Future<bool?> _showSaveAlert(BuildContext context) {
    return showDialog<bool>(
      context: context,
      builder: (context) => SaveAlert(),
    );
  }

  Future<void> _confirmPop() async {
    if (!isModified) return _popCancel();

    final shouldSave = await _showSaveAlert(context);
    if (shouldSave == true) {
      _popSave();
    } else if (shouldSave == false) {
      _popCancel();
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final nutrientAsync = ref.watch(nutrientsProvider);
    if (nutrientAsync.isLoading ||
        nutrientAsync.hasError ||
        !nutrientAsync.hasValue) {
      return NutrientAsyncStatus(value: nutrientAsync);
    }
    final nutrients = nutrientAsync.requireValue;
    final selectedNutrients = nutrients.order.where((key) =>
        key != 'kcals' && !nutrients.data[key]!.tags.contains('disabled'));

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) _confirmPop();
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(l.alimentEditorTitle),
          actions: [
            JsonEditorButton(
              data: data,
              languageCode: languageCode,
              onResult: (newData) {
                setState(() {
                  data = newData;
                  _imageWasManuallySelected = newData.image != null;
                  _nameController.text = dataName;
                });
              },
            ),
          ],
        ),
        body: GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
          child: SafeArea(
            top: false,
            child: Column(
              children: [
                Expanded(
                  child: ListView(
                    padding: EdgeInsets.symmetric(horizontal: 24.0),
                    children: [
                      FoodImagePicker(
                        selectedKey: data.image,
                        fallbackName: dataName,
                        onChanged: (image) {
                          setState(() {
                            _imageWasManuallySelected = true;
                            data = data.copyWith(image: image);
                          });
                        },
                      ),
                      EditorStringInput(
                        l.alimentEditorName,
                        dataName,
                        (value) {
                          final suggestedImage = _imageWasManuallySelected
                              ? data.image
                              : suggestFoodImageForName(value)?.key;
                          setState(() {
                            data = data.copyWith(
                              name: {
                                ...data.name,
                                languageCode: value,
                              },
                              image: suggestedImage,
                            );
                          });
                        },
                        _nameController,
                        icon: Icons.restaurant_menu_rounded,
                      ),
                      NutrientInput('kcals', nutrients, data),
                      ...selectedNutrients.map(
                        (key) => NutrientInput(key, nutrients, data),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
                  child: SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      onPressed: _popSave,
                      child: Text(l.actionSave),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
