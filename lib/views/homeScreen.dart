import 'dart:html';
// import 'dart:js_interop';

import 'package:flutter/material.dart';
import 'package:flutter_netwish/types/movie.dart';
import 'package:flutter_netwish/types/genreMovie.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:flutter_netwish/utils/api.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Movie> _movies = []; // liste des films
  List<Genre> _genres = []; // liste des genres
  List<Genre> _selectedGenres = []; // liste des genres sélectionnés


  @override
  void initState() {
    super.initState();
    getGenres().then((value) => {
      setState(() => _genres = value),
      getMovies("", _genres).then((value) => setState(() => _movies = value))
    });
  }

  Widget build(BuildContext context) {
    final TextEditingController _searchController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        elevation: 5.0, // mettre une ombre sous l'appBar
        title: const Text(
          'Netwish',
          style: TextStyle(color: Colors.red),
        ),
        centerTitle: true,
        leading: Padding(
          padding: const EdgeInsets.all(4.0),
          child: Image.asset('assets/images/netflix_logo.png'),
        ),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              Alert(
                  context: context,
                  title: "Rechercher un film",
                  style: AlertStyle(
                    // mettre le titre de l'alerte en rouge
                    titleStyle: TextStyle(
                      color: Colors.red,
                      fontSize: 20.0,
                    ),
                    backgroundColor: Colors.black,
                  ),
                  content: Column(
                    children: [
                      TextField(
                        decoration: InputDecoration(
                          // mettre une icône et un texte dans le champ de texte
                          icon: Icon(Icons.search),
                          labelText: 'Name of the movie',
                        ),
                        controller: _searchController,
                      ),
                      DropdownButton(
                        items: _genres
                          .map((genre) => DropdownMenuItem(
                              value: genre,
                              child: Text(genre.name),
                            ))
                          .toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectedGenres.add(value as Genre);
                          });
                        },
                        hint: Text('Select a genre'),
                      ),
                      for (var genre in _selectedGenres)
                        Chip(
                          label: Text(genre.name),
                          onDeleted: () {
                            setState(() {
                              _selectedGenres.remove(genre);
                            });
                          },
                        ),
                    ],
                  ),
                  buttons: [
                    // créer un bouton dans l'alerte
                    DialogButton(
                      onPressed: () {
                        getMovies(_searchController.text, _genres).then((value) {
                          setState(() {
                            _movies = value.where((movie) {
                              if (_selectedGenres.isEmpty) {
                                return true;
                              }
                              for (var genre in movie.genres!) {
                                if (_selectedGenres.contains(genre)) {
                                  return true;
                                }
                              }
                              return false;
                            }).toList();
                            _searchController.clear();
                            });
                          });
                        Navigator.pop(context); // permet de fermer l'alerte
                      },
                      child: Text(
                        "Search",
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                    )
                  ]).show();
            },
          ),
        ],
      ),

      // afficher une card pour chaque film contenu dans _movies
      body: GridView.builder(
        itemCount: _movies.length,
        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 200.0,
            crossAxisSpacing: 10.0,
            mainAxisSpacing: 10.0),
        itemBuilder: (BuildContext context, int index) {
          return GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, '/movie',
                  arguments: _movies[
                      index]); // permet de naviguer vers la page de film en passant le film en argument
            },
            child: Card(
              elevation: 5.0,
              child: Image.network(
                _movies[index].poster_path == null
                    ? 'https://image.tmdb.org/t/p/w200/8Y43POKjjKDGI9MH89NW0NAzzp8.jpg'
                    : 'https://image.tmdb.org/t/p/w200/${_movies[index].poster_path}', // charge l'image depuis internet
                fit: BoxFit.cover, // fit permet de mettre l'image à la taille du cadre
              ),
            ),
          );
        },
      ),

      // body: ListView(
      //   children: [
      //     for (var movie in _movies) // on boucle sur la liste de films
      //       // pour afficher chaque film
      //       // j'englobe Card dans un GestureDetector et à l'appuie sur la carte, j'ouvre un movieScreen
      //       // avec en argument le "movie" que j'ai cliqué
      //       GestureDetector(
      //         onTap: () {
      //           Navigator.pushNamed(context, '/movie',
      //           arguments: movie); // permet de naviguer vers la page de film en passant le film en argument
      //         },
      //         child: Card(
      //           elevation: 5.0,
      //           child: Image.network(
      //             'https://image.tmdb.org/t/p/w500${movie.poster_path}', // charge l'image depuis internet
      //             fit: BoxFit.cover, // fit permet de mettre l'image à la taille du cadre
      //           ),
      //         ),
      //       ),
      //   ],
      // ),
    );
  }
}
