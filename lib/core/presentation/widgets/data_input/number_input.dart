import 'package:flutter/material.dart';
import 'package:live_vitalist/core/theme/palette.dart';

//TODO: Perhaps handle null getValue, so that there might be fields where it is
// for sure 0.0 and fields where it is assumed that is not specified.
class NumberInput extends StatefulWidget {
  const NumberInput({
    required this.getValue,
    required this.setValue,
    this.showHandles = true,
    this.isEmpty = false,
    this.isTurnedOff = false,
    super.key,
  });

  final double Function() getValue;
  final Function(double) setValue;
  final bool showHandles;
  final bool isEmpty;
  final bool isTurnedOff;

  @override
  State<NumberInput> createState() => _NumberInputState();
}

class _NumberInputState extends State<NumberInput> {
  late TextEditingController _controller;

  double get number => widget.getValue();
  set number(double val) => widget.setValue(val);

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget divider({double indent = 4.0, Color? color}) {
    return VerticalDivider(
      width: 0.0,
      indent: indent,
      endIndent: indent,
      color: color ?? Palette.divGrey,
    );
  }

  @override
  Widget build(BuildContext context) {
    final double height = 42.0;

    _controller.text = widget.isEmpty ? '' : number.toString();

    return Container(
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(height / 2.0),
        color: (Palette.isDarkMode(context) ? Colors.black : Colors.white)
            .withValues(alpha: 0.8),
      ),
      clipBehavior: Clip.hardEdge,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (widget.showHandles)
            SizedBox(
              width: height,
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  child: Center(child: Icon(Icons.remove_rounded)),
                  onTap: () => setState(() {
                    number = number - 1.0;
                  }),
                ),
              ),
            ),
          if (widget.showHandles) divider(),
          SizedBox(
            width: 2.0 * height,
            height: height,
            child: !widget.isTurnedOff
                ? TextField(
                    expands: true,
                    maxLines: null,
                    minLines: null,
                    // style: TextStyle(fontSize: 16),
                    textAlign: TextAlign.center,
                    textAlignVertical: TextAlignVertical.center,
                    keyboardType:
                        TextInputType.numberWithOptions(decimal: true),
                    controller: _controller,
                    decoration: InputDecoration(border: InputBorder.none),
                    onChanged: (value) {
                      final double? v = double.tryParse(value);
                      if (v != null && v.isFinite) number = v;
                    },
                    onEditingComplete: () => setState(() {}),
                  )
                : null,
          ),
          if (widget.showHandles) divider(),
          if (widget.showHandles)
            SizedBox(
              width: height,
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  child: Center(child: Icon(Icons.add_rounded)),
                  onTap: () => setState(() {
                    number = number + 1.0;
                  }),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
