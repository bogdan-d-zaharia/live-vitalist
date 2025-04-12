import 'package:flutter/material.dart';
import '../aliment.dart';
import '../settings.dart';
import 'aliment_editor.dart';
import '../custom_card.dart';
import '../models/reference_fields_model.dart';
import '../string_input.dart';

class AlimentDataEditor extends StatefulWidget {
  const AlimentDataEditor({
    required this.aliment,
    super.key,
  });

  final Aliment aliment;

  @override
  State<AlimentDataEditor> createState() => _AlimentDataEditorState();
}

class _AlimentDataEditorState extends State<AlimentDataEditor> {
  /// It works because `.getAliment` is a getter as well as this getter,
  /// and it updates when using the `this.` setter `set alimentData`.
  AlimentData get alimentData => widget.aliment is TemporaryAliment
      ? (widget.aliment as TemporaryAliment).alimentData
      : (widget.aliment as InstancedAliment).getAliment;

  set alimentData(AlimentData val) {
    if (widget.aliment is TemporaryAliment) {
      (widget.aliment as TemporaryAliment).alimentData = val;
    } else if (widget.aliment is InstancedAliment) {
      final id = (widget.aliment as InstancedAliment).alimentID;
      AlimentBank.aliments[id] = val;
      AlimentBank.save();
    }
  }

  Map<String, double> get referenceFields => alimentData.referenceFields;

  bool isShowAdvanced = false;

  Widget input({
    required String label,
    required dynamic Function() getter,
    required Function(dynamic) setter,
    String unit = '',
    bool test = true,
    bool isNumber = true,
  }) {
    if (test) {
      return Container(
        margin: EdgeInsets.symmetric(vertical: 4.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24.0),
          border: Border.all(),
        ),
        child: Padding(
          padding: const EdgeInsets.all(6.0),
          child: Row(
            children: [
              ...NutrientsHandler.widMajorMinorLabels(label),
              Text(': '),
              Spacer(),
              if (isNumber)
                NumberInput(
                  getValue: () => getter(),
                  setValue: setter,
                  showHandles: false,
                )
              else
                StringInput(
                  hint: '',
                  width: 200.0,
                  initString: getter(),
                  update: (p0) {
                    alimentData.name = p0;
                  },
                ),
              SizedBox(width: 16.0),
              SizedBox(
                width: 36.0,
                child: Text(unit),
              ),
            ],
          ),
        ),
      );
    } else {
      return Text('Test did not pass!');
    }
  }

  Widget inputField(String field) {
    double getter() {
      /* Added unecessary zeros where */
      //// if (!referenceFields.containsKey(field)) {
      ////   referenceFields[field] = 0.0;
      //// }

      return referenceFields[field] ?? 0.0;
    }

    void setter(value) {
      if (value >= 0.0) {
        referenceFields[field] = value;
      }
    }

    if (NutrientsHandler.model.containsKey(field)) {
      return Container(
        margin: EdgeInsets.symmetric(vertical: 4.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24.0),
          border: Border.all(),
        ),
        child: Padding(
          padding: const EdgeInsets.all(6.0),
          child: Row(
            children: [
              ...NutrientsHandler.widMajorMinorLabels(NutrientsHandler
                  .model[field]!['translations'][SettingsData.language]),
              Text(': '),
              Spacer(),
              NumberInput(
                getValue: getter,
                setValue: setter,
                showHandles: false,
              ),
              SizedBox(width: 16.0),
              SizedBox(
                width: 36.0,
                child: Text(NutrientsHandler.model[field]!['unit']),
              ),
            ],
          ),
        ),
      );
    } else {
      return Text('Nutrient "$field" not found!');
    }
  }

  Future<bool?> saveAlert() {
    return showDialog<bool>(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: CustomCard(
            headerSpace: 0.0,
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
                      width: 120.0,
                      child: ElevatedButton.icon(
                        onPressed: () => Navigator.pop(context, true),
                        label: Text("Save"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(
                              horizontal: 16, vertical: 12),
                        ),
                      ),
                    ),
                    SizedBox(width: 12.0),
                    SizedBox(
                      width: 120.0,
                      child: ElevatedButton.icon(
                        //TODO: The values are saved when canceled,
                        //which shouldn't be the case.
                        onPressed: () => Navigator.pop(context, false),
                        icon: Icon(Icons.cancel_outlined, color: Colors.white),
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
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<String> basicFieldsStr = ['kcals', 'protein', 'carbs', 'fats'];
    final List<Widget> basicFieldsWid =
        basicFieldsStr.map((e) => inputField(e)).toList();

    final List<String> advancedFieldsStr = NutrientsHandler.model.keys
        .where((k) =>
            !basicFieldsStr.contains(k) &&
            !NutrientsHandler.hasTag(k, 'disabled'))
        .toList();
    final List<Widget> advancedFieldsWid =
        advancedFieldsStr.map((e) => inputField(e)).toList();

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;

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
                    final alimentJson = alimentData.toJson();

                    if (await AlimentEditor.editAlimentJson(
                        alimentJson, context)) {
                      alimentData = AlimentData.fromJson(alimentJson);
                      setState(() {});
                    }
                  },
                  icon: Icon(Icons.code)),
            ),
            SizedBox(width: 12.0),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(24.0),
          child: ListView(
            children: [
              input(
                label: 'Name',
                getter: () => alimentData.name,
                /*  This works even for InstancedAliment because
                    it uses the getter `alimentData` which gives a reference. */
                setter: (p0) => alimentData.name = p0,
                isNumber: false,
              ),
              input(
                label: 'Reference size',
                getter: () => alimentData.referenceSize,
                /*  This works even for InstancedAliment because
                    it uses the getter `alimentData` which gives a reference. */
                setter: (p0) => alimentData.referenceSize = p0,
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
              if (isShowAdvanced) ...advancedFieldsWid,
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
