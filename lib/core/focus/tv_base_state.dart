import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'tv_base_page.dart';
import 'tv_focus_manager.dart';

abstract class TvBasePageState<T extends TvBasePage> extends ConsumerState<T> {
  late final TvFocusManager focusManager;

  @override
  void initState() {
    super.initState();
    focusManager = TvFocusManager();
  }

  FocusNode getFocusNode(String id) {
    return focusManager.getFocusNode(id);
  }

  @override
  void dispose() {
    focusManager.dispose();
    super.dispose();
  }
}
