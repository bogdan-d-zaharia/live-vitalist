import 'package:flutter/material.dart';
import 'package:live_vitalist/l10n/app_localizations.dart';
import 'package:flutter/services.dart';
import 'package:live_vitalist/features/aliment_editor/aliment_data_editor/presentation/widgets/editor_inputs/editor_input_decoration.dart';

class EditorNumberInput extends StatefulWidget {
  final String label;
  final double Function() getValue;
  final void Function(double) setValue;
  final String? unit;

  const EditorNumberInput(
    this.label,
    this.getValue,
    this.setValue, {
    this.unit,
    super.key,
  });

  @override
  State<EditorNumberInput> createState() => _EditorNumberInputState();
}

class _EditorNumberInputState extends State<EditorNumberInput> {
  late final TextEditingController _controller;
  late final FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.getValue().toString());
    _focusNode = FocusNode()..addListener(_handleFocusChanged);
  }

  @override
  void didUpdateWidget(covariant EditorNumberInput oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!_focusNode.hasFocus) _syncController();
  }

  @override
  void dispose() {
    _focusNode
      ..removeListener(_handleFocusChanged)
      ..dispose();
    _controller.dispose();
    super.dispose();
  }

  void _handleFocusChanged() {
    if (!_focusNode.hasFocus) _syncController();
  }

  void _syncController() {
    final text = widget.getValue().toString();
    if (_controller.text == text) return;
    _controller.text = text;
  }

  void _setValue(String rawValue) {
    final value = double.tryParse(rawValue.replaceFirst(',', '.'));
    if (value != null && value.isFinite) widget.setValue(value);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 6.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.label,
            style: theme.textTheme.labelLarge?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          SizedBox(height: 8.0),
          TextField(
            controller: _controller,
            focusNode: _focusNode,
            keyboardType: TextInputType.numberWithOptions(decimal: true),
            inputFormatters: [
              TextInputFormatter.withFunction((oldValue, newValue) {
                final isValid = RegExp(r'^\d*[,.]?\d*$')
                    .hasMatch(newValue.text);
                return isValid ? newValue : oldValue;
              }),
            ],
            style: theme.textTheme.bodyLarge,
            onChanged: _setValue,
            decoration: editorInputDecoration(
              context,
              hintText: AppLocalizations.of(context)
                  .alimentEditorEnterLabel(widget.label.toLowerCase()),
              icon: Icons.numbers_rounded,
              suffix: widget.unit == null
                  ? null
                  : Padding(
                      padding: EdgeInsets.only(right: 8.0),
                      child: Center(
                        widthFactor: 1.0,
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 10.0,
                            vertical: 6.0,
                          ),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.secondaryContainer,
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          child: Text(
                            widget.unit!,
                            style: theme.textTheme.labelMedium?.copyWith(
                              color: theme.colorScheme.onSecondaryContainer,
                            ),
                          ),
                        ),
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
