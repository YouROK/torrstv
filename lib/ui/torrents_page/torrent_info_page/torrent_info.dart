import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:torrstv/core/services/torrserver/api.dart';
import 'package:torrstv/core/settings/settings.dart';
import 'package:torrstv/core/settings/settings_providers.dart';
import 'package:torrstv/core/utils/bytes.dart';
import 'package:torrstv/ui/torrents_page/torrent_info_page/mime.dart';
import 'package:torrstv/ui/torrents_page/torrent_info_page/torrent_info_provider.dart';
import 'package:torrstv/ui/videoplayer_page/videoplayer_page.dart';

class TorrentInfoPage extends ConsumerWidget {
  final String hash;
  dynamic info;
  dynamic file;
  bool _opened = false;

  TorrentInfoPage({super.key, required this.hash});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final torrentAsync = ref.watch(torrentInfoProvider(hash));

    torrentAsync.whenData((value) {
      if (!_opened && file != null && info != null) {
        if (value['preload_size'] != null && value['preloaded_bytes'] != null) {
          if (value['preloaded_bytes'] >= value['preload_size']) {
            _opened = true;
            WidgetsBinding.instance.addPostFrameCallback((_) {
              _openVideoPlayer(context);
            });
          }
        }
      }
    });

    return Scaffold(
      appBar: AppBar(title: Text('Информация о торренте')),
      body: torrentAsync.when(
        loading: () => Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error, size: 64, color: Colors.red),
              SizedBox(height: 16),
              Text('Ошибка: $error'),
              SizedBox(height: 16),
              ElevatedButton(onPressed: () => ref.refresh(torrentInfoProvider(hash)), child: Text('Повторить')),
            ],
          ),
        ),
        data: (torrentInfo) {
          return _buildTorrentInfo(context, torrentInfo, ref);
        },
      ),
    );
  }

  Widget _buildTorrentInfo(BuildContext context, Map<String, dynamic> info, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;

    int preloaded = 0;
    if (info['preload_size'] != null && info['preloaded_bytes'] != null) {
      preloaded = (info['preloaded_bytes'] * 100 / (info['preload_size'] + 1)).toInt();
    }

    final List<dynamic> files = _parseFiles(info);

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 800),
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildPoster(info["poster"]),
                  SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (info['title'] != null)
                          Text(
                            info['title'],
                            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                          ),
                        SizedBox(height: 8),
                        Text(
                          'Хэш: $hash',
                          style: TextStyle(fontSize: 12, color: Colors.grey[600], fontFamily: 'monospace'),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              SizedBox(height: 16),

              Card(
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildInfoRow('Размер', bytesFmt(info['torrent_size'] ?? 0)),
                      _buildInfoRow('Статус', info['stat_string'] ?? 'Неизвестно'),
                      _buildInfoRow('Раздающие', '${info['connected_seeders'] ?? 0} · ${info['pending_peers'] ?? 0} / ${info['total_peers'] ?? 0}'),
                      _buildInfoRow('Скорость', speedFmt(info['download_speed'] ?? 0)),

                      if (info['stat'] == 2 && info['preload_size'] != null && info['preloaded_bytes'] != null) ...[
                        SizedBox(height: 8),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: LinearProgressIndicator(value: preloaded / 100.0, backgroundColor: colorScheme.onSurface.withOpacity(0.1), color: colorScheme.primary, minHeight: 8),
                        ),
                        SizedBox(height: 8),
                        _buildInfoRow('Предзагрузка', '$preloaded%'),
                      ],
                    ],
                  ),
                ),
              ),

              SizedBox(height: 16),

              if (files.isNotEmpty)
                Card(
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Файлы (${files.length})', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        SizedBox(height: 12),
                        ...files.map((file) => _buildFileItem(context, info, file, ref)),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Text('$label: ', style: TextStyle(fontWeight: FontWeight.w500)),
          Expanded(child: Text(value, overflow: TextOverflow.ellipsis)),
        ],
      ),
    );
  }

  Widget _buildPoster(String? posterUrl) {
    if (posterUrl == null || posterUrl.isEmpty) {
      return Container();
    }

    return SizedBox(
      width: 60,
      height: 90,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(4),
        child: Image.network(
          posterUrl,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return Container(
              decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(4)),
              child: const Icon(Icons.broken_image, size: 24, color: Colors.grey),
            );
          },
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return Container(
              decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(4)),
              child: const Center(child: CircularProgressIndicator(strokeWidth: 2)),
            );
          },
        ),
      ),
    );
  }

  List<dynamic> _parseFiles(Map<String, dynamic> info) {
    final List<dynamic> files = [];

    if (info['file_stats'] != null && info['file_stats'] is List) {
      files.addAll(info['file_stats']);
    }

    return files.where((file) => Mime.getMimeType(file['path']) == "video/*").toList();
  }

  Widget _buildFileItem(BuildContext context, dynamic info, dynamic file, WidgetRef ref) {
    final String fileName = file['path']?.toString() ?? 'Неизвестный файл';
    final int fileSize = file['length'] ?? 0;

    final settings = ref.read(settingsProvider);
    final String hash = info['hash'];
    final int fileId = file['id'];

    return FutureBuilder(
      future: _getFileProgress(settings, hash, fileId),
      builder: (context, snapshot) {
        final double progress = snapshot.data ?? 0.0;
        final bool hasProgress = progress > 0.0 && progress < 1.0;

        return Card(
          margin: EdgeInsets.only(bottom: 8),
          elevation: 2,
          child: ListTile(
            leading: Icon(Icons.movie_outlined, color: Theme.of(context).colorScheme.primary),
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(fileName, maxLines: 2, overflow: TextOverflow.ellipsis),
                if (hasProgress) LinearProgressIndicator(value: progress, backgroundColor: Colors.grey[300], valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).colorScheme.primary), minHeight: 1),
              ],
            ),
            subtitle: Text(bytesFmt(fileSize)),
            trailing: Icon(hasProgress ? Icons.play_circle_filled : Icons.play_arrow, color: Theme.of(context).colorScheme.primary),
            onTap: () {
              _onFileTap(context, info, file, ref);
            },
          ),
        );
      },
    );
  }

  Future<double> _getFileProgress(Settings settings, String hash, int fileId) async {
    try {
      final position = await settings.loadPosition(hash, fileId);
      final duration = await settings.loadDuration(hash, fileId);
      final hasProgress = await settings.getViewing(hash, fileId);

      if (duration > 0 && position > 0) {
        return position / duration;
      }
      if (hasProgress) {
        return 0.1;
      }
      return 0.0;
    } catch (e) {
      return 0.0;
    }
  }

  void preload(BuildContext context, dynamic info, dynamic file, WidgetRef ref) {
    final torrentApi = ref.read(torrServerApiProvider);
    torrentApi.preload(info['hash'], file['id']);
  }

  void _onFileTap(BuildContext context, dynamic info, dynamic file, WidgetRef ref) {
    preload(context, info, file, ref);
    this.file = file;
    this.info = info;
    _opened = false;
  }

  void _openVideoPlayer(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => InternalVideoPlayer(torrent: info, file: file),
      ),
    );
  }
}
