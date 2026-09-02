import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:live_vitalist/l10n/app_localizations.dart';
import 'package:live_vitalist/core/presentation/widgets/animated_navigation_buttons.dart';
import 'package:live_vitalist/core/presentation/widgets/completion_widget.dart';
import 'package:live_vitalist/features/aliment/domain/aliment_data.dart';
import 'package:live_vitalist/features/aliment_editor/aliment_data_editor/presentation/screens/aliment_details_screen.dart';
import 'package:live_vitalist/features/aliment_editor/aliment_data_editor/presentation/screens/aliment_nutrients_screen.dart';
import 'package:live_vitalist/features/aliment_editor/aliment_data_editor/presentation/screens/aliment_synonyms_screen.dart';
import 'package:live_vitalist/features/aliment_editor/aliment_data_editor/presentation/widgets/save_alert.dart';
import 'package:live_vitalist/features/aliment_editor/aliment_data_editor/presentation/widgets/json_editor_button.dart';

class AlimentDataEditor extends ConsumerStatefulWidget {
  final AlimentData initialData;
  const AlimentDataEditor({required this.initialData, super.key});

  @override
  ConsumerState<AlimentDataEditor> createState() => _AlimentDataEditorState();
}

class _AlimentDataEditorState extends ConsumerState<AlimentDataEditor> {
  AlimentData data = AlimentData.empty;

  late final TextEditingController _nameController;
  late final TextEditingController _unitController;
  late bool _imageWasManuallySelected;
  final PageController _pageController = PageController();
  int _pageIndex = 0;

  static const _pageCount = 3;

  @override
  void initState() {
    super.initState();
    data = AlimentData.fromJson(widget.initialData.toJson());
    _imageWasManuallySelected = data.image != null;
    _nameController = TextEditingController();
    _unitController = TextEditingController();
    _updateControllers();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _unitController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  void _updateControllers() {
    _nameController.text = data.name;
    _unitController.text = data.unit;
  }

  bool get isModified =>
      jsonEncode(data.toJson()) != jsonEncode(widget.initialData.toJson());

  void _popSave() => Navigator.pop(context, data);
  void _popCancel() => Navigator.pop(context, null);

  void _setPage(int index) {
    FocusManager.instance.primaryFocus?.unfocus();
    setState(() => _pageIndex = index);
    _pageController.animateToPage(
      index,
      duration: Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  void _nextPage() {
    if (_pageIndex == _pageCount - 1) {
      _popSave();
    } else {
      _setPage(_pageIndex + 1);
    }
  }

  void _previousPage() => _setPage(_pageIndex - 1);

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
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (didPop) return;
        if (_pageIndex > 0) {
          _previousPage();
        } else {
          _confirmPop();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(AppLocalizations.of(context).alimentEditorTitle),
          actions: [
            JsonEditorButton(
              data: data,
              onResult: (newData) {
                setState(() {
                  data = newData;
                  _imageWasManuallySelected = newData.image != null;
                  _updateControllers();
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
                Padding(
                  padding: EdgeInsets.all(16.0),
                  child: SizedBox(
                    width: 128.0,
                    height: 6.0,
                    child: CompletionWidget(
                      count: _pageCount,
                      index: _pageIndex,
                    ),
                  ),
                ),
                Expanded(
                  child: PageView(
                    controller: _pageController,
                    physics: NeverScrollableScrollPhysics(),
                    children: [
                      AlimentDetailsScreen(
                        data: data,
                        nameController: _nameController,
                        unitController: _unitController,
                        imageWasManuallySelected: _imageWasManuallySelected,
                        onImageSelected: (image) {
                          setState(() {
                            _imageWasManuallySelected = true;
                            data = data.copyWith(image: image);
                          });
                        },
                        onDataChanged: (newData) {
                          setState(() => data = newData);
                        },
                      ),
                      AlimentNutrientsScreen(data: data),
                      AlimentSynonymsScreen(
                        data: data,
                        onDataChanged: (newData) {
                          setState(() => data = newData);
                        },
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
                  child: AnimatedNavigationButtons(
                    onNext: _nextPage,
                    onPrevious: _pageIndex > 0 ? _previousPage : null,
                    onSkip: _popSave,
                    nextLabel:
                        _pageIndex == _pageCount - 1 ? 'Save' : 'Continue',
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
