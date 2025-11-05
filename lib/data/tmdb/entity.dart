import 'package:torrstv/data/tmdb/genre.dart';
import 'package:torrstv/data/tmdb/trailer.dart';

class Entity {
  bool adult = false;
  String backdrop_path = "";

  int belongs_to_collection_id = -1;
  int budget = 0;
  String character = "";
  String credit_id = "";

  // var episode_run_time;
  String first_air_date = "";
  List<int> genre_ids = List.empty();
  List<Genre> genres = List.empty();
  String homepage = "";
  int id = -1;

  // var images;
  String imdb_id = "";
  bool in_production = false;

  // var languages;
  String last_air_date = "";
  String media_type = "";
  String name = "";
  var networks = List.empty();
  int number_of_episodes = 0;
  int number_of_seasons = 0;

  // var origin_country;
  String original_language = "";
  String original_name = "";
  String original_title = "";
  String overview = "";

  // double popularity;
  String poster_path = "";
  var production_companies = List.empty();
  var production_countries = List.empty();
  String release_date = "";
  int revenue = 0;
  int runtime = 0;

  // var seasons;
  // var spoken_languages;
  String status = "";
  String tagline = "";
  String title = "";
  String type = "";
  bool video = false;
  double vote_average = 0;
  int vote_count = 0;
  String year = "";
  List<Trailer> videos = List.empty();

  String getTitle() {
    return title.isEmpty ? original_title : title;
  }

  String getPoster(String size) {
    if (poster_path.isEmpty) return "https://releases.yourok.ru/torr/emptyposter.png";
    var poster = poster_path;
    if (size.isNotEmpty) poster = poster.replaceFirst("original", size);
    return poster;
  }

  String getBackdrop(String size) {
    if (backdrop_path.isEmpty) return "https://releases.yourok.ru/torr/backdrop.png";
    var poster = backdrop_path;
    if (size.isNotEmpty) poster = backdrop_path.replaceFirst("original", size);
    return poster;
  }

  Entity.empty() : id = -1;

  bool isEmpty() => id == -1;

  Entity.fromJson(Map<String, dynamic> json)
    : adult = json['adult'] ?? false,
      backdrop_path = json['backdrop_path'] ?? "",
      belongs_to_collection_id = json['belongs_to_collection'] != null ? json['belongs_to_collection']["id"] : -1,
      budget = json['budget'] ?? 0,
      character = json['character'] ?? "",
      credit_id = json['credit_id'] ?? "",
      // episode_run_time = json['episode_run_time'],
      first_air_date = json['first_air_date'] ?? "",
      genre_ids = List<int>.from(json['genre_ids'] ?? List.empty()),
      //List<int>.from(json['genre_ids'].map((model) => int)),
      genres = List<Genre>.from(json['genres']?.map((model) => Genre.fromJson(model)) ?? List.empty()),
      homepage = json['homepage'] ?? "",
      id = json['id'] ?? -1,
      // images = json['images'],
      imdb_id = json['imdb_id'] ?? "",
      in_production = json['in_production'] ?? false,
      // languages = json['languages'],
      last_air_date = json['last_air_date'] ?? "",
      media_type = json['media_type'] ?? "",
      name = json['name'] ?? "",
      networks = json['networks'] ?? List.empty(),
      number_of_episodes = json['number_of_episodes'] ?? 0,
      number_of_seasons = json['number_of_seasons'] ?? 0,
      // origin_country = json['origin_country'],
      original_language = json['original_language'] ?? "",
      original_name = json['original_name'] ?? "",
      original_title = json['original_title'] ?? "",
      overview = json['overview'],
      // popularity = json['popularity'],
      poster_path = json['poster_path'] ?? "",
      production_companies = json['production_companies'] ?? List.empty(),
      production_countries = json['production_countries'] ?? List.empty(),
      release_date = json['release_date'] ?? "",
      revenue = json['revenue'] ?? 0,
      runtime = json['runtime'] ?? 0,
      // seasons = json['seasons'],
      // spoken_languages = json['spoken_languages'],
      status = json['status'] ?? "",
      tagline = json['tagline'] ?? "",
      title = json['title'] ?? "",
      type = json['type'] ?? "",
      video = json['video'] ?? false,
      vote_average = json['vote_average'] ?? 0,
      vote_count = json['vote_count'] ?? 0,
      year = json['year'] ?? "",
      videos = List<Trailer>.from(json['videos']?['results']?.map((model) => Trailer.fromJson(model)) ?? List.empty());
}
