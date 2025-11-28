import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class DpadFormTextField extends StatelessWidget {
  final String? initialValue;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final InputDecoration? decoration;
  final ValueChanged<String>? onFieldSubmitted;
  final FormFieldValidator<String>? validator;
  final bool? enabled;

  const DpadFormTextField({super.key, this.initialValue, this.keyboardType, this.inputFormatters, this.decoration, this.onFieldSubmitted, this.validator, this.enabled});

  KeyEventResult _handleDirectionalKey(FocusNode node, KeyEvent event) {
    if (event is! KeyDownEvent) return KeyEventResult.ignored;
    final logicalKey = event.logicalKey;
    if (logicalKey == LogicalKeyboardKey.arrowDown || logicalKey == LogicalKeyboardKey.arrowUp) {
      final focusScope = FocusScope.of(node.context!);
      final moved = (logicalKey == LogicalKeyboardKey.arrowDown) ? focusScope.nextFocus() : focusScope.previousFocus();
      if (moved) {
        return KeyEventResult.handled;
      }
    }
    return KeyEventResult.ignored;
  }

  @override
  Widget build(BuildContext context) {
    return Focus(
      onKeyEvent: _handleDirectionalKey,

      child: TextFormField(
        initialValue: initialValue,
        keyboardType: keyboardType,
        inputFormatters: inputFormatters,
        decoration: decoration,
        onFieldSubmitted: onFieldSubmitted,
        validator: validator,
        enabled: enabled,
      ),
    );
  }
}
