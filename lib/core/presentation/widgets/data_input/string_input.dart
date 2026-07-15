import 'package:flutter/material.dart';

class StringInput extends StatefulWidget {
  const StringInput({
    super.key,
    this.initString,
    this.update,
    this.submit,
    this.keyboardType,
    this.decoration,
  });

  final String? initString;
  final Function(String)? update;
  final Function(String)? submit;
  final TextInputType? keyboardType;
  final InputDecoration? decoration;

  @override
  State<StringInput> createState() => _StringInputState();
}

class _StringInputState extends State<StringInput> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initString);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      keyboardType: widget.keyboardType,
      style: Theme.of(context).textTheme.bodyMedium,
      controller: _controller,
      decoration: widget.decoration ??
          const InputDecoration(
            border: UnderlineInputBorder(),
          ),
      onChanged: widget.update,
      onSubmitted: widget.submit,
    );
  }
}
