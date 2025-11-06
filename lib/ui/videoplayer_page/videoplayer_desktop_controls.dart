import 'dart:async';

import 'package:flutter/material.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';

class VideoPlayerDesktopControls extends StatefulWidget {
  final VideoState state;

  const VideoPlayerDesktopControls({super.key, required this.state});

  @override
  State<VideoPlayerDesktopControls> createState() =>
      _VideoPlayerDesktopControlsState();
}

class _VideoPlayerDesktopControlsState
    extends State<VideoPlayerDesktopControls> {
  bool _mount = false;
  bool _visible = false;
  Timer? _timer;
  bool _showAudioTracks = false;
  bool _showSubtitleTracks = false;
  bool _showPlayPauseAnimation = false;
  Timer? _animationTimer;

  @override
  void initState() {
    super.initState();
    _showControls();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _animationTimer?.cancel();
    super.dispose();
  }

  void _showControls() {
    setState(() {
      _mount = true;
      _visible = true;
    });

    _timer?.cancel();
    if (widget.state.widget.controller.player.state.playing) {
      _timer = Timer(const Duration(seconds: 5), () {
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
    if (widget.state.widget.controller.player.state.playing) {
      setState(() {
        _visible = false;
        _showAudioTracks = false;
        _showSubtitleTracks = false;
      });
    }
    _timer?.cancel();
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
    _animationTimer = Timer(const Duration(seconds: 1), () {
      if (mounted) {
        setState(() {
          _showPlayPauseAnimation = false;
        });
      }
    });

    _showControls();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onHover: (_) => _onHover(),
      onEnter: (_) => _onEnter(),
      onExit: (_) => _onExit(),
      child: GestureDetector(
        onTap: _onVideoTap,
        behavior: HitTestBehavior.opaque,
        child: Stack(
          children: [
            AnimatedOpacity(
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
              child: _mount ? _buildControls() : const SizedBox.shrink(),
            ),
            if (_showAudioTracks) _buildAudioTracksOverlay(),
            if (_showSubtitleTracks) _buildSubtitleTracksOverlay(),
            if (_showPlayPauseAnimation) _buildPlayPauseAnimation(),
          ],
        ),
      ),
    );
  }

  Widget _buildPlayPauseAnimation() {
    final isPlaying = widget.state.widget.controller.player.state.playing;

    return Positioned.fill(
      child: Container(
        color: Colors.black.withOpacity(0.3),
        child: Center(
          child: SizedBox(
            width: 100,
            height: 100,
            child: Icon(
              isPlaying ? Icons.play_arrow : Icons.pause,
              color: Colors.white,
              size: 50,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildControls() {
    return Column(
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
        _buildMiddleBar(),
      ],
    );
  }

  Widget _buildMiddleBar() {
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
          _buildAudioTrackButton(),
          _buildSubtitleTrackButton(),

          MaterialDesktopFullscreenButton(),
        ],
      ),
    );
  }

  Widget _buildAudioTrackButton() {
    final currentAudio =
        widget.state.widget.controller.player.state.track.audio;
    return MaterialDesktopCustomButton(
      onPressed: _toggleAudioTracks,
      icon: Icon(
        Icons.audiotrack,
        color: currentAudio.id != 'auto' ? Colors.blue : Colors.white,
      ),
      iconSize: 22,
    );
  }

  Widget _buildSubtitleTrackButton() {
    final currentSubtitle =
        widget.state.widget.controller.player.state.track.subtitle;
    return MaterialDesktopCustomButton(
      onPressed: _toggleSubtitleTracks,
      icon: Icon(
        Icons.subtitles,
        color: currentSubtitle.id != 'auto' ? Colors.blue : Colors.white,
      ),
      iconSize: 22,
    );
  }

  Widget _buildAudioTracksOverlay() {
    final audioTracks =
        widget.state.widget.controller.player.state.tracks.audio;
    final currentAudio =
        widget.state.widget.controller.player.state.track.audio;

    if (audioTracks.isEmpty) {
      return const SizedBox();
    }

    return Positioned(
      right: 16,
      bottom: 100,
      child: Container(
        width: 220, // Увеличил ширину для кодека
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.9),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.white24),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Заголовок
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                border: Border(bottom: BorderSide(color: Colors.white24)),
              ),
              child: Row(
                children: [
                  Icon(Icons.audiotrack, size: 16, color: Colors.white70),
                  const SizedBox(width: 8),
                  Text(
                    'Аудиодорожки',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            ...audioTracks.map((track) {
              final isSelected = track.id == currentAudio.id;
              return Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () => _setAudioTrack(track),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? Colors.blue.withOpacity(0.3)
                          : Colors.transparent,
                      border: Border(bottom: BorderSide(color: Colors.white12)),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          isSelected
                              ? Icons.check_circle
                              : Icons.radio_button_unchecked,
                          size: 16,
                          color: isSelected ? Colors.blue : Colors.white54,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                track.id == 'no'
                                    ? 'Отключить'
                                    : track.title ?? 'Аудио ${track.id}',
                                style: TextStyle(
                                  color: isSelected
                                      ? Colors.blue
                                      : Colors.white,
                                  fontSize: 13,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              if (track.codec != null &&
                                  track.codec!.isNotEmpty)
                                Text(
                                  track.codec!,
                                  style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: 10,
                                  ),
                                ),
                            ],
                          ),
                        ),
                        if (track.language != null &&
                            track.language!.isNotEmpty)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white10,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              track.language!,
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 10,
                              ),
                            ),
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
    );
  }

  Widget _buildSubtitleTracksOverlay() {
    final subtitleTracks =
        widget.state.widget.controller.player.state.tracks.subtitle;
    final currentSubtitle =
        widget.state.widget.controller.player.state.track.subtitle;

    if (subtitleTracks.isEmpty) {
      return const SizedBox();
    }

    return Positioned(
      right: 16,
      bottom: 100,
      child: Container(
        width: 220,
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.9),
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
                  Icon(Icons.subtitles, size: 16, color: Colors.white70),
                  const SizedBox(width: 8),
                  Text(
                    'Субтитры',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            ...subtitleTracks.map((track) {
              final isSelected = track.id == currentSubtitle.id;
              return Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () => _setSubtitleTrack(track),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? Colors.blue.withOpacity(0.3)
                          : Colors.transparent,
                      border: Border(
                        bottom: track == subtitleTracks.last
                            ? BorderSide.none
                            : BorderSide(color: Colors.white12),
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          isSelected
                              ? Icons.check_circle
                              : Icons.radio_button_unchecked,
                          size: 16,
                          color: isSelected ? Colors.blue : Colors.white54,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            track.id == 'no'
                                ? 'Отключить'
                                : track.title ?? 'Субтитры ${track.id}',
                            style: TextStyle(
                              color: isSelected ? Colors.blue : Colors.white,
                              fontSize: 13,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (track.language != null &&
                            track.language!.isNotEmpty &&
                            track.id != 'no')
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white10,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              track.language!,
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 10,
                              ),
                            ),
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
    );
  }
}
