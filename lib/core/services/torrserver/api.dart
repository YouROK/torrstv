import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:torrstv/core/settings/settings.dart';
import 'package:torrstv/core/settings/settings_providers.dart';
import 'package:torrstv/core/utils/http.dart';

final torrServerApiProvider = Provider<TorrServerApi>((ref) {
  final settings = ref.watch(settingsProvider);
  return TorrServerApi(settings);
});

class TorrServerApi {
  final Settings _settings;

  TorrServerApi(this._settings);

  //url
  String getTSUrl() {
    return _settings.getTSHost();
  }

  //Echo
  Future<String> echo() async {
    final url = _settings.getTSHost();
    final auth = _settings.getTSAuth();

    try {
      final resp = await httpGet("$url/echo", auth);
      if (resp.isSuccess) return resp.data ?? "";
      return "";
    } catch (e) {
      print(e.toString());
      return "";
    }
  }

  //Settings
  Future<Map<String, dynamic>> getSettings() async {
    final url = _settings.getTSHost();
    final auth = _settings.getTSAuth();
    final action = {"action": "get"};
    try {
      final resp = await httpPost("$url/settings", auth, body: action);
      if (resp.isSuccess) return json.decode(resp.data ?? "{}");
      return {};
    } catch (e) {
      print(e.toString());
      return {};
    }
  }

  Future<bool> setSettings(Map<String, dynamic> settings) async {
    final url = _settings.getTSHost();
    final auth = _settings.getTSAuth();
    final Map<String, dynamic> js = {"action": "set"};
    js["sets"] = settings;
    try {
      final resp = await httpPost("$url/settings", auth, body: js);
      return resp.isSuccess;
    } catch (e) {
      print(e.toString());
      return false;
    }
  }

  //Torrents list
  Future<List<dynamic>> listTorrents() async {
    final url = _settings.getTSHost();
    final auth = _settings.getTSAuth();
    final action = {"action": "list"};
    final resp = await httpPost("$url/torrents", auth, body: action);
    if (resp.isSuccess) return json.decode(resp.data ?? "[]");
    throw Exception("Failed to list torrents");
  }

  //Add magnet
  Future<bool> addTorrent(String magnet, String title, String poster, String category) async {
    final url = _settings.getTSHost();
    final auth = _settings.getTSAuth();
    final Map<String, dynamic> action = {"action": "add"};
    action["link"] = magnet;
    action["title"] = title;
    action["poster"] = poster;
    action["category"] = category;
    action["save_to_db"] = true;

    final resp = await httpPost("$url/torrents", auth, body: action);
    if (resp.isSuccess) return true;
    throw Exception("Failed to list torrents");
  }

  Future<bool> remTorrent(String hash) async {
    final url = _settings.getTSHost();
    final auth = _settings.getTSAuth();
    final Map<String, dynamic> action = {"action": "rem"};
    action["hash"] = hash;

    final resp = await httpPost("$url/torrents", auth, body: action);
    if (resp.isSuccess) return true;
    throw Exception("Failed to list torrents");
  }

  Future<Map<String, dynamic>> getTorrent(String hash) async {
    final url = _settings.getTSHost();
    final auth = _settings.getTSAuth();
    final Map<String, dynamic> action = {"action": "get"};
    action["hash"] = hash;
    final resp = await httpPost("$url/torrents", auth, body: action);
    if (resp.isSuccess) return json.decode(resp.data ?? "{}");
    throw Exception("Failed to list torrents");
  }

  //Shutdown
  Future<bool> shutdown() async {
    final url = _settings.getTSHost();
    final auth = _settings.getTSAuth();

    try {
      final resp = await httpGet("$url/shutdown", auth);
      return resp.isSuccess;
    } catch (e) {
      print(e.toString());
      return false;
    }
  }

  Future<bool> preload(String hash, int id) async {
    final url = _settings.getTSHost();
    final auth = _settings.getTSAuth();

    try {
      final resp = await httpGet("$url/stream/preload?link=$hash&index=$id&preload", auth);
      return resp.isSuccess;
    } catch (e) {
      print(e.toString());
      return false;
    }
  }
}
