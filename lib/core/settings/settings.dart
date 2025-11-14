import 'package:shared_preferences/shared_preferences.dart';

class Settings {
  final SharedPreferences _prefs;

  Settings(this._prefs);

  String getTSAuth() {
    return _prefs.getString("ts_auth") ?? "";
  }

  void setTSAuth(String auth) {
    _prefs.setString("ts_auth", auth);
  }

  String getTSHost() {
    String host = _prefs.getString("ts_host") ?? "http://127.0.0.1:8090";
    return host.replaceAll(RegExp(r'/*$'), '');
  }

  void setTSHost(String host) {
    var shost = host.trim();
    if (!shost.startsWith("http://") && !shost.startsWith("https://")) {
      shost = "http://$shost";
    }
    _prefs.setString("ts_host", shost);
  }

  void savePosition(String hash, int id, Duration position) {
    _prefs.setDouble('position-$hash-$id', position.inSeconds.toDouble());
  }

  int loadPosition(String hash, int id) {
    return _prefs.getDouble('position-$hash-$id')?.toInt() ?? 0;
  }

  void saveDuration(String hash, int id, Duration duration) {
    _prefs.setDouble('duration-$hash-$id', duration.inSeconds.toDouble());
  }

  int loadDuration(String hash, int id) {
    return _prefs.getDouble('duration-$hash-$id')?.toInt() ?? 0;
  }

  void setViewing(String hash, int id, bool viewing) {
    if (viewing) {
      _prefs.setBool('viewing-$hash-$id', true);
    } else {
      _prefs.remove('viewing-$hash-$id');
    }
  }

  bool getViewing(String hash, int id) {
    return _prefs.getBool('viewing-$hash-$id') ?? false;
  }

  void clearViewing(String hash) {
    final remKeys = _prefs.getKeys().where((k) => k.startsWith('position-$hash') || k.startsWith('duration-$hash') || k.startsWith('viewing-$hash'));
    for (var k in remKeys) {
      _prefs.remove(k);
    }
  }

  String getOuterPlayer() {
    return _prefs.getString('outer-player') ?? "";
  }

  void setOuterPlayer(String player) async {
    _prefs.setString('outer-player', player);
  }

  bool isOuterPlayerEnable() {
    return _prefs.getBool('outer-player-enable') ?? false;
  }

  void setOuterPlayerEnable(bool enable) async {
    _prefs.setBool('outer-player-enable', enable);
  }
}
