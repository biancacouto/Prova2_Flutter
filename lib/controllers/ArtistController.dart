import 'package:flutter/cupertino.dart';
import 'package:music_ap/models/Artist.dart';
import '../util/env.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ArtistsController extends ChangeNotifier {
  ArtistsController() {
    index();
  }

  List<Artist> artists = [];

  bool _isLoading = false;
  bool get isLoading => _isLoading;
  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  Future<void> index() async {
    isLoading = true;
    artists.clear();

    try {
      var url = Uri.https(Env.FIREBASE_URL, '/artists.json');

      var resp = await http.get(url);

      print(resp.body);

      Map<String, dynamic> data =
          new Map<String, dynamic>.from(json.decode(resp.body));

      data.forEach((key, value) {
        artists.add(Artist(
          id: key,
          name: value['name'],
          picture: value['picture'],
          password: value['password'],
          email: value['email'],
        ));
      });

      isLoading = false;
    } catch (error) {
      throw error;
    }
  }

  Future<void> create(Artist artistData) async {
    var url = Uri.https(Env.FIREBASE_URL, '/artists.json');

    await http.post(url,
        body: jsonEncode({
          'name': artistData.name,
          'picture': artistData.picture,
          'email': artistData.email,
          'password': artistData.password,
        }));

    index();
    notifyListeners();
  }

  Future<void> delete(String artistId) async {
    var url = Uri.https(Env.FIREBASE_URL, '/artists/$artistId.json');

    try {
      await http.delete(url);
      index();
      notifyListeners();
    } catch (e) {}
  }

  Future<void> edit(String automakerId, Artist artistData) async {
    var url = Uri.https(Env.FIREBASE_URL, '/artists/$automakerId.json');

    try {
      await http.put(url,
          body: jsonEncode({
            'name': artistData.name,
            'picture': artistData.picture,
            'email': artistData.email,
            'password': artistData.password,
          }));
      index();
      notifyListeners();
    } catch (e) {}
  }
}
