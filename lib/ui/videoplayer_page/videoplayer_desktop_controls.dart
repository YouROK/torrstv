import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';
import 'package:torrstv/core/settings/settings_providers.dart';
import 'package:torrstv/l10n/app_localizations.dart';
import 'package:torrstv/ui/videoplayer_page/videoplayer_settings_page/videoplayer_settings_page.dart';

class VideoPlayerDesktopControls extends ConsumerStatefulWidget {
  final VideoState state;

  const VideoPlayerDesktopControls({super.key, required this.state});

  @override
  ConsumerState<VideoPlayerDesktopControls> createState() => _VideoPlayerDesktopControlsState();
}

class _VideoPlayerDesktopControlsState extends ConsumerState<VideoPlayerDesktopControls> {
  bool _mount = false;
  bool _visible = false;
  Timer? _timer;
  bool _showAudioTracks = false;
  bool _showSubtitleTracks = false;
  bool _showPlayPauseAnimation = false;
  Timer? _animationTimer;

  StreamSubscription<bool>? _playingSubscription;
  StreamSubscription<Duration>? _bufferSubscription;

  @override
  void initState() {
    super.initState();
    _showControls();

    _playingSubscription = widget.state.widget.controller.player.stream.playing.listen((playing) {
      if (mounted) {
        if (playing) {
          _hideControls();
        } else {
          _showControls();
        }
      }
    });

    _bufferSubscription = widget.state.widget.controller.player.stream.buffer.listen((_) {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _animationTimer?.cancel();
    _playingSubscription?.cancel();
    _bufferSubscription?.cancel();
    super.dispose();
  }

  void _showControls() {
    setState(() {
      _mount = true;
      _visible = true;
    });

    _timer?.cancel();

    if (widget.state.widget.controller.player.state.playing) {
      _timer = Timer(const Duration(seconds: 3), () {
        if (mounted) {
          setState(() {
            _visible = false;
            _showAudioTracks = false;
            _showSubtitleTracks = false;
          });
        }
      });
    }
  }

  void _hideControls() {
    _timer?.cancel();
    if (widget.state.widget.controller.player.state.playing) {
      _timer = Timer(const Duration(seconds: 1), () {
        if (mounted) {
          setState(() {
            _visible = false;
            _showAudioTracks = false;
            _showSubtitleTracks = false;
          });
        }
      });
    }
  }

  void _onHover() {
    _showControls();
  }

  void _onEnter() {
    _showControls();
  }

  void _onExit() {
    _hideControls();
  }

  void _toggleAudioTracks() {
    setState(() {
      _showAudioTracks = !_showAudioTracks;
      _showSubtitleTracks = false;
    });
    _showControls();
  }

  void _toggleSubtitleTracks() {
    setState(() {
      _showSubtitleTracks = !_showSubtitleTracks;
      _showAudioTracks = false;
    });
    _showControls();
  }

  Future<void> _setAudioTrack(AudioTrack track) async {
    await widget.state.widget.controller.player.setAudioTrack(track);
    setState(() {
      _showAudioTracks = false;
    });
    _showControls();
  }

  Future<void> _setSubtitleTrack(SubtitleTrack track) async {
    await widget.state.widget.controller.player.setSubtitleTrack(track);

    final sets = ref.read(videoPlayerSettingsProvider);
    if (track.id == 'auto') {
      sets.setDefSubs(1);
    } else if (track.id == 'no') {
      sets.setDefSubs(0);
    } else {
      if (track.title?.toLowerCase().contains('forc') ?? false) {
        sets.setDefSubs(2);
      } else {
        sets.setDefSubs(3);
      }
    }

    setState(() {
      _showSubtitleTracks = false;
    });
    _showControls();
  }

  void _onVideoTap() {
    widget.state.widget.controller.player.playOrPause();

    setState(() {
      _showPlayPauseAnimation = true;
    });

    _animationTimer?.cancel();
    _animationTimer = Timer(const Duration(milliseconds: 300), () {
      if (mounted) {
        setState(() {
          _showPlayPauseAnimation = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return MouseRegion(
      onHover: (_) => _onHover(),
      onEnter: (_) => _onEnter(),
      onExit: (_) => _onExit(),
      child: Stack(
        children: [
          Positioned(
            left: 0,
            right: 0,
            top: 60,
            bottom: 100,
            child: GestureDetector(onTap: _onVideoTap, behavior: HitTestBehavior.opaque, child: _buildCenterInfoOverlay(l10n)),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            height: 100,
            child: AnimatedOpacity(
              opacity: _visible ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 150),
              onEnd: () {
                if (!_visible) {
                  setState(() {
                    _mount = false;
                    _showAudioTracks = false;
                    _showSubtitleTracks = false;
                  });
                }
              },
              child: _mount ? _buildControls(l10n) : const SizedBox.shrink(),
            ),
          ),
          if (_showAudioTracks) _buildAudioTracksOverlay(l10n),
          if (_showSubtitleTracks) _buildSubtitleTracksOverlay(l10n),
          if (_showPlayPauseAnimation) _buildPlayPauseAnimation(),
        ],
      ),
    );
  }

  Widget _buildPlayPauseAnimation() {
    final isPlaying = widget.state.widget.controller.player.state.playing;
    return Positioned.fill(
      child: Center(
        child: SizedBox(width: 100, height: 100, child: Icon(isPlaying ? Icons.pause : Icons.play_arrow, color: Colors.white, size: 50)),
      ),
    );
  }

  VideoTrack? _findActiveVideoTrackDetails(Player player) {
    final videoTracks = player.state.tracks.video;

    final activeId = player.state.track.video.id;
    if (activeId != 'auto' && activeId != 'no') {
      final explicitTrack = videoTracks.cast<VideoTrack?>().firstWhere((track) => track?.id == activeId && track?.codec != null, orElse: () => null);
      if (explicitTrack != null) return explicitTrack;
    }

    return videoTracks.cast<VideoTrack?>().firstWhere(
      (track) => track?.id != 'auto' && track?.id != 'no' && !(track?.image ?? false) && (track?.codec != null || track?.w != null),
      orElse: () => null,
    );
  }

  Widget _buildCenterInfoOverlay(AppLocalizations l10n) {
    final player = widget.state.widget.controller.player;
    final playerState = player.state;

    List<String> infoLines = [];

    // --- Video info ---
    String videoLine = '';
    final activeVideoTrack = _findActiveVideoTrackDetails(player);
    if (activeVideoTrack != null) {
      final width = activeVideoTrack.w ?? playerState.width;
      final height = activeVideoTrack.h ?? playerState.height;
      if (width != null && height != null && width > 0 && height > 0) {
        videoLine = '$width x $height';
      }

      if (activeVideoTrack.codec != null && activeVideoTrack.codec!.isNotEmpty) {
        videoLine += ' | ${activeVideoTrack.codec!.toUpperCase()}';
      }

      if (activeVideoTrack.fps != null && activeVideoTrack.fps! > 0) {
        videoLine += ' | ${activeVideoTrack.fps!.round()} FPS';
      }
    }
    if (videoLine.isNotEmpty) infoLines.add(videoLine);

    // --- Audio info ---
    String audioInfo = '';
    final currentAudio = playerState.track.audio;
    if (currentAudio.id != 'auto' && currentAudio.id != 'no') {
      final lang = currentAudio.language?.toUpperCase() ?? '';
      final title = currentAudio.title;

      if (title != null && title.isNotEmpty) {
        audioInfo = title;
      } else if (lang.isNotEmpty) {
        audioInfo = lang;
      } else {
        audioInfo = l10n.unknownAudio(currentAudio.id);
      }

      // Technical details
      String codec = currentAudio.codec?.toUpperCase() ?? '';
      int channelsCount = currentAudio.channelscount ?? playerState.audioParams.channelCount ?? 0;
      String channels = _formatChannels(channelsCount, l10n);
      String bitrate = '';
      if (playerState.audioBitrate != null && playerState.audioBitrate! > 0) {
        bitrate = '${(playerState.audioBitrate! / 1000).round()} kbps';
      }

      String techDetails = [codec, channels, bitrate].where((s) => s.isNotEmpty).join(', ');
      if (techDetails.isNotEmpty) {
        audioInfo += ' ($techDetails)';
      }
      infoLines.add(audioInfo);
    }

    // --- Subtitle info ---
    String subtitleInfo = '';
    final currentSubtitle = playerState.track.subtitle;
    if (currentSubtitle.id != 'auto' && currentSubtitle.id != 'no') {
      final lang = currentSubtitle.language?.toUpperCase();
      final title = currentSubtitle.title;

      if (title != null && title.isNotEmpty) {
        subtitleInfo = title;
      } else if (lang != null && lang.isNotEmpty) {
        subtitleInfo = 'Lang: $lang';
      } else {
        subtitleInfo = l10n.unknownSubtitles(currentSubtitle.id);
      }
      infoLines.add(subtitleInfo);
    }

    // --- Buffering ---
    if (playerState.bufferingPercentage > 0.0) {
      final total = playerState.duration.inMilliseconds;
      final buffered = playerState.buffer.inMilliseconds;
      if (total > 0 && buffered > 0) {
        final pct = (buffered / total) * 100;
        infoLines.add(l10n.buffering(pct.toStringAsFixed(1)));
      }
    }

    // --- Filename ---
    String fileName = '';
    if (playerState.playlist.medias.isNotEmpty) {
      final media = playerState.playlist.medias[playerState.playlist.index];
      fileName = media.extras?['filename'] ?? media.uri.split('/').last;
    }

    if (player.state.playing) {
      return Container();
    } else {
      return AnimatedOpacity(
        opacity: _visible ? 1.0 : 0.0,
        duration: const Duration(milliseconds: 150),
        child: IgnorePointer(
          ignoring: true,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                margin: const EdgeInsets.symmetric(horizontal: 24),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.75),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.white10),
                ),
                constraints: const BoxConstraints(maxWidth: 450),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (fileName.isNotEmpty) ...[
                      Text(
                        fileName,
                        style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const Divider(color: Colors.white24, height: 16),
                    ],
                    ...infoLines.map(
                      (line) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 2.0),
                        child: Text(
                          line,
                          style: const TextStyle(color: Colors.white70, fontSize: 13),
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    }
  }

  Widget _buildControls(AppLocalizations l10n) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [Colors.transparent, Colors.black45, Colors.black87, Colors.black], stops: [0.0, 0.2, 0.7, 1.0]),
      ),
      child: Column(
        children: [
          const Expanded(child: SizedBox()),
          MaterialDesktopSeekBar(
            onSeekStart: () {
              _timer?.cancel();
            },
            onSeekEnd: () {
              _showControls();
            },
          ),
          _buildMiddleBar(l10n),
        ],
      ),
    );
  }

  Widget _buildMiddleBar(AppLocalizations l10n) {
    return Container(
      height: 56,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          MaterialDesktopSkipPreviousButton(),
          MaterialDesktopPlayOrPauseButton(),
          MaterialDesktopSkipNextButton(),
          MaterialDesktopPositionIndicator(),
          MaterialDesktopVolumeButton(),
          const Spacer(),
          _buildSettingsButton(),
          _buildAudioTrackButton(l10n),
          _buildSubtitleTrackButton(l10n),
          MaterialDesktopFullscreenButton(),
        ],
      ),
    );
  }

  Widget _buildSettingsButton() {
    return MaterialDesktopCustomButton(
      onPressed: () {
        final player = widget.state.widget.controller.player;
        Navigator.of(context).push(MaterialPageRoute(builder: (context) => VideoPlayerSettingsPage(player)));
      },
      icon: const Icon(Icons.settings, color: Colors.white),
      iconSize: 22,
    );
  }

  Widget _buildAudioTrackButton(AppLocalizations l10n) {
    return MaterialDesktopCustomButton(
      onPressed: _toggleAudioTracks,
      icon: const Icon(Icons.audiotrack, color: Colors.white),
      iconSize: 22,
    );
  }

  Widget _buildSubtitleTrackButton(AppLocalizations l10n) {
    final currentSubtitle = widget.state.widget.controller.player.state.track.subtitle;
    return MaterialDesktopCustomButton(
      onPressed: _toggleSubtitleTracks,
      icon: Icon(Icons.subtitles, color: currentSubtitle.id != 'auto' ? Colors.blue : Colors.white),
      iconSize: 22,
    );
  }

  String _formatChannels(int count, AppLocalizations l10n) {
    if (count <= 0) return '';
    if (count == 1) return l10n.mono;
    if (count == 2) return l10n.stereo;
    return '${count - 1}.1';
  }

  Widget _buildAudioTracksOverlay(AppLocalizations l10n) {
    final audioTracks = widget.state.widget.controller.player.state.tracks.audio;
    final currentAudio = widget.state.widget.controller.player.state.track.audio;

    if (audioTracks.isEmpty) return const SizedBox();

    final screenHeight = MediaQuery.of(context).size.height;

    return Positioned(
      right: 16,
      bottom: 100,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxHeight: screenHeight * 0.7),
        child: Container(
          width: 220,
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.8),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.white24),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  border: Border(bottom: BorderSide(color: Colors.white24)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.audiotrack, size: 16, color: Colors.white70),
                    const SizedBox(width: 8),
                    Text(
                      l10n.audioTracksTitle,
                      style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ...audioTracks.where((t) => t.id != 'auto' && t.id != 'no').map((track) {
                        final isSelected = track.id == currentAudio.id;
                        return Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () => _setAudioTrack(track),
                            child: Container(
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                              decoration: BoxDecoration(
                                color: isSelected ? Colors.blue.withOpacity(0.3) : Colors.transparent,
                                border: Border(bottom: BorderSide(color: Colors.white12)),
                              ),
                              child: Row(
                                children: [
                                  Icon(isSelected ? Icons.check_circle : Icons.radio_button_unchecked, size: 16, color: isSelected ? Colors.blue : Colors.white54),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(track.title ?? l10n.unknownAudio(track.id), style: TextStyle(color: isSelected ? Colors.blue : Colors.white, fontSize: 13)),
                                        Row(
                                          children: [
                                            if (track.codec != null && track.codec!.isNotEmpty) Text(track.codec!, style: const TextStyle(color: Colors.white70, fontSize: 10)),
                                            if (track.codec != null && track.codec!.isNotEmpty && track.channelscount != null) const SizedBox(width: 5),
                                            if (track.channelscount != null) Text(_formatChannels(track.channelscount!, l10n), style: const TextStyle(color: Colors.white70, fontSize: 10)),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  if (track.language != null && track.language!.isNotEmpty)
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                      decoration: BoxDecoration(color: Colors.white10, borderRadius: BorderRadius.circular(4)),
                                      child: Text(track.language!, style: const TextStyle(color: Colors.white70, fontSize: 10)),
                                    ),
                                ],
                              ),
                            ),
                          ),
                        );
                      }),
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

  Widget _buildSubtitleTracksOverlay(AppLocalizations l10n) {
    final subtitleTracks = widget.state.widget.controller.player.state.tracks.subtitle;
    final currentSubtitle = widget.state.widget.controller.player.state.track.subtitle;

    if (subtitleTracks.isEmpty) return const SizedBox();

    final screenHeight = MediaQuery.of(context).size.height;

    return Positioned(
      right: 16,
      bottom: 100,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxHeight: screenHeight * 0.7),
        child: Container(
          width: 220,
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.8),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.white24),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  border: Border(bottom: BorderSide(color: Colors.white24)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.subtitles, size: 16, color: Colors.white70),
                    const SizedBox(width: 8),
                    Text(
                      l10n.subtitlesTitle,
                      style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ...subtitleTracks.map((track) {
                        final isSelected = track.id == currentSubtitle.id;
                        String displayText;
                        if (track.id == 'no') {
                          displayText = l10n.disableSubtitles;
                        } else {
                          displayText = track.title ?? l10n.unknownSubtitles(track.id);
                        }
                        return Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () => _setSubtitleTrack(track),
                            child: Container(
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                              decoration: BoxDecoration(
                                color: isSelected ? Colors.blue.withOpacity(0.3) : Colors.transparent,
                                border: Border(bottom: track == subtitleTracks.last ? BorderSide.none : BorderSide(color: Colors.white12)),
                              ),
                              child: Row(
                                children: [
                                  Icon(isSelected ? Icons.check_circle : Icons.radio_button_unchecked, size: 16, color: isSelected ? Colors.blue : Colors.white54),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(displayText, style: TextStyle(color: isSelected ? Colors.blue : Colors.white, fontSize: 13)),
                                  ),
                                  if (track.language != null && track.language!.isNotEmpty && track.id != 'no')
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                      decoration: BoxDecoration(color: Colors.white10, borderRadius: BorderRadius.circular(4)),
                                      child: Text(track.language!, style: const TextStyle(color: Colors.white70, fontSize: 10)),
                                    ),
                                ],
                              ),
                            ),
                          ),
                        );
                      }),
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
}
