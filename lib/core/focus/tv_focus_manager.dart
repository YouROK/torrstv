import 'package:flutter/material.dart';

class TvFocusManager {
  final Map<String, FocusNode> _focusNodes = {};

  TvFocusManager();

  FocusNode getFocusNode(String id) {
    if (!_focusNodes.containsKey(id)) {
      _focusNodes[id] = FocusNode(debugLabel: 'FocusNode-$id');
    }
    return _focusNodes[id]!;
  }

  void dispose() {
    _focusNodes.values.forEach((node) => node.dispose());
    _focusNodes.clear();
  }
}
