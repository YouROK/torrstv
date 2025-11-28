import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart' as p;
import 'package:torrstv/core/services/torrserver/api.dart';
import 'package:torrstv/core/settings/settings.dart';
import 'package:torrstv/core/settings/settings_providers.dart';
import 'package:torrstv/core/utils/bytes.dart';
import 'package:torrstv/l10n/app_localizations.dart';
import 'package:torrstv/l10n/localizations_mixin.dart';
import 'package:torrstv/ui/torrents_page/torrent_info_page/mime.dart';
import 'package:torrstv/ui/torrents_page/torrent_info_page/torrent_info_provider.dart';
import 'package:torrstv/ui/videoplayer_page/videoplayer_page.dart';
import 'package:url_launcher/url_launcher_string.dart';

class TorrentInfoPage extends ConsumerStatefulWidget {
  final String hash;

  TorrentInfoPage({super.key, required this.hash});

  @override
  ConsumerState<TorrentInfoPage> createState() => _TorrentInfoPageState();
}

class _TorrentInfoPageState extends ConsumerState<TorrentInfoPage> with LocalizedState<TorrentInfoPage> {
  dynamic _info;
  dynamic _file;
  bool _opened = false;
  bool _isOpenPlayer = true;

  @override
  Widget build(BuildContext context) {
    final torrentAsync = ref.watch(torrentInfoProvider(widget.hash));

    torrentAsync.whenData((value) {
      if (!_opened && _file != null && _info != null) {
        if (value['preload_size'] != null && value['preloaded_bytes'] != null) {
          if (value['preloaded_bytes'] >= value['preload_size'] || (value['preloaded_bytes'] > 50000 && value['stat'] == 3)) {
            _opened = true;
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (_isOpenPlayer) {
                _openVideoPlayer(context);
              } else {
                final tsUrl = ref.read(torrServerApiProvider).getTSUrl();
                var fn = p.basename(_file['path']);
                if (fn.isEmpty) fn = 'DownloadTS';

                final url = '$tsUrl/stream/$fn?link=${_info['hash']}&index=${_file['id']}&play';
                launchUrlString(url);
              }
            });
          }
        }
      }
    });

    return Scaffold(
      appBar: AppBar(title: Text(l10n.torrentInfoTitle)),
      body: torrentAsync.when(
        loading: () => Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error, size: 64, color: Colors.red),
              SizedBox(height: 16),
              Text(l10n.errorLabel(error.toString())),
              SizedBox(height: 16),
              ElevatedButton(onPressed: () => ref.refresh(torrentInfoProvider(widget.hash)), child: Text(l10n.retryButton)),
            ],
          ),
        ),
        data: (torrentInfo) {
          return _buildTorrentInfo(context, torrentInfo, l10n);
        },
      ),
    );
  }

  Widget _buildTorrentInfo(BuildContext context, Map<String, dynamic> info, AppLocalizations l10n) {
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
                      _buildInfoRow(l10n.hashLabel, widget.hash.toUpperCase(), colorScheme),
                      _buildInfoRow(l10n.sizeLabel, bytesFmt(info['torrent_size'] ?? 0), colorScheme),
                      _buildInfoRow(l10n.statusLabel, info['stat_string'] ?? l10n.torrentStatusUnknown, colorScheme),
                      _buildInfoRow(l10n.seedersLabel, '${info['connected_seeders'] ?? 0} · ${info['pending_peers'] ?? 0} / ${info['total_peers'] ?? 0}', colorScheme),
                      _buildInfoRow(l10n.speedLabel, speedFmt(info['download_speed'] ?? 0), colorScheme),

                      if (info['stat'] == 2 && info['preload_size'] != null && info['preloaded_bytes'] != null) ...[
                        SizedBox(height: 8),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: LinearProgressIndicator(value: preloaded / 100.0, backgroundColor: colorScheme.onSurface.withValues(alpha: 0.1), color: colorScheme.primary, minHeight: 8),
                        ),
                        SizedBox(height: 8),
                        _buildInfoRow(l10n.preloadLabel, '$preloaded%', colorScheme),
                      ],
                    ],
                  ),
                ),
              ),

              SizedBox(height: 16),
              if (files.isNotEmpty && _isOpenPlayer)
                Card(
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: ElevatedButton.icon(
                              onPressed: () {
                                final list = _parseFiles(info);
                                final settings = ref.read(settingsProvider);

                                final viewed = list.where((f) => settings.getViewing(widget.hash, f['id']));
                                if (viewed.isNotEmpty) {
                                  _onFileTap(context, info, viewed.last);
                                } else {
                                  _onFileTap(context, info, list.first);
                                }
                              },
                              icon: const Icon(Icons.play_arrow),
                              label: Text(l10n.continueButton, textAlign: TextAlign.center),
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              ),
                            ),
                          ),
                        ),

                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.only(left: _isOpenPlayer ? 8.0 : 0.0),
                            child: ElevatedButton.icon(
                              onPressed: () {
                                ref.read(settingsProvider).clearViewing(widget.hash);
                              },
                              icon: const Icon(Icons.clear_all),
                              label: Text(l10n.clearViewedButton),
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              ),
                            ),
                          ),
                        ),
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
                        Text(l10n.filesTitle(files.length.toString()), style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        SizedBox(height: 12),
                        ...files.map((file) => _buildFileItem(context, info, file, l10n)),
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

  Widget _buildInfoRow(String label, String value, ColorScheme colorScheme) {
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

    _isOpenPlayer = true;
    final videoFiles = files.where((file) => Mime.getMimeType(file['path']) == "video/*").toList();
    if (videoFiles.isNotEmpty) return videoFiles;

    final audioFiles = files.where((file) => Mime.getMimeType(file['path']) == "audio/*").toList();
    if (audioFiles.isNotEmpty) return audioFiles;

    _isOpenPlayer = false;
    return files;
  }

  Widget _buildFileItem(BuildContext context, dynamic info, dynamic file, AppLocalizations l10n) {
    final String fileName = file['path']?.toString() ?? l10n.unknownFile;
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
                if (hasProgress)
                  LinearProgressIndicator(value: progress, backgroundColor: Colors.grey[300], valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).colorScheme.primary), minHeight: 1),
              ],
            ),
            subtitle: Text(bytesFmt(fileSize)),
            trailing: Icon(_isOpenPlayer ? (hasProgress ? Icons.play_circle_filled : Icons.play_arrow) : Icons.download, color: Theme.of(context).colorScheme.primary),
            onTap: () {
              _onFileTap(context, info, file);
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

  void preload(BuildContext context, dynamic info, dynamic file) {
    final torrentApi = ref.read(torrServerApiProvider);
    torrentApi.preload(info['hash'], file['id']);
  }

  void _onFileTap(BuildContext context, dynamic info, dynamic file) {
    preload(context, info, file);
    _file = file;
    _info = info;
    _opened = false;
  }

  void _openVideoPlayer(BuildContext context) {
    final outerPlayer = ref.read(settingsProvider).getOuterPlayer();
    final outerPlayerEnabled = ref.read(settingsProvider).isOuterPlayerEnable();
    if (outerPlayerEnabled && outerPlayer.isNotEmpty) {
      final tsUrl = ref.read(torrServerApiProvider).getTSUrl();
      final url = '$tsUrl/stream/play?link=${_info['hash']}&index=${_file['id']}&play';
      Process.start(outerPlayer.trim(), [url], mode: ProcessStartMode.detached);
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => InternalVideoPlayer(torrent: _info, file: _file),
        ),
      );
    }
  }
}
