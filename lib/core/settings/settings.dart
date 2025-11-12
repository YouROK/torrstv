import 'package:shared_preferences/shared_preferences.dart';

class Settings {
  final SharedPreferences _prefs;

  Settings(this._prefs);

  String getTSAuth() {
    return _prefs.getString("ts_auth") ?? "";
  }

  Future<void> setTSAuth(String auth) async {
    await _prefs.setString("ts_auth", auth);
  }

  String getTSHost() {
    String host = _prefs.getString("ts_host") ?? "http://127.0.0.1:8090";
    return host.replaceAll(RegExp(r'/*$'), '');
  }

  Future<void> setTSHost(String host) async {
    var shost = host.trim();
    if (!shost.startsWith("http://") && !shost.startsWith("https://")) {
      shost = "http://$shost";
    }
    await _prefs.setString("ts_host", shost);
  }

  Future<void> savePosition(String hash, int id, Duration position) async {
    await _prefs.setDouble('position-$hash-$id', position.inSeconds.toDouble());
  }

  Future<int> loadPosition(String hash, int id) async {
    return _prefs.getDouble('position-$hash-$id')?.toInt() ?? 0;
  }

  Future<void> saveDuration(String hash, int id, Duration duration) async {
    await _prefs.setDouble('duration-$hash-$id', duration.inSeconds.toDouble());
  }

  Future<int> loadDuration(String hash, int id) async {
    return _prefs.getDouble('duration-$hash-$id')?.toInt() ?? 0;
  }

  Future<void> setViewing(String hash, int id, bool viewing) async {
    if (viewing) {
      await _prefs.setBool('viewing-$hash-$id', true);
    } else {
      await _prefs.remove('viewing-$hash-$id');
    }
  }

  Future<bool> getViewing(String hash, int id) async {
    return _prefs.getBool('viewing-$hash-$id') ?? false;
  }

  String getOuterPlayer() {
    return _prefs.getString('outer-player') ?? "";
  }

  void setOuterPlayer(String player) async {
    _prefs.setString('outer-player', player);
  }
}
