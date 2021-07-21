import 'Music.dart';

class Artist {
  final String? id;
  final String name;
  final String picture;
  final String email;
  final String password;
  final List<Music>? musics;

  const Artist({
    this.id,
    required this.name,
    required this.picture,
    required this.email,
    required this.password,
    this.musics,
  });
}
