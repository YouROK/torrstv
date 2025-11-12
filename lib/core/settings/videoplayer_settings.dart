import 'package:shared_preferences/shared_preferences.dart';

class VideoPlayerSettings {
  final SharedPreferences _prefs;

  VideoPlayerSettings(this._prefs);

  //Vol
  double getVolume() {
    return _prefs.getDouble("vp_volume") ?? 100.0;
  }

  void setVolume(double volume) {
    _prefs.setDouble("vp_volume", volume);
  }

  //Pan

  bool isAudioFilters() {
    return _prefs.getBool("use_audio_filters") ?? false;
  }

  void useAudioFilters(bool enable) {
    _prefs.setBool("use_audio_filters", enable);
  }

  double getFrontPan() {
    return _prefs.getDouble("pan_front_vol") ?? 1.0;
  }

  void setFrontPan(double volume) {
    _prefs.setDouble("pan_front_vol", volume);
  }

  double getCenterPan() {
    return _prefs.getDouble("pan_center_vol") ?? 1.0;
  }

  void setCenterPan(double volume) {
    _prefs.setDouble("pan_center_vol", volume);
  }

  double getMiddlePan() {
    //7.1 only
    return _prefs.getDouble("pan_mid_vol") ?? 1.0;
  }

  void setMiddlePan(double volume) {
    //7.1 only
    _prefs.setDouble("pan_mid_vol", volume);
  }

  double getRearPan() {
    return _prefs.getDouble("pan_rear_vol") ?? 1.0;
  }

  void setRearPan(double volume) {
    _prefs.setDouble("pan_rear_vol", volume);
  }

  bool getNormalize() {
    return _prefs.getBool("af_normalize") ?? false;
  }

  void setNormalize(bool enable) {
    _prefs.setBool("af_normalize", enable);
  }

  bool getSmoothing() {
    return _prefs.getBool("af_smoothing") ?? false;
  }

  void setSmoothing(bool enable) {
    _prefs.setBool("af_smoothing", enable);
  }

  bool getStereoTo51() {
    return _prefs.getBool("stereo_to_51") ?? false;
  }

  void setStereoTo51(bool enable) {
    _prefs.setBool("stereo_to_51", enable);
  }

  bool get71To51() {
    return _prefs.getBool("71_to_51") ?? false;
  }

  void set71To51(bool enable) {
    _prefs.setBool("71_to_51", enable);
  }
}
