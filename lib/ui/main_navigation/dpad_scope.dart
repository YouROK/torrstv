import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class DpadScope extends StatelessWidget {
  final Widget child;
  final TabController? tabController;

  const DpadScope({required this.child, this.tabController, super.key});

  @override
  Widget build(BuildContext context) {
    return Focus(
      autofocus: true,
      onKeyEvent: (FocusNode node, KeyEvent event) {
        if (event is! KeyDownEvent) return KeyEventResult.ignored;

        final controller = tabController ?? DefaultTabController.of(context);
        if (controller == null) return KeyEventResult.ignored;

        switch (event.logicalKey) {
          case LogicalKeyboardKey.arrowLeft:
            final i = (controller.index - 1).clamp(0, controller.length - 1);
            controller.animateTo(i);
            return KeyEventResult.handled;

          case LogicalKeyboardKey.arrowRight:
            final i = (controller.index + 1).clamp(0, controller.length - 1);
            controller.animateTo(i);
            return KeyEventResult.handled;

          case LogicalKeyboardKey.arrowDown:
            // ↓ из TabBar: пытаемся перейти внутрь страницы
            if (_isAtTabBar(node)) {
              _moveFocusIntoPage(context, controller);
            } else {
              FocusTraversalGroup.of(node.context!).next(node);
            }
            return KeyEventResult.handled;

          case LogicalKeyboardKey.arrowUp:
            return KeyEventResult.handled; // глушим

          default:
            return KeyEventResult.ignored;
        }
      },
      child: child,
    );
  }

  // Грязный, но ОЧЕНЬ надёжный способ: проверяем по вертикальной позиции
  // Высота TabBar ~ 100px, всё что выше — считаем TabBar
  bool _isAtTabBar(FocusNode node) {
    if (node.context == null) return false;
    final renderObj = node.context!.findRenderObject();
    if (renderObj is RenderBox) {
      final position = renderObj.localToGlobal(Offset.zero);
      return position.dy < 150.0; // порог в 150 пикселей
    }
    return false;
  }

  void _moveFocusIntoPage(BuildContext context, TabController controller) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      TabBarView? tabView;
      context.visitChildElements((e) {
        if (e.widget is TabBarView) tabView = e.widget as TabBarView;
      });
      if (tabView == null) return;

      final page = tabView!.children[controller.index];
      final key = GlobalKey();
      final entry = OverlayEntry(
        builder: (_) => KeyedSubtree(key: key, child: page),
      );

      final overlay = Overlay.of(context);
      if (overlay != null) {
        overlay.insert(entry);

        WidgetsBinding.instance.addPostFrameCallback((_) {
          final pageContext = key.currentContext;
          if (pageContext != null) {
            FocusScope.of(pageContext).requestFocus();
          }
          entry.remove();
        });
      }
    });
  }
}
