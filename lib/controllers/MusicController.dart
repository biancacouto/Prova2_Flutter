import 'package:flutter/cupertino.dart';
import 'package:music_ap/models/Music.dart';
import '../util/env.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class MusicController extends ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  List<Music> musics = [];

  Future<void> index(String id) async {
    isLoading = true;
    musics.clear();

   try {
      var url = Uri.https(Env.FIREBASE_URL, '/artists/$id/musics.json');

      var resp = await http.get(url);

      Map<String, dynamic> data =
          new Map<String, dynamic>.from(json.decode(resp.body));

      print(data);

      data.forEach((key, value) {
        musics.add(Music(
          id: key,
          name: value['name'],
          duration: value['duration'],
          style: value['style']
        ));

        print(musics[0].name);
        print(musics[0].id);
        print(musics[0].duration);
        print(musics[0].style);
      });


      isLoading = false;
    } catch (error) {
      throw error;
    }
  }

  Future<void> create(Music musicData, String id) async {
    var url = Uri.https(Env.FIREBASE_URL, '/artists/$id/musics.json');

    await http.post(url, body: jsonEncode({
      'name': musicData.name,
      'duration': musicData.duration,
      'style': musicData.style
      }));

    index(id);
    notifyListeners();
  }

  Future<void> edit(String musicId, String artistId, Music musicData) async {
    var url = Uri.https(Env.FIREBASE_URL, '/artists/$artistId/musics/$musicId.json');

    print(' =>  passou');

    try {
      await http.put(url, body: jsonEncode({
      'name': musicData.name,
      'duration': musicData.duration,
      'style': musicData.style
      }));

      index(artistId);
      notifyListeners();
    }catch(e) {
    }
  }

  Future<void> delete(String artistId, String musicId) async {
  var url = Uri.https(Env.FIREBASE_URL, '/artists/$artistId/musics/$musicId.json');

    try{
      await http.delete(url);
      index(artistId);
      notifyListeners();
    } catch(e) {
    }
  }
}