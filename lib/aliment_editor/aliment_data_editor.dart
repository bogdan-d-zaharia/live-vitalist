import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

import '../aliment/aliment.dart';
import '../nutrient/nutrient_provider.dart';
import '../settings.dart';
import '../custom_card.dart';
import '../palette.dart';
import '../string_input.dart';

class AlimentDataEditor extends StatefulWidget {
  const AlimentDataEditor({
    required this.alimentData,
    required this.nutrients,
    super.key,
  });

  final AlimentData alimentData;
  final NutrientState nutrients;

  @override
  State<AlimentDataEditor> createState() => _AlimentDataEditorState();
}

class _AlimentDataEditorState extends State<AlimentDataEditor> {
  late AlimentData editable;
  bool isShowAdvanced = false;

  Widget wid({required List<Widget> children}) {
    return MiniCard(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
        child: Row(
          children: children,
        ),
      ),
    );
  }

  Widget inputEntry({
    required String initString,
    required Function(String) strUpdate,
    required dynamic Function() getter,
    required Function(dynamic) setter,
    String unit = '',
    bool isEmpty = false,
    bool isTurnedOff = false,
  }) {
    return wid(
      children: [
        Expanded(
          child: StringInput(
            initString: initString,
            update: strUpdate,
          ),
        ),
        SizedBox(width: 16.0),
        NumberInput(
          getValue: () => getter(),
          setValue: setter,
          showHandles: false,
          isEmpty: isEmpty,
          isTurnedOff: isTurnedOff,
        ),
        SizedBox(width: 16.0),
        SizedBox(
          width: 36.0,
          child: Text(unit, maxLines: 1, overflow: TextOverflow.ellipsis),
        ),
      ],
    );
  }

  Widget inputWid({required String label, required List<Widget> children}) {
    return wid(children: [
      Palette.dimParentheses(label, Theme.of(context).textTheme.bodyMedium),
      Text(': '),
      ...children,
    ]);
  }

  Widget inputNum({
    required String label,
    required dynamic Function() getter,
    required Function(dynamic) setter,
    String unit = '',
    bool test = true,
    String errorText = 'Test did not pass!',
  }) {
    if (test) {
      return inputWid(
        label: label,
        children: [
          Spacer(),
          NumberInput(
            getValue: () => getter(),
            setValue: setter,
            showHandles: false,
          ),
          SizedBox(width: 16.0),
          SizedBox(
            width: 36.0,
            child: Text(unit, maxLines: 1, overflow: TextOverflow.ellipsis),
          ),
        ],
      );
    } else {
      return Text(errorText);
    }
  }

  Widget inputField(String field) {
    double getter() {
      /* Added unecessary zeros where */
      //// if (!referenceFields.containsKey(field)) {
      ////   referenceFields[field] = 0.0;
      //// }

      return editable.referenceFields[field] ?? 0.0;
    }

    void setter(value) {
      if (value >= 0.0 && value != getter()) {
        editable.referenceFields[field] = value;
      }
    }

    return inputNum(
      label: widget.nutrients.data[field]!.translations[SettingsData.language]!,
      getter: getter,
      setter: setter,
      unit: widget.nutrients.data[field]!.unit,
      test: widget.nutrients.data.containsKey(field),
      errorText: 'Nutrient "$field" not found!',
    );
  }

  Future<bool?> saveAlert() {
    return showDialog<bool>(
      context: context,
      builder: (context) {
        return Center(
          child: IntrinsicWidth(
            child: CustomCard(
              headerSpace: 0.0,
              child: SizedBox(
                width: 212.0,
                /* 100 button, 12 spacer, 100 button */
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Do you want to save this aliment?',
                      style: TextStyle(fontSize: 16.0),
                    ),
                    SizedBox(height: 12.0),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          width: 100.0,
                          child: ElevatedButton.icon(
                            onPressed: popSave,
                            label: Text("Save"),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                              foregroundColor: Colors.white,
                              padding: EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 12),
                            ),
                          ),
                        ),
                        Spacer(),
                        SizedBox(
                          width: 100.0,
                          child: ElevatedButton.icon(
                            onPressed: popCancel,
                            label: Text("Cancel"),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                              foregroundColor: Colors.white,
                              padding: EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 12),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void popCancel() {
    Navigator.pop(context, false);
  }

  void popSave() {
    widget.alimentData.name = editable.name;
    widget.alimentData.unit = editable.unit;
    widget.alimentData.referenceSize = editable.referenceSize;
    widget.alimentData.referenceFields = editable.referenceFields;
    widget.alimentData.unitSynonyms = editable.unitSynonyms;
    Navigator.pop(context, true);
  }

  @override
  void initState() {
    super.initState();
    editable = AlimentData.fromJson(widget.alimentData.toJson());
  }

  @override
  Widget build(BuildContext context) {
    final List<String> basicFieldsStr = ['kcals', 'protein', 'carbs', 'fats'];
    final List<Widget> basicFieldsWid =
        basicFieldsStr.map((e) => inputField(e)).toList();

    final List<String> advancedFieldsStr = widget.nutrients.order
        .where((k) =>
            !basicFieldsStr.contains(k) &&
            !widget.nutrients.data[k]!.tags.contains('disabled'))
        .toList();
    final List<Widget> advancedFieldsWid =
        advancedFieldsStr.map((e) => inputField(e)).toList();

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        if (widget.alimentData.name == editable.name &&
            widget.alimentData.unit == editable.unit &&
            widget.alimentData.referenceSize == editable.referenceSize &&
            MapEquality().equals(
                widget.alimentData.referenceFields, editable.referenceFields) &&
            MapEquality().equals(
                widget.alimentData.unitSynonyms, editable.unitSynonyms)) {
          return popCancel();
        }

        final bool? isSave = await saveAlert();

        if (isSave == null) return;
        if (context.mounted) {
          Navigator.pop(context, isSave);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('Aliment Editor'
              // (widget.aliment is InstancedAliment)
              //   ? 'Aliment Editor'
              //   : 'Temporary Aliment Editor'
              ),
          actions: [
            Container(
              /* 50.0 by default. */
              width: 42.0,
              height: 42.0,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(21.0),
                border: Border.all(
                    width: 1.0, strokeAlign: BorderSide.strokeAlignInside),
              ),
              child: IconButton(
                  onPressed: () async {
                    final alimentJson = editable.toJson();

                    AlimentEditor.editAlimentJson(
                        alimentJson, widget.nutrients, context);
                    editable = AlimentData.fromJson(alimentJson);
                    setState(() {});
                  },
                  icon: Icon(Icons.code)),
            ),
            SizedBox(width: 12.0),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: ListView(
            children: [
              inputWid(label: 'Name', children: [
                SizedBox(width: 16.0),
                Expanded(
                  child: StringInput(
                    initString: editable.name,
                    /*  This works even for InstancedAliment because
                    it uses the getter `alimentData` which gives a reference. */
                    update: (p0) {
                      editable.name = p0;
                    },
                  ),
                ),
                SizedBox(width: 16.0),
              ]),
              inputWid(
                label: 'Unit',
                children: [
                  SizedBox(width: 16.0),
                  Expanded(
                    child: StringInput(
                      initString: editable.unit,
                      update: (value) =>
                          setState(() => editable.unit = value = value),
                    ),
                  ),
                  // Expanded(
                  //   child: DropdownButton(
                  //     isExpanded: true,
                  //     borderRadius: BorderRadius.circular(24.0),
                  //     value: unit,
                  //     items: {'g', 'ml', 'portion', unit}.map((e) {
                  //       return DropdownMenuItem(value: e, child: Text(e));
                  //     }).toList(),
                  //     onChanged: (value) => setState(() {
                  //       if (value != null) unit = value;
                  //     }),
                  //   ),
                  // ),
                  SizedBox(width: 16.0),
                ],
              ),
              inputNum(
                label: 'Per amount',
                unit: editable.unit,
                getter: () => editable.referenceSize,
                /*  This works even for InstancedAliment because
                    it uses the getter `alimentData` which gives a reference. */
                setter: (p0) => editable.referenceSize = p0,
              ),
              ...basicFieldsWid,
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text("Show advanced: "),
                  Spacer(),
                  Switch(
                    value: isShowAdvanced,
                    onChanged: (value) =>
                        setState(() => isShowAdvanced = value),
                  ),
                ],
              ),
              if (isShowAdvanced) ...[
                ...advancedFieldsWid,
                SizedBox(
                  height: 48.0,
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text("Unit synonyms: "),
                  ),
                ),
                ...(editable.unitSynonyms)
                    .entries
                    .where((element) => element.key != editable.unit)
                    .map(
                      (e) => inputEntry(
                        initString: e.key,
                        strUpdate: (p0) {
                          p0 = p0.trim();
                          if (p0 == e.key) return;

                          editable.unitSynonyms[p0] =
                              editable.unitSynonyms[e.key]!;

                          editable.unitSynonyms.remove(e.key);
                        },
                        getter: () => editable.unitSynonyms[e.key],
                        setter: (p0) => setState(() {
                          if (p0 > 0.0 && p0 != 1.0) {
                            editable.unitSynonyms[e.key] = p0;
                          } else {
                            editable.unitSynonyms.remove(e.key);
                          }
                        }),
                        //TODO: We have a ghost unit
                        // when we write to it, we enter with 0.0
                        // if 0.0, isEmpty should be true
                        // pop scope filter 0.0
                        unit: editable.unit,
                      ),
                    )
                    .toList()
                  ..add(inputEntry(
                    initString: '',
                    strUpdate: (p0) {
                      p0 = p0.trim();
                      if (p0 == '' || editable.unitSynonyms.containsKey(p0)) {
                        return;
                      }

                      setState(() {});
                    },
                    isEmpty: true,
                    isTurnedOff: true,
                    getter: () => 0.0,
                    setter: (_) {},
                    unit: editable.unit,
                  )),
              ],

              //TODO: Add unit editor
              ElevatedButton(
                onPressed: () => Navigator.pop(context, true),
                child: Text('Save'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
