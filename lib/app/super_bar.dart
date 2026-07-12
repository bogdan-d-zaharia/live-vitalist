import 'package:flutter/material.dart';
import 'package:live_vitalist/app/constants.dart';
import 'package:live_vitalist/core/widgets/selectable_icon_button.dart';
import 'package:live_vitalist/core/widgets/sized_icon_button.dart';

class SuperBar extends StatefulWidget {
  final TextEditingController? controller;
  final void Function()? onEnter;
  final void Function()? onExit;
  final void Function(String)? onChanged;
  final void Function(bool isTemp, bool isGen)? onAdd;

  const SuperBar({
    super.key,
    this.controller,
    required this.onEnter,
    required this.onExit,
    required this.onChanged,
    required this.onAdd,
  });

  @override
  State<SuperBar> createState() => _SuperBarState();
}

class _SuperBarState extends State<SuperBar> {
  bool isTemp = false;
  bool isGen = false;

  void onTemp() {
    setState(() {
      isTemp = !isTemp;
    });
  }

  void onGen() {
    setState(() {
      isGen = !isGen;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SearchBar(
      controller: widget.controller,
      onTap: widget.onEnter,
      onTapOutside: (event) => widget.onExit?.call(),
      onChanged: widget.onChanged,
      constraints: BoxConstraints(minHeight: Constants.searchBarHeight),
      padding: WidgetStatePropertyAll(
          EdgeInsets.symmetric(horizontal: Constants.searchHorizontalPadding)),
      leading: SizedIconButton(
        onPressed: () => widget.onAdd?.call(isTemp, isGen),
        icon: Icon(Icons.add_rounded),
        buttonSize: Constants.searchButtonSize,
        iconSize: Constants.searchIconSize,
      ),
      trailing: [
        SelectableIconButton(
          isSelected: isTemp,
          onPressed: onTemp,
          icon: Icon(Icons.history_toggle_off_rounded),
          selectedColor: Colors.black,
          buttonSize: Constants.searchButtonSize,
          iconSize: Constants.searchIconSize,
        ),
        SizedBox(width: Constants.searchButtonPadding),
        SelectableIconButton(
          isSelected: isGen,
          onPressed: onGen,
          icon: Icon(Icons.auto_awesome_rounded),
          selectedColor: Colors.deepPurple,
          buttonSize: Constants.searchButtonSize,
          iconSize: Constants.searchIconSize,
        ),
      ],
    );
  }
}
