import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:torrstv/core/settings/settings.dart';
import 'package:torrstv/core/settings/videoplayer_settings.dart';

final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError('SharedPreferences must be initialized in main');
});

final settingsProvider = Provider<Settings>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return Settings(prefs);
});

final videoPlayerSettingsProvider = Provider<VideoPlayerSettings>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return VideoPlayerSettings(prefs);
});
