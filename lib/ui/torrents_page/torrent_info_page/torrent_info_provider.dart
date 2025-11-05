import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:torrstv/core/services/torrserver/api.dart';

final torrentInfoProvider = StreamProvider.autoDispose.family<Map<String, dynamic>, String>((ref, hash) {
  final api = ref.watch(torrServerApiProvider);

  final controller = StreamController<Map<String, dynamic>>();

  final timer = Timer.periodic(const Duration(seconds: 1), (t) async {
    try {
      final torrent = await api.getTorrent(hash);
      controller.add(torrent);
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
