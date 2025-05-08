import 'dart:math';

import 'package:flutter/material.dart';
import '../aliment/aliment.dart';
import '../palette.dart';
import 'aliment_data_editor.dart';
import 'aliment_json_editor.dart';
import 'instance_editor.dart';

/// editInstance
///
/// editAliment
///
/// editAlimentAsJson
///
/// [instance ->] Every field -> Json
abstract final class AlimentEditor {
  static Future<bool> editInstance(
      InstancedAliment aliment, BuildContext context) async {
    final (bool isModified, bool isAlimentModified) = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => InstanceEditor(aliment: aliment),
      ),
    );

    if (isModified) {
      if (isAlimentModified) {
        AlimentBank.moveToFront(aliment.alimentID);
      }

      //TODO: Investigate if you can move it up and keeping `isAlimentModified`
      // only, I am thinking it saves for mruIDs only.
      /* The amount or the unit might still have been modified. */
      AlimentBank.save();
    }

    return isModified;
  }

  static Future<bool> editAliment(Aliment aliment, BuildContext context) async {
    final bool isSaved = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AlimentDataEditor(aliment: aliment),
          ),
        ) ??
        false;

    if (isSaved && aliment is InstancedAliment) {
      AlimentBank.save();
    }

    return isSaved;
  }

  static Future<bool> editAlimentJson(
      Map<String, dynamic> alimentJson, BuildContext context) async {
    return await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AlimentJsonEditor(alimentJson: alimentJson),
          ),
        ) ??
        false;
  }
}

/// (BARWIDTH + HANDLEWIDTH, 70.0)
class PieBarEditor extends StatefulWidget {
  const PieBarEditor({
    required this.fields,
    super.key,
  });

  final Map<String, double> fields;

  @override
  State<PieBarEditor> createState() => _PieBarEditorState();
}

class _PieBarEditorState extends State<PieBarEditor> {
  final List<Map<String, dynamic>> info = [
    {
      'color': Palette.carbBlue,
      'field': 'carbs',
      'kcalsPerGram': 4.0,
    },
    {
      'color': Palette.fatYellow,
      'field': 'fats',
      'kcalsPerGram': 9.0,
    },
    {
      'color': Palette.proteinRed,
      'field': 'protein',
      'kcalsPerGram': 4.0,
    },
  ];

  final List<double> normalisedValues = [];

  final double barWidth = 300.0;

  double get calories {
    if (widget.fields['kcals'] == null) {
      widget.fields['kcals'] = 1.0;
    }
    return widget.fields['kcals']!;
  }

  void setValue(int index, double val) {
    normalisedValues[index] = val;
    /* From calories to grams. */
    widget.fields[info[index]['field']] =
        val * calories / info[index]['kcalsPerGram'];
  }

  double getValue(int index) {
    return normalisedValues[index];
  }

  @override
  void initState() {
    super.initState();

    double total = 0.0;
    for (int i = 0; i < info.length; ++i) {
      normalisedValues.add(
          widget.fields[info[i]['field']] ?? 0.01 * info[i]['kcalsPerGram']);
      total += normalisedValues[i];
    }

    for (int i = 0; i < normalisedValues.length; ++i) {
      normalisedValues[i] /= total;
    }
  }

  void _onDrag(double dx, int index) {
    setState(() {
      double deltaFraction = dx / barWidth;
      double max = getValue(index) + getValue(index + 1);
      double left = (getValue(index) + deltaFraction).clamp(0.0, max);
      double right = max - left;
      setValue(index, left);
      setValue(index + 1, right);
    });
  }

  Widget _handle({
    required int dragIndex,
    required double handleX,
    double handleWidth = 16.0,
  }) {
    return Positioned(
      left: handleX - handleWidth / 2.0 + handleWidth / 2.0,
      top: 45,
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onHorizontalDragUpdate: (details) {
          _onDrag(details.delta.dx, dragIndex);
        },
        child: MouseRegion(
          cursor: SystemMouseCursors.resizeLeftRight,
          child: Transform.rotate(
            angle: pi / 4.0,
            child: Container(
              height: handleWidth,
              width: handleWidth,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(2.0),
                  bottomLeft: Radius.elliptical(8.0, 16.0),
                  topRight: Radius.elliptical(16.0, 8.0),
                  bottomRight: Radius.circular(8.0),
                ),
                color: Colors.grey,
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> segments = [];
    final List<Widget> handles = [];
    final List<Widget> labels = [];
    final double handleWidth = 16.0;
    double currentX = 0;

    for (int i = 0; i < normalisedValues.length; i++) {
      double value = getValue(i);
      double width = value * barWidth;

      segments.add(Positioned(
        left: currentX + handleWidth / 2.0,
        top: 18,
        height: 20,
        width: width,
        child: Container(color: info[i]['color']),
      ));

      labels.add(Positioned(
        left: currentX + width / 2 - 20 + handleWidth / 2.0,
        top: 0,
        width: 40,
        child: Text(
          "${(value * 100).toStringAsFixed(0)}%",
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 12),
        ),
      ));

      if (i < normalisedValues.length - 1) {
        double handleX = currentX + width;
        handles.add(_handle(
          handleX: handleX,
          dragIndex: i,
          handleWidth: handleWidth,
        ));
      }

      currentX += width;
    }

    return SizedBox(
      width: barWidth + handleWidth,
      height: 70.0,
      child: Stack(
        children: [...labels, ...segments, ...handles],
      ),
    );
  }
}
