import 'package:flutter/material.dart';
import 'package:flutter_netwish/views/homeScreen.dart';
import 'package:flutter_netwish/views/movieScreen.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      initialRoute: '/',
      routes: {
        // Routes de l'application
        '/': (context) => const HomeScreen(),
        '/movie': (context) => const MovieScreen()
      },
    );
  }
}
