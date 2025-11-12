import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:media_kit/media_kit.dart';
import 'package:torrstv/core/settings/videoplayer_settings.dart';
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
    final colorScheme = Theme.of(context).colorScheme;
    final channels = _player?.state.track.audio.channelscount ?? 0;

    return Scaffold(
      appBar: AppBar(title: const Text('Player Settings'), backgroundColor: colorScheme.surface, elevation: 0),
      body: Container(
        padding: const EdgeInsets.all(24),
        alignment: Alignment.topCenter,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 800),
          child: ListView(
            children: [
              const Text('Audio filters', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const Divider(),
              BooleanSwitchSetting(
                title: 'Enable audio filters (Включиьт адуио фильтры)',
                getValue: (s) => s.isAudioFilters(),
                setValue: (s, v) {
                  s.useAudioFilters(v);
                  _applyFilters(ref, s);
                },
              ),
              const SizedBox(height: 20),

              const Text('Панорамирование звука (Pan Volume)', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const Divider(),

              PanSliderSetting(
                title: 'Front Pan Volume (Передние колонки)',
                getValue: (s) => s.getFrontPan(),
                setValue: (s, v) {
                  s.setFrontPan(v);
                  _applyFilters(ref, s);
                },
              ),

              PanSliderSetting(
                title: 'Center Pan Volume (Центральная колонка, голос)',
                getValue: (s) => s.getCenterPan(),
                setValue: (s, v) {
                  s.setCenterPan(v);
                  _applyFilters(ref, s);
                },
              ),

              PanSliderSetting(
                title: 'Surround Pan Volume (Боковые колонки, 7.1 только)',
                getValue: (s) => s.getMiddlePan(),
                setValue: (s, v) {
                  s.setMiddlePan(v);
                  _applyFilters(ref, s);
                },
              ),

              PanSliderSetting(
                title: 'Rear Pan Volume (Задние колонки)',
                getValue: (s) => s.getRearPan(),
                setValue: (s, v) {
                  s.setRearPan(v);
                  _applyFilters(ref, s);
                },
              ),
              const SizedBox(height: 20),

              const Text('Аудио-эффекты', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const Divider(),

              BooleanSwitchSetting(
                title: 'Normalize (Нормализация громкости)',
                getValue: (s) => s.getNormalize(),
                setValue: (s, v) {
                  s.setNormalize(v);
                  _applyFilters(ref, s);
                },
              ),

              BooleanSwitchSetting(
                title: 'Smoothing (Сглаживание пиков)',
                getValue: (s) => s.getSmoothing(),
                setValue: (s, v) {
                  s.setSmoothing(v);
                  _applyFilters(ref, s);
                },
              ),

              BooleanSwitchSetting(
                title: 'Stereo to 5.1 (Разбить stereo на 5.1 каналы)',
                getValue: (s) => s.getStereoTo51(),
                setValue: (s, v) {
                  s.setStereoTo51(v);
                  _applyFilters(ref, s);
                },
              ),

              BooleanSwitchSetting(
                title: '7.1 to 5.1 (Преобразовать 7.1 в 5.1 каналы)',
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
