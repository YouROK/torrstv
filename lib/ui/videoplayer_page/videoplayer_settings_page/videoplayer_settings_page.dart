import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:media_kit/media_kit.dart';
import 'package:torrstv/core/settings/videoplayer_settings.dart';
import 'package:torrstv/l10n/app_localizations.dart';
import 'package:torrstv/ui/videoplayer_page/audio_filter_utils.dart';
import 'package:torrstv/ui/videoplayer_page/videoplayer_settings_page/widgets.dart';

class VideoPlayerSettingsPage extends ConsumerWidget {
  final Player? _player;

  VideoPlayerSettingsPage(this._player, {super.key});

  void _applyFilters(WidgetRef ref, VideoPlayerSettings s) {
    if (_player != null) {
      final channels = _player.state.track.audio.channelscount;
      applyAudioFiltersFromSettings(_player, s, channels);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;
    final channels = _player?.state.track.audio.channelscount ?? 0;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.playerSettingsTitle), backgroundColor: colorScheme.surface, elevation: 0),
      body: Container(
        padding: const EdgeInsets.all(24),
        alignment: Alignment.topCenter,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 800),
          child: ListView(
            children: [
              Text(l10n.audioFiltersSection, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const Divider(),
              BooleanSwitchSetting(
                title: l10n.enableAudioFilters,
                getValue: (s) => s.isAudioFilters(),
                setValue: (s, v) {
                  s.useAudioFilters(v);
                  _applyFilters(ref, s);
                },
              ),
              const SizedBox(height: 20),

              Text(l10n.panVolumeSection, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const Divider(),

              PanSliderSetting(
                title: l10n.frontPanVolume,
                getValue: (s) => s.getFrontPan(),
                setValue: (s, v) {
                  s.setFrontPan(v);
                  _applyFilters(ref, s);
                },
              ),

              PanSliderSetting(
                title: l10n.centerPanVolume,
                getValue: (s) => s.getCenterPan(),
                setValue: (s, v) {
                  s.setCenterPan(v);
                  _applyFilters(ref, s);
                },
              ),

              PanSliderSetting(
                title: l10n.surroundPanVolume,
                getValue: (s) => s.getMiddlePan(),
                setValue: (s, v) {
                  s.setMiddlePan(v);
                  _applyFilters(ref, s);
                },
              ),

              PanSliderSetting(
                title: l10n.rearPanVolume,
                getValue: (s) => s.getRearPan(),
                setValue: (s, v) {
                  s.setRearPan(v);
                  _applyFilters(ref, s);
                },
              ),
              const SizedBox(height: 20),

              Text(l10n.audioEffectsSection, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const Divider(),

              BooleanSwitchSetting(
                title: l10n.normalize,
                getValue: (s) => s.getNormalize(),
                setValue: (s, v) {
                  s.setNormalize(v);
                  _applyFilters(ref, s);
                },
              ),

              BooleanSwitchSetting(
                title: l10n.smoothing,
                getValue: (s) => s.getSmoothing(),
                setValue: (s, v) {
                  s.setSmoothing(v);
                  _applyFilters(ref, s);
                },
              ),

              BooleanSwitchSetting(
                title: l10n.stereoTo51,
                getValue: (s) => s.getStereoTo51(),
                setValue: (s, v) {
                  s.setStereoTo51(v);
                  _applyFilters(ref, s);
                },
              ),

              BooleanSwitchSetting(
                title: l10n.sevenOneTo51,
                getValue: (s) => s.get71To51(),
                setValue: (s, v) {
                  s.set71To51(v);
                  _applyFilters(ref, s);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
