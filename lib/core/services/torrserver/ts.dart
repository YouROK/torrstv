import 'dart:async';
import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart';
import 'package:path/path.dart' as path;
import 'package:torrstv/core/services/torrserver/api.dart';
import 'package:torrstv/core/settings/settings_providers.dart';

final torrServerServiceProvider = Provider.autoDispose<TorrServerService>((ref) {
  return TorrServerService(ref);
});

String getTSPath() {
  final appExecutablePath = Platform.resolvedExecutable;
  final executableDir = path.dirname(appExecutablePath);
  var filename = "TorrServer";
  if (Platform.isWindows) {
    filename += ".exe";
  }
  final filePath = path.join(executableDir, filename);
  return filePath;
}

Future<bool> isExistsTS() async {
  final file = File(getTSPath());
  return await file.exists();
}

class TorrServerService {
  final Ref _ref;
  KeepAliveLink? _link;

  TorrServerService(this._ref) {
    _ref.onDispose(() {
      _link?.close();
    });
  }

  Future<String> startTorrServer() async {
    _link = _ref.keepAlive();

    if (!isLocalTorrServer()) {
      _link?.close();
      _link = null;
      return '';
    }
    if (!await isExistsTS()) {
      _link?.close();
      _link = null;
      print('File TorrServer not found');
      return 'TorrServer not found, please download it in Settings page';
    }

    final ver = await _ref.read(torrServerApiProvider).echo();
    if (ver.isNotEmpty) {
      _link?.close();
      _link = null;
      return '';
    }

    try {
      await Process.start(getTSPath(), [], mode: ProcessStartMode.detached);
      await Future.delayed(Duration(seconds: 1));
      final afterStartVer = await _ref.read(torrServerApiProvider).echo().timeout(Duration(seconds: 5));
      _link?.close();
      _link = null;
      if (afterStartVer.isNotEmpty) {
        return '';
      } else {
        return 'TorrServer started, but not accessible (check logs or firewall)';
      }
    } catch (e) {
      _link?.close();
      _link = null;
      print('Error exec TorrServer: $e');
      return 'Error exec TorrServer: $e';
    }
  }

  Future<bool> stopTorrServer(String executablePath) async {
    if (!isLocalTorrServer()) {
      return false;
    }
    try {
      return await _ref.read(torrServerApiProvider).shutdown();
    } catch (e) {
      print('Error stopping TorrServer: $e');
      return false;
    }
  }

  bool isLocalTorrServer() {
    final host = _ref.read(settingsProvider).getTSHost();
    return host.contains("localhost") || host.contains("127.0.0.1");
  }
}
