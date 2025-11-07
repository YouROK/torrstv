import 'package:shared_preferences/shared_preferences.dart';

class VideoPlayerSettings {
  final SharedPreferences _prefs;

  VideoPlayerSettings(this._prefs);

  double getVolume() {
    return _prefs.getDouble("vp_volume") ?? 100.0;
  }

  Future<void> setVolume(double volume) async {
    await _prefs.setDouble("vp_volume", volume);
  }
}
