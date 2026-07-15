import 'package:flutter/material.dart';

class LabelsWidget extends StatelessWidget {
  /// map label : color
  const LabelsWidget({
    required this.map,
    this.isHorizontal = false,
    super.key,
  });

  final Map<String, Color> map;
  final bool isHorizontal;

  static List<Widget> _labels(Map<String, Color> map) {
    return map.entries
        .map(
          (e) => Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: e.value,
                  borderRadius: BorderRadius.circular(2.0),
                ),
                width: 10.0,
                height: 10.0,
                margin: EdgeInsets.only(right: 5.0),
              ),
              Text(e.key),
            ],
          ),
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> elements = _labels(map);

    if (!isHorizontal) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: elements,
      );
    } else {
      return Row(
        children: elements.map((e) => Flexible(child: e)).toList(),
      );
    }
  }
}
