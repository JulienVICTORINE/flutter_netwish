import 'package:flutter_netwish/types/genreMovie.dart';

class Movie {
  final String? title;
  final String? overview;
  final String? release_date;
  final String? poster_path;
  final double? voteAverage;
  final List<Genre>? genres;

  Movie({
    required this.title,
    required this.overview,
    required this.release_date,
    required this.poster_path,
    required this.voteAverage,
    required this.genres,
  });

}