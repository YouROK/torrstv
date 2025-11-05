import 'dart:convert';

import 'package:torrstv/core/utils/http.dart';
import 'package:torrstv/data/tmdb/collection.dart';
import 'package:torrstv/data/tmdb/entity.dart';
import 'package:torrstv/data/tmdb/genre.dart';
import 'package:torrstv/data/tmdb/search.dart';

class Tmdb {
  static const apiKey = "45ddf563ac3fb845f2d5c363190d1a33";

  // static const apiHost = "api.themoviedb.org";
  static const apiHost = "torrs.ru";
  static const subpath = "/tmdb";

  static List<Genre> genres = List.empty(growable: true);
  static String tmdbLang = "ru";

  static void init() async {
    tmdbLang = "ru";
    if (tmdbLang == "iw") tmdbLang = "he";
    if (tmdbLang == "in") tmdbLang = "id";
    if (tmdbLang == "ji") tmdbLang = "yi";
    if (tmdbLang == "lv") tmdbLang = "en";

    var resp = await httpGetCache('https://$apiHost$subpath/3/genre/movie/list?api_key=$apiKey&language=ru');
    var body = resp.data ?? "";
    if (body.isNotEmpty) {
      final json = jsonDecode(body);
      final gens = (json['genres'] as List<dynamic>).map((e) => Genre.fromJson(e as Map<String, dynamic>));
      genres.addAll(gens);
    }
    resp = await httpGetCache('https://$apiHost$subpath/3/genre/tv/list?api_key=$apiKey&language=ru');
    body = resp.data ?? "";
    if (body.isNotEmpty) {
      final json = jsonDecode(body);
      final gens = (json['genres'] as List<dynamic>).map((e) => Genre.fromJson(e as Map<String, dynamic>));
      genres.addAll(gens);
    }
    final ids = genres.map((e) => e.id).toSet();
    genres.retainWhere((x) => ids.remove(x.id));
  }

  static Future<Entity> video(String endpoint, String lang) async {
    Map<String, dynamic> params = {};
    params["api_key"] = apiKey;

    var llang = lang;
    if (llang.isEmpty) llang = tmdbLang;

    params["language"] = llang;
    params["append_to_response"] = "videos,images";
    String ll = "ru,en,null";
    if (llang != "ru" && llang != "en") ll = "$llang,$ll";
    params["include_image_language"] = ll;

    final uri = Uri(scheme: 'https', host: apiHost, path: '$subpath/3/$endpoint', queryParameters: params);

    final resp = await httpGetCache(uri.toString());
    final body = resp.data ?? "";
    if (body.isEmpty) return Entity.empty();

    final json = jsonDecode(body);
    var ent = Entity.fromJson(json);
    fixEnt(ent);
    return ent;
  }

  static Future<List<Entity>> videos(String endpoint, Map<String, dynamic> params, String lang) async {
    params["api_key"] = apiKey;
    params["language"] = lang;
    params["include_adult"] = "false";
    // params["append_to_response"] = "videos,images";

    final uri = Uri(scheme: 'https', host: apiHost, path: '$subpath/3/$endpoint', queryParameters: params);

    final resp = await httpGetCache(uri.toString());
    final body = resp.data ?? "";

    if (body.isEmpty) {
      return List.empty();
    }

    final json = jsonDecode(body);

    var srch = SearchResult.fromJson(json);
    var ents = List<Entity>.empty(growable: true);
    for (var e in srch.results) {
      var ent = e.toEntity();
      fixEnt(ent);
      ents.add(ent);
    }

    return ents;
  }

  static Future<List<Entity>> collection(int id, String lang) async {
    if (id == -1) return List.empty();
    var endpoint = "collection/$id";
    var params = <String, String>{};
    params["api_key"] = apiKey;
    params["language"] = lang;

    final uri = Uri(scheme: 'https', host: apiHost, path: '$subpath/3/$endpoint', queryParameters: params);

    final resp = await httpGetCache(uri.toString());
    final body = resp.data ?? "";

    if (body.isEmpty) {
      return List.empty();
    }

    final json = jsonDecode(body);

    var col = CollectionResults.fromJson(json);
    return col.parts;
  }

  static Future<List<Entity>> recommendations(Entity ent, int page) async {
    var endpoint = "${ent.media_type}/${ent.id}/recommendations";
    var params = <String, String>{};
    params["page"] = "$page";
    var srch = await videos(endpoint, params, "ru");
    if (srch.isEmpty) {
      endpoint = "${ent.media_type}/${ent.id}/similar";
      srch = await videos(endpoint, params, "ru");
    }
    return srch;
  }

  static void fixEnt(Entity ent) {
    if (ent.isEmpty() || (ent.title.isEmpty && ent.name.isEmpty)) return;

    if (ent.media_type.isEmpty) {
      if (ent.title.isEmpty) {
        ent.media_type = "tv";
      } else if (ent.name.isEmpty) {
        ent.media_type = "movie";
      }
    }

    if (ent.title.isEmpty && ent.name.isNotEmpty) ent.title = ent.name;

    if ((ent.original_title.isEmpty) && ent.original_name.isNotEmpty) ent.original_title = ent.original_name;

    if ((ent.release_date.isNotEmpty) && (ent.release_date.length) >= 4) {
      ent.year = ent.release_date.substring(0, 4);
    } else if ((ent.first_air_date.isNotEmpty) && (ent.first_air_date.length) >= 4) {
      ent.year = ent.first_air_date.substring(0, 4);
    }

    if ((ent.release_date.isEmpty) && (ent.first_air_date.isNotEmpty)) ent.release_date = ent.first_air_date;

    ent.poster_path = imageUrl(ent.poster_path);
    ent.backdrop_path = imageUrl(ent.backdrop_path);

    ent.production_companies ??= ent.networks;

    if (ent.genres.isEmpty && ent.genre_ids.isNotEmpty) ent.genres = genres.where((e) => ent.genres.map((e) => e.id).contains(e.id)).toList();
  }

  static String imageUrl(String path) {
    if ((path.isEmpty) || path.startsWith("http")) return path;
    // return "https://imagetmdb.com/t/p/original$path";
    // return "https://image.tmdb.org/t/p/original/$path";
    return "https://torrs.ru/tmdbimg/t/p/original$path";
  }

  static void fixTrailers(Entity ent) {}
}
