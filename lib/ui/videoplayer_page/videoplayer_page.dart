import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';
import 'package:torrstv/core/services/torrserver/api.dart';
import 'package:torrstv/core/settings/settings.dart';
import 'package:torrstv/core/settings/settings_providers.dart';
import 'package:torrstv/ui/videoplayer_page/videoplayer_desktop_controls.dart';

class InternalVideoPlayer extends ConsumerStatefulWidget {
  final dynamic torrent;
  final dynamic file;

  const InternalVideoPlayer({
    super.key,
    required this.torrent,
    required this.file,
  });

  @override
  ConsumerState<InternalVideoPlayer> createState() =>
      _InternalVideoPlayerState();
}

class _InternalVideoPlayerState extends ConsumerState<InternalVideoPlayer> {
  late final Player player;
  late final VideoController controller;
  bool _positionRestored = false;
  late final Settings sets;
  int _lastSavedSeconds = 0;
  dynamic file;

  @override
  void initState() {
    super.initState();
    player = Player();
    controller = VideoController(player);
    _initializePlayer();
    _setupPositionListener();
    _setupDurationListener();
    _setupPlaylistListener();
  }

  Future<void> _initializePlayer() async {
    sets = ref.read(settingsProvider);
    file = widget.file;

    final tsUrl = ref.read(torrServerApiProvider).getTSUrl();

    final futures = (widget.torrent['file_stats'] as List).map<Future<Media>>((
      f,
    ) async {
      final pos = await sets.loadPosition(widget.torrent['hash'], f['id']);
      return Media(
        '$tsUrl/stream/play?link=${widget.torrent['hash']}&index=${f['id']}&play',
        start: Duration(seconds: pos),
      );
    }).toList();

    final List<Media> listMedia = await Future.wait(futures);

    final mediaUrl =
        '$tsUrl/stream/play?link=${widget.torrent['hash']}&index=${file['id']}&play';
    final index = listMedia.indexWhere((m) => m.uri == mediaUrl);
    final savedPosition = listMedia[index].start;
    final playable = Playlist(listMedia, index: index >= 0 ? index : 0);

    await player.open(playable);
    await player.play();

    _lastSavedSeconds = savedPosition?.inSeconds ?? 0;
    _positionRestored = true;
  }

  void _setupPlaylistListener() {
    player.stream.playlist.listen((playlist) {
      if (playlist.medias.isEmpty) return;
      _positionRestored = false;
      final currentIndex = playlist.index;
      if (currentIndex >= 0 && currentIndex < playlist.medias.length) {
        final currentMedia = playlist.medias[currentIndex];
        final uri = currentMedia.uri;
        final indexMatch = RegExp(r'index=(\d+)').firstMatch(uri);
        if (indexMatch != null) {
          final currentFileId = int.parse(indexMatch.group(1)!);
          final currentFile = widget.torrent['file_stats'].firstWhere(
            (f) => f['id'] == currentFileId,
          );
          file = currentFile;
          sets.setViewing(widget.torrent['hash'], file['id'], true);
        }
      }
      _positionRestored = true;
    });
  }

  void _setupDurationListener() {
    player.stream.duration.listen((duration) {
      if (!_positionRestored) return;
      sets.saveDuration(widget.torrent['hash'], file['id'], duration);
    });
  }

  void _setupPositionListener() {
    player.stream.position.listen((duration) {
      if (!_positionRestored) return;

      final int secs = duration.inSeconds;
      if ((secs - _lastSavedSeconds).abs() >= 1) {
        sets.savePosition(widget.torrent['hash'], file['id'], duration);
        _lastSavedSeconds = secs;
      }
    });
  }

  @override
  void dispose() {
    _positionRestored = false;
    player.stop();
    player.dispose();

    // Важно: если вылет сохраняется, попробуйте обернуть вызовы плеера
    // в задержку, чтобы дать нативному рендереру время на очистку.

    /*
  Future.microtask(() async {
    // В десктопных ОС иногда помогает отложить dispose до следующего кадра
    await player.stop();
    await player.dispose();
  });
  */

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Основное видео на весь экран
          Positioned.fill(
            child: Container(
              color: Colors.black,
              child: Video(
                controller: controller,
                controls: (state) => VideoPlayerDesktopControls(state: state),
              ),
            ),
          ),

          // Кнопка назад в левом верхнем углу
          Positioned(
            top: 16,
            left: 16,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.6),
                borderRadius: BorderRadius.circular(25),
              ),
              child: IconButton(
                icon: const Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                  size: 28,
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
