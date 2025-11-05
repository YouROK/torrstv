class Trailer {
  String name;
  String site;
  String key;
  String type;

  String link;
  String poster;

  Trailer.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        site = json['site'],
        key = json['key'],
        type = json['type'],
        link = "https://www.youtube.com/watch?v=${json['key']}",
        poster = "https://img.youtube.com/vi/${json['key']}/0.jpg";
}
