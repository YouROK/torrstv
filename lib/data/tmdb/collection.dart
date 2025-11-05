import 'package:torrstv/core/tmdb/tmdb.dart';

import 'entity.dart';

class CollectionResults {
  List<Entity> parts = [];

  CollectionResults.fromJson(Map<String, dynamic> json) {
    if (json['parts'] != null) {
      parts = <Entity>[];
      json['parts'].forEach((v) {
        var res = Entity.fromJson(v);
        Tmdb.fixEnt(res);
        parts.add(res);
      });
    }
  }
}
