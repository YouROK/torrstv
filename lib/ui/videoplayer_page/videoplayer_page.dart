import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';
import 'package:path/path.dart' as p;
import 'package:torrstv/core/services/torrserver/api.dart';
import 'package:torrstv/core/settings/settings.dart';
import 'package:torrstv/core/settings/settings_providers.dart';
import 'package:torrstv/core/settings/videoplayer_settings.dart';
import 'package:torrstv/ui/torrents_page/torrent_info_page/mime.dart';
import 'package:torrstv/ui/videoplayer_page/videoplayer_desktop_controls.dart';

import 'audio_filter_utils.dart';

class InternalVideoPlayer extends ConsumerStatefulWidget {
  final dynamic torrent;
  final dynamic file;

  const InternalVideoPlayer({super.key, required this.torrent, required this.file});

  @override
  ConsumerState<InternalVideoPlayer> createState() => _InternalVideoPlayerState();
}

class _InternalVideoPlayerState extends ConsumerState<InternalVideoPlayer> {
  late final Player player;
  late final VideoController controller;
  bool _positionRestored = false;
  late final Settings sets;
  late final VideoPlayerSettings vsets;
  int _lastSavedSeconds = 0;
  dynamic file;

  bool _isMetaLoaded = false;

  @override
  void initState() {
    super.initState();
    player = Player();
    player.stream.log.listen((event) {
      print('MPV [${event.level.toUpperCase()}]: ${event.text}');
    });
    controller = VideoController(player);
    _initializePlayer();
    _setupPositionListener();
    _setupDurationListener();
    _setupPlaylistListener();
    _setupVolumeListener();
    _trackListener();
    _setupMetadataListener();
  }

  dynamic _findExternals(dynamic file, List<dynamic> files) {
    final filename = p.basenameWithoutExtension(file['path']);

    final subs = files.where((f) {
      if (Mime.getMimeType(f['path']) == "subs/*") {
        return f['path'].contains(filename);
      }
      return false;
    }).toList();
    final audio = files.where((f) {
      if (Mime.getMimeType(f['path']) == "audio/*") {
        return f['path'].contains(filename);
      }
      return false;
    }).toList();

    final Map<String, dynamic> rets = {};
    rets['subs'] = subs;
    rets['audio'] = audio;

    return rets;
  }

  Future<void> _initializePlayer() async {
    sets = ref.read(settingsProvider);
    vsets = ref.read(videoPlayerSettingsProvider);
    file = widget.file;

    final tsUrl = ref.read(torrServerApiProvider).getTSUrl();

    final videoFiles = widget.torrent['file_stats'].where((file) => Mime.getMimeType(file['path']) == "video/*").toList();

    final futures = videoFiles.map<Future<Media>>((f) async {
      final pos = await sets.loadPosition(widget.torrent['hash'], f['id']);
      final extras = _findExternals(f, widget.torrent['file_stats']);
      return Media(
        '$tsUrl/stream/play?link=${widget.torrent['hash']}&index=${f['id']}&play',
        extras: extras,
        start: Duration(seconds: pos),
      );
    }).toList();

    final List<Media> listMedia = await Future.wait(futures);

    final mediaUrl = '$tsUrl/stream/play?link=${widget.torrent['hash']}&index=${file['id']}&play';
    final index = listMedia.indexWhere((m) => m.uri == mediaUrl);
    final savedPosition = listMedia[index].start;
    final playable = Playlist(listMedia, index: index >= 0 ? index : 0);

    player.setVolume(vsets.getVolume());

    await player.open(playable);
    await player.play();

    _lastSavedSeconds = savedPosition?.inSeconds ?? 0;
    _positionRestored = true;
  }

  void _setupPlaylistListener() {
    player.stream.playlist.listen((playlist) {
      if (playlist.medias.isEmpty) return;
      _positionRestored = false;
      _isMetaLoaded = false;
      final currentIndex = playlist.index;
      if (currentIndex >= 0 && currentIndex < playlist.medias.length) {
        final currentMedia = playlist.medias[currentIndex];

        // set current file, for save position
        final uri = currentMedia.uri;
        final indexMatch = RegExp(r'index=(\d+)').firstMatch(uri);
        if (indexMatch != null) {
          final currentFileId = int.parse(indexMatch.group(1)!);
          final currentFile = widget.torrent['file_stats'].firstWhere((f) => f['id'] == currentFileId);
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

  void _setupVolumeListener() {
    player.stream.volume.listen((volume) {
      vsets.setVolume(volume);
    });
  }

  void _trackListener() {
    player.stream.track.listen((track) {
      applyAudioFiltersFromSettings(player, vsets, player.state.track.audio.channelscount);
    });
  }

  void _setupMetadataListener() {
    player.stream.buffer.listen((onData) {
      if (!_isMetaLoaded && onData.inMilliseconds > 100) {
        _isMetaLoaded = true;
        //load external subs/audio

        final currSub = player.state.track.subtitle;
        var currAudio = player.state.track.audio;

        //autoselect track
        if (currAudio.id.isNotEmpty && (currAudio.id == 'auto' || currAudio.id == 'no') && player.state.tracks.audio.length > 2) {
          String languageCode = PlatformDispatcher.instance.locale.languageCode.toLowerCase();
          final list = player.state.tracks.audio.where((track) => track.language != null && track.language!.toLowerCase().contains(languageCode));

          if (list.isNotEmpty) {
            currAudio = list.first;
          } else {
            currAudio = player.state.tracks.audio.where((t) => t.id != 'auto' && t.id != 'no').first;
          }
        }

        final playlist = player.state.playlist;
        final currentIndex = playlist.index;
        final currentMedia = playlist.medias[currentIndex];
        final subs = (currentMedia.extras?['subs'] as List?) ?? [];
        final audios = (currentMedia.extras?['audio'] as List?) ?? [];
        final tsUrl = ref.read(torrServerApiProvider).getTSUrl();

        for (var sub in subs) {
          player.setSubtitleTrack(SubtitleTrack.uri('$tsUrl/stream/play?link=${widget.torrent['hash']}&index=${sub['id']}&play', title: p.basename(sub['path'])));
        }
        for (var audio in audios) {
          player.setAudioTrack(AudioTrack.uri('$tsUrl/stream/play?link=${widget.torrent['hash']}&index=${audio['id']}&play', title: p.basename(audio['path'])));
        }

        //return selected subs/audio
        player.setSubtitleTrack(currSub);
        player.setAudioTrack(currAudio);
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
              decoration: BoxDecoration(color: Colors.black.withOpacity(0.6), borderRadius: BorderRadius.circular(25)),
              child: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white, size: 28),
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
