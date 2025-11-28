import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class DpadTextField extends StatelessWidget {
  final TextEditingController? controller;
  final ValueChanged<String>? onSubmitted;
  final InputDecoration? decoration;
  final TextStyle? style;
  final TextInputType? keyboardType;
  final TextAlign textAlign;

  const DpadTextField({super.key, this.controller, this.onSubmitted, this.decoration, this.style, this.keyboardType, this.textAlign = TextAlign.start});

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
      child: TextField(controller: controller, onSubmitted: onSubmitted, decoration: decoration, style: style, keyboardType: keyboardType, textAlign: textAlign),
    );
  }
}
