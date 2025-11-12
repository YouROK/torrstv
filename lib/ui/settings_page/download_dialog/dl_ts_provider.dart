import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:http/http.dart' as http;
import 'package:torrstv/core/services/torrserver/api.dart';
import 'package:torrstv/core/services/torrserver/ts.dart';
import 'package:torrstv/core/utils/bytes.dart';

const String _baseUrl = 'https://github.com/YouROK/TorrServer/releases/latest/download/';

const Map<String, String> downloadFiles = {
  // Windows
  'windows-x64': 'TorrServer-windows-amd64.exe',
  'windows-ia32': 'TorrServer-windows-386.exe',
  // Linux
  'linux-x64': 'TorrServer-linux-amd64',
  'linux-ia32': 'TorrServer-linux-386',
  'linux-arm64': 'TorrServer-linux-arm64',
  'linux-arm': 'TorrServer-linux-arm7', // armv7l -> arm7
  // MacOS (Darwin)
  'macos-x64': 'TorrServer-darwin-amd64',
  'macos-arm64': 'TorrServer-darwin-arm64',
};

class DownloadState {
  final bool isDownloading;
  final double progress;
  final String message;

  DownloadState({required this.isDownloading, this.progress = 0.0, this.message = 'Ожидание...'});

  DownloadState copyWith({bool? isDownloading, double? progress, String? message}) {
    return DownloadState(isDownloading: isDownloading ?? this.isDownloading, progress: progress ?? this.progress, message: message ?? this.message);
  }
}

final downloadStateProvider = StateNotifierProvider<DownloadNotifier, DownloadState>((ref) {
  return DownloadNotifier(ref);
});

class DownloadNotifier extends StateNotifier<DownloadState> {
  final Ref _ref;

  DownloadNotifier(this._ref) : super(DownloadState(isDownloading: false));

  String? _getTargetUrl() {
    final os = Platform.operatingSystem;
    String arch;

    if (Platform.isWindows) {
      arch = Platform.version.contains('64') ? 'x64' : 'ia32';
    } else if (Platform.isMacOS) {
      // NOTE: Platform.version might not be reliable for arch on macOS
      arch = (os == 'macos' && Platform.version.contains('arm')) ? 'arm64' : 'x64';
    } else if (Platform.isLinux) {
      if (Platform.version.contains('arm64') || Platform.version.contains('aarch64')) {
        arch = 'arm64';
      } else if (Platform.version.contains('arm')) {
        arch = 'arm'; // arm7
      } else if (Platform.version.contains('64')) {
        arch = 'x64';
      } else {
        arch = 'ia32'; // 386
      }
    } else {
      return null;
    }

    final platformKey = '$os-$arch';
    final fileName = downloadFiles[platformKey];

    if (fileName == null) {
      return null;
    }

    return '$_baseUrl$fileName';
  }

  Future<void> startDownload() async {
    if (!Platform.isLinux && !Platform.isMacOS && !Platform.isWindows) {
      state = state.copyWith(message: 'Download only in desktop OS.', isDownloading: false);
      return;
    }

    _ref.read(torrServerApiProvider).shutdown();

    final downloadUrl = _getTargetUrl();
    if (downloadUrl == null) {
      state = state.copyWith(message: 'Error: unknown platform.', isDownloading: false);
      return;
    }

    state = state.copyWith(isDownloading: true, progress: 0.0, message: 'Download file from: ${downloadUrl.split('/').last}');

    try {
      final client = http.Client();
      final request = http.Request('GET', Uri.parse(downloadUrl));
      final response = await client.send(request);

      final totalBytes = response.contentLength;
      if (totalBytes == null || response.statusCode != 200) {
        throw Exception('Error connect to host: ${response.statusCode}');
      }

      final filePath = await getTSPath();
      final file = File(filePath);
      final sink = file.openWrite();

      int bytesReceived = 0;

      await for (var bytes in response.stream) {
        if (!state.isDownloading) {
          sink.close();
          client.close();
          file.deleteSync();
          return;
        }

        sink.add(bytes);
        bytesReceived += bytes.length;

        final newProgress = bytesReceived / totalBytes;
        state = state.copyWith(progress: newProgress, message: 'Downloaded: ${(newProgress * 100).toStringAsFixed(1)}%  ${bytesFmt(bytesReceived)} / ${bytesFmt(totalBytes)}');
      }

      await sink.close();
      client.close();

      if (Platform.isLinux || Platform.isMacOS) {
        state = state.copyWith(message: 'Prepare file...');
        try {
          final result = await Process.run('chmod', ['+x', filePath]);
          if (result.exitCode != 0) {
            print('Error set perm to file (chmod): ${result.stderr}');
            state = state.copyWith(message: 'Download complete. Error set exec permission.');
            return;
          }
          if (Platform.isMacOS) {
            final resultXattr = await Process.run('xattr', ['-r', '-d', 'com.apple.quarantine', filePath]);
            if (resultXattr.exitCode != 0) {
              print('Warning: Error removing quarantine attribute (xattr): ${resultXattr.stderr}');
              state = state.copyWith(message: 'Download complete. Error remove quarantine attribute.');
              return;
            }
          }
        } catch (e) {
          print('Error exec chmod: $e');
        }
      }

      state = state.copyWith(isDownloading: false, progress: 1.0, message: 'Download complete: ${file.path}');

      final tss = _ref.read(torrServerServiceProvider);
      tss.startTorrServer();
    } catch (e) {
      state = state.copyWith(isDownloading: false, progress: 0.0, message: 'Error download: ${e.toString()}');
    }
  }

  void cancelDownload() {
    state = DownloadState(isDownloading: false, message: 'Download canceled.');
  }
}
