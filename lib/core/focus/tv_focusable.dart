import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'tv_focus_manager.dart';

class TvFocusable extends StatefulWidget {
  final String id;
  final Widget child;
  final TvFocusManager focusManager;

  final String? upFocus;
  final String? downFocus;
  final String? leftFocus;
  final String? rightFocus;

  final VoidCallback? onFocus;
  final VoidCallback? onFocusLost;
  final VoidCallback? onSelect;
  final Color focusedColor;

  const TvFocusable({super.key, required this.id, required this.child, required this.focusManager, this.upFocus, this.downFocus, this.leftFocus, this.rightFocus, this.onFocus, this.onFocusLost, this.onSelect, this.focusedColor = Colors.red});

  @override
  State<TvFocusable> createState() => _TvFocusableState();
}

class _TvFocusableState extends State<TvFocusable> {
  late final FocusNode _focusNode;
  bool _isFocused = false;
  late final Map<ShortcutActivator, Intent> _shortcuts;

  @override
  void initState() {
    super.initState();

    _focusNode = widget.focusManager.getFocusNode(widget.id);

    _focusNode.addListener(_handleFocusChange);
    _focusNode.onKeyEvent = _handleDpadNavigation;

    _shortcuts = {LogicalKeySet(LogicalKeyboardKey.select): const ActivateIntent(), LogicalKeySet(LogicalKeyboardKey.enter): const ActivateIntent()};
  }

  @override
  void dispose() {
    _focusNode.removeListener(_handleFocusChange);
    super.dispose();
  }

  void _handleFocusChange() {
    if (_focusNode.hasFocus != _isFocused) {
      setState(() {
        _isFocused = _focusNode.hasFocus;
      });
      if (_isFocused) {
        widget.onFocus?.call();
      } else {
        widget.onFocusLost?.call();
      }
    }
  }

  KeyEventResult _handleDpadNavigation(FocusNode node, KeyEvent event) {
    if (event is KeyDownEvent) {
      if (widget.downFocus != null && event.logicalKey == LogicalKeyboardKey.arrowDown) {
        widget.focusManager.getFocusNode(widget.downFocus!).requestFocus();
        return KeyEventResult.handled;
      }
      if (widget.upFocus != null && event.logicalKey == LogicalKeyboardKey.arrowUp) {
        widget.focusManager.getFocusNode(widget.upFocus!).requestFocus();
        return KeyEventResult.handled;
      }
      if (widget.leftFocus != null && event.logicalKey == LogicalKeyboardKey.arrowLeft) {
        widget.focusManager.getFocusNode(widget.leftFocus!).requestFocus();
        return KeyEventResult.handled;
      }
      if (widget.rightFocus != null && event.logicalKey == LogicalKeyboardKey.arrowRight) {
        widget.focusManager.getFocusNode(widget.rightFocus!).requestFocus();
        return KeyEventResult.handled;
      }
    }
    return KeyEventResult.ignored;
  }

  @override
  Widget build(BuildContext context) {
    return FocusableActionDetector(
      // focusNode: _focusNode,
      autofocus: true,
      actions: {
        ActivateIntent: CallbackAction(
          onInvoke: (Intent intent) {
            widget.onSelect?.call();
            return null;
          },
        ),
      },
      shortcuts: _shortcuts,
      child: widget.child,
      // Container(
      //   decoration: BoxDecoration(
      //     border: _isFocused ? Border.all(color: widget.focusedColor, width: 1.0) : Border.all(color: Colors.transparent, width: 1.0),
      //     borderRadius: BorderRadius.circular(8.0),
      //   ),
      //   padding: const EdgeInsets.all(5.0),
      //   child: widget.child,
      // ),
    );
  }
}
