class MovieResponseModel {
  MovieResponseModel({
    required this.page,
    required this.results,
    required this.totalPages,
    required this.totalResults,
  });

  int page;
  List<MovieModel> results;
  int totalPages;
  int totalResults;

  factory MovieResponseModel.fromJson(Map<String, dynamic> json) =>
      MovieResponseModel(
        page: json["page"],
        results: List<MovieModel>.from(
            json["results"].map((x) => MovieModel.fromJson(x))),
        totalPages: json["total_pages"],
        totalResults: json["total_results"],
      );
}

class MovieModel {
  MovieModel({
    this.backdropPath,
    required this.id,
    required this.originalTitle,
    required this.overview,
    required this.popularity,
    this.posterPath,
    required this.releaseDate,
    required this.title,
    required this.voteAverage,
    required this.voteCount,
  });

  String? backdropPath;
  int id;
  String originalTitle;
  String overview;
  double popularity;
  String? posterPath;
  DateTime releaseDate;
  String title;
  double voteAverage;
  int voteCount;

  factory MovieModel.fromJson(Map<String, dynamic> json) => MovieModel(
        backdropPath: json["backdrop_path"] ?? '',
        id: json["id"],
        originalTitle: json["original_title"],
        overview: json["overview"],
        popularity: json["popularity"]?.toDouble(),
        posterPath: json["poster_path"] ?? '',
        releaseDate: DateTime.parse(json["release_date"]),
        title: json["title"],
        voteAverage: json["vote_average"]?.toDouble(),
        voteCount: json["vote_count"],
      );
}
