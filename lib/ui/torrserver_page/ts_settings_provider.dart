import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:torrstv/core/services/torrserver/api.dart';

final torrServerVersionProvider = FutureProvider<String>((ref) async {
  final api = ref.watch(torrServerApiProvider);
  return api.echo();
});

final torrServerSettingsFutureProvider = FutureProvider<Map<String, dynamic>>((ref) async {
  final api = ref.watch(torrServerApiProvider);
  return api.getSettings();
});

class TorrServerSettingsNotifier extends StateNotifier<Map<String, dynamic>> {
  final Ref _ref;

  TorrServerSettingsNotifier(this._ref) : super({});

  void initialize(Map<String, dynamic> initialSettings) {
    if (state.isEmpty) {
      state = Map.from(initialSettings);
    }
  }

  void updateSetting(String key, dynamic newValue) {
    state = Map.from(state)..[key] = newValue;
  }

  Future<bool> saveSettings() async {
    return _ref.watch(torrServerApiProvider).setSettings(state);
  }
}

final torrServerSettingsNotifierProvider = StateNotifierProvider<TorrServerSettingsNotifier, Map<String, dynamic>>((ref) {
  return TorrServerSettingsNotifier(ref);
});
