import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:torrstv/core/services/torrserver/api.dart';

final listTorrentsProvider = StreamProvider<List<dynamic>>((ref) {
  final api = ref.watch(torrServerApiProvider);

  final controller = StreamController<List<dynamic>>();

  final timer = Timer.periodic(const Duration(seconds: 1), (t) async {
    try {
      final torrents = await api.listTorrents();

      controller.add(torrents);
    } catch (e, stack) {
      controller.addError(e, stack);
    }
  });

  ref.onDispose(() {
    timer.cancel();
    controller.close();
  });

  return controller.stream;
});
