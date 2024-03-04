import 'dart:convert';
import 'package:flutter_netwish/types/movie.dart';
import 'package:flutter_netwish/types/genreMovie.dart';
import 'package:http/http.dart' as http;

final base_url = 'https://api.themoviedb.org/3/';
final api_key = '26a145d058cf4d1b17cbf084ddebedec';

// Fonction qui permet de récupérer les films
Future<List<Movie>> getMovies(String movieName, List<Genre> genres) async {
  var query = '';
  if (movieName.isNotEmpty) {
    // si movieName n'est pas vide alors on récupère les films correspondant à la recherche
    // on enlève les espaces dans la recherche
    movieName = movieName.replaceAll(' ', '+');
    query = '${base_url}/search/movie?api_key=$api_key&query=$movieName&language=fr-FR&page=1';
  } else {
    // Si movieName est vide, on récupère les films populaires
    query = '${base_url}movie/popular?api_key=$api_key&language=fr-FR&page=1';
  }
  final response = await http.get(Uri.parse(query));

  if (response.statusCode == 200) {
    final result = jsonDecode(response.body);
    final List<Movie> movies = [];
    for (var movie in result['results']) {
      // On cherche les genres correspondant à chaque film
      List<Genre> movieGenres = [];
      for (var genre_id in movie['genre_ids']) {
        final Genre genre = genres.firstWhere(
          (element) => element.id == genre_id,
          orElse: () => Genre(id: 0, name: 'Unknown')
        );

        if (genre.id != 0) {
          movieGenres.add(genre);
        }
      }

      movies.add(Movie(
        title: movie['title'], 
        overview: movie['overview'], 
        release_date: movie['release_date'], 
        poster_path: movie['poster_path'], 
        voteAverage: (movie['vote_average'] as num?)?.toDouble() ?? 0.0,
        genres: movieGenres,
      ));
    }
    return movies;
  } else {
    throw Exception('Falled to load movies');
  }
}


// Fonction qui permet de récupérer les genres
Future<List<Genre>> getGenres() async {
  final query = '${base_url}genre/movie/list?api_key=$api_key&language=fr-FR';
  final response = await http.get(Uri.parse(query));

  if (response.statusCode == 200) {
    final result = jsonDecode(response.body);
    final List<Genre> genres = [];
    for (var genre in result['genres']) {
      genres.add(Genre(
        id: genre['id'], 
        name: genre['name']
      ));
    }
    return genres;
  } else {
    throw Exception('Falled to load genres');
  }
}