class TmdbId {
  int id = 0;
  String media_type = "";

  TmdbId(this.id, this.media_type);

  TmdbId.fromJson(Map<String, dynamic> json) : id = json['id'] ?? 0, media_type = json['media_type'] ?? "";
}
