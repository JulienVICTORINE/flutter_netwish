import 'package:flutter/material.dart';
import 'package:flutter_netwish/types/movie.dart';

class MovieScreen extends StatelessWidget {
  const MovieScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final movie = ModalRoute.of(context)!.settings.arguments
        as Movie; // récupère les données passées en argument
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // revenir à la page précédente
          },
        ),
        title: Text(movie.title ?? 'Movie'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          movie.poster_path == null
              ? Text('No image')
              : Expanded(
                  // Expanded permet de prendre toute la place disponible dans la Column
                  child: Image.network(
                    'https://image.tmdb.org/t/p/w200/${movie.poster_path}',
                    fit: BoxFit.cover,
                  ),
                ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              for (var genre in movie.genres ?? [])
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Chip(
                  label: Text(genre.name),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              movie.overview ?? 'No overview',
              style: TextStyle(fontSize: 20.0),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Release date: ${movie.release_date ?? 'No relase date'}',
              style: TextStyle(fontSize: 20.0),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Vote average : ${movie.voteAverage ?? "No vote average"}',
              style: TextStyle(fontSize: 20.0),
            ),
          ),
        ],
      ),
    );
  }
}
