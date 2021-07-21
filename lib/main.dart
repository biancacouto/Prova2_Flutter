import 'package:flutter/material.dart';
import 'package:music_ap/Pages/HomePage.dart';
import 'package:music_ap/controllers/ArtistController.dart';
import 'package:music_ap/controllers/MusicController.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => MusicController(),
          lazy: false,
        ),
        ChangeNotifierProvider(
          create: (_) => ArtistsController(),
          lazy: false,
        )
      ],
      child: MaterialApp(
        title: 'Prova 2 - PDM',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.red,
        ),
        home: HomePage(),
      ),
    );
  }
}
