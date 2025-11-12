import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:torrstv/core/settings/settings_providers.dart';
import 'package:torrstv/core/settings/videoplayer_settings.dart';

class PanSliderSetting extends ConsumerWidget {
  final String title;
  final double Function(VideoPlayerSettings settings) getValue;
  final void Function(VideoPlayerSettings settings, double value) setValue;

  const PanSliderSetting({super.key, required this.title, required this.getValue, required this.setValue});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(videoPlayerSettingsProvider);
    final initialValue = getValue(settings);

    final panValueProvider = StateProvider.autoDispose<double>((_) => initialValue);
    final panValue = ref.watch(panValueProvider);
    final panValueNotifier = ref.read(panValueProvider.notifier);

    final textController = TextEditingController(text: panValue.toStringAsFixed(3));
    ref.listen(panValueProvider, (previous, next) {
      if (double.tryParse(textController.text) != next) {
        textController.text = next.toStringAsFixed(3);
      }
    });

    final colorScheme = Theme.of(context).colorScheme;

    void saveValue(double value) {
      setValue(ref.read(videoPlayerSettingsProvider), value);
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: colorScheme.onSurface),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: Slider(
                  value: panValue,
                  min: 0.0,
                  max: 2.0,
                  divisions: 1000,
                  label: panValue.toStringAsFixed(3),
                  onChanged: (double newValue) {
                    panValueNotifier.state = newValue;
                    saveValue(newValue);
                  },
                ),
              ),
              const SizedBox(width: 16),
              SizedBox(
                width: 80,
                child: TextField(
                  controller: textController,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  textAlign: TextAlign.center,
                  style: TextStyle(color: colorScheme.onSurface),
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  onSubmitted: (String text) {
                    double? newValue = double.tryParse(text);
                    if (newValue != null && newValue >= 0.0 && newValue <= 2.0) {
                      panValueNotifier.state = newValue;
                      saveValue(newValue);
                    } else {
                      textController.text = panValue.toStringAsFixed(3);
                    }
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class BooleanSwitchSetting extends ConsumerWidget {
  final String title;
  final bool Function(VideoPlayerSettings settings) getValue;
  final void Function(VideoPlayerSettings settings, bool value) setValue;

  const BooleanSwitchSetting({super.key, required this.title, required this.getValue, required this.setValue});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(videoPlayerSettingsProvider);
    final currentValue = getValue(settings);
    final settingsNotifier = ref.read(videoPlayerSettingsProvider);
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: colorScheme.onSurface),
          ),
          Switch(
            value: currentValue,
            onChanged: (bool newValue) {
              setValue(settingsNotifier, newValue);
              ref.invalidate(videoPlayerSettingsProvider);
            },
          ),
        ],
      ),
    );
  }
}
