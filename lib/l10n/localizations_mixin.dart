import 'package:flutter/material.dart';

import 'app_localizations.dart';

mixin LocalizedState<T extends StatefulWidget> on State<T> {
  late AppLocalizations l10n;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    l10n = AppLocalizations.of(context)!;
  }
}
