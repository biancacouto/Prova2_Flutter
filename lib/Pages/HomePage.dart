import 'package:flutter/material.dart';
import 'package:music_ap/Pages/MusicPage.dart';
import 'package:music_ap/controllers/ArtistController.dart';
import 'package:music_ap/controllers/MusicController.dart';
import 'package:music_ap/models/Artist.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();

  String artistPic = '';
  String artistEmail = '';
  String artistPassword = '';
  String artistName = '';

  @override
  Widget build(BuildContext context) {
    return Consumer2<ArtistsController, MusicController>(
      builder: (_, artistsController, musicController, __) {
        return Scaffold(
          backgroundColor: Color(0xFFEEEEEE),
          appBar:
              AppBar(title: Text('Artistas'), elevation: 0, centerTitle: true),
          body: Container(
            padding: EdgeInsets.all(24),
            child: ListView.builder(
              itemCount: artistsController.artists.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    musicController.index(artistsController.artists[index].id!);
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => MusicPage(
                          currentArtist: artistsController.artists[index]),
                    ));
                  },
                  child: Card(
                    elevation: 3,
                    color: Colors.white,
                    clipBehavior: Clip.antiAlias,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5)),
                    child: Container(
                      height: 320,
                      child: Column(children: [
                        Image.network(
                          artistsController.artists[index].picture,
                          fit: BoxFit.cover,
                          width: 400,
                          height: 200,
                        ),
                        const SizedBox(height: 15),
                        Expanded(
                            child: Text(
                          artistsController.artists[index].name,
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w600,
                              fontSize: 20,
                              letterSpacing: 1),
                        )),
                        Expanded(
                            child: Text(
                          artistsController.artists[index].email,
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w400,
                              fontSize: 20,
                              letterSpacing: 1),
                        )),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              TextButton(
                                child: const Text('Editar',
                                    style: TextStyle(color: Colors.white)),
                                style: TextButton.styleFrom(
                                  backgroundColor: Colors.blue,
                                ),
                                onPressed: () {
                                  showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          actions: [
                                            Form(
                                              key: _formKey,
                                              child: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    Text(
                                                      "Editar Artista",
                                                      style: TextStyle(
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                    Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8),
                                                        child: TextFormField(
                                                          decoration:
                                                              InputDecoration(
                                                                  labelText:
                                                                      'Nome'),
                                                          onSaved: (value) {
                                                            artistName = value!;
                                                          },
                                                        )),
                                                    Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8),
                                                        child: TextFormField(
                                                          decoration:
                                                              InputDecoration(
                                                                  labelText:
                                                                      'Foto de Perfil'),
                                                          onSaved: (value) {
                                                            artistPic = value!;
                                                          },
                                                        )),
                                                    Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8),
                                                        child: TextFormField(
                                                          decoration:
                                                              InputDecoration(
                                                                  labelText:
                                                                      'Email'),
                                                          onSaved: (value) {
                                                            artistEmail =
                                                                value!;
                                                          },
                                                        )),
                                                    Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8),
                                                        child: TextFormField(
                                                          decoration:
                                                              InputDecoration(
                                                                  labelText:
                                                                      'Senha'),
                                                          onSaved: (value) {
                                                            artistPassword =
                                                                value!;
                                                          },
                                                        )),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8),
                                                      child: ElevatedButton(
                                                        onPressed: () async {
                                                          _formKey.currentState!
                                                              .save();

                                                          Artist artistCurrent =
                                                              new Artist(
                                                            name: artistName,
                                                            picture: artistPic,
                                                            email: artistEmail,
                                                            password:
                                                                artistPassword,
                                                          );
                                                          await artistsController
                                                              .edit(
                                                                  artistsController
                                                                      .artists[
                                                                          index]
                                                                      .id!,
                                                                  artistCurrent);
                                                          ScaffoldMessenger.of(
                                                                  context)
                                                              .showSnackBar(
                                                            SnackBar(
                                                              content: Text(
                                                                  'Salvo com Sucesso!'),
                                                            ),
                                                          );
                                                          Navigator.pop(
                                                              context);
                                                        },
                                                        child: Text(
                                                            'Editar Artista'),
                                                      ),
                                                    )
                                                  ]),
                                            )
                                          ],
                                        );
                                      });
                                },
                              ),
                              const SizedBox(width: 10),
                              TextButton(
                                child: const Text('Deletar',
                                    style: TextStyle(color: Colors.white)),
                                style: TextButton.styleFrom(
                                  backgroundColor: Colors.red,
                                ),
                                onPressed: () async {
                                  await artistsController.delete(
                                      artistsController.artists[index].id!);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          content: Text('Artista Deletado!')));
                                },
                              ),
                            ]),
                      ]),
                    ),
                  ),
                );
              },
            ),
          ),
          floatingActionButton: FloatingActionButton(
            child: Icon(Icons.add),
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      actions: [
                        Form(
                          key: _formKey,
                          child:
                              Column(mainAxisSize: MainAxisSize.min, children: [
                            Text(
                              "Cadastrar Artista",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Padding(
                                padding: const EdgeInsets.all(8),
                                child: TextFormField(
                                  decoration:
                                      InputDecoration(labelText: 'Nome'),
                                  onSaved: (value) {
                                    artistName = value!;
                                  },
                                )),
                            Padding(
                                padding: const EdgeInsets.all(8),
                                child: TextFormField(
                                  decoration: InputDecoration(
                                      labelText: 'Foto de Perfil'),
                                  onSaved: (value) {
                                    artistPic = value!;
                                  },
                                )),
                            Padding(
                                padding: const EdgeInsets.all(8),
                                child: TextFormField(
                                  decoration:
                                      InputDecoration(labelText: 'Email'),
                                  onSaved: (value) {
                                    artistEmail = value!;
                                  },
                                )),
                            Padding(
                                padding: const EdgeInsets.all(8),
                                child: TextFormField(
                                  decoration:
                                      InputDecoration(labelText: 'Senha'),
                                  onSaved: (value) {
                                    artistPassword = value!;
                                  },
                                )),
                            Padding(
                              padding: const EdgeInsets.all(8),
                              child: ElevatedButton(
                                onPressed: () async {
                                  _formKey.currentState!.save();

                                  Artist artistCurrent = new Artist(
                                    name: artistName,
                                    picture: artistPic,
                                    email: artistEmail,
                                    password: artistPassword,
                                  );
                                  await artistsController.create(artistCurrent);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('Salvo com Sucesso!'),
                                    ),
                                  );
                                  Navigator.pop(context);
                                },
                                child: Text('Cadastrar Artista'),
                              ),
                            )
                          ]),
                        )
                      ],
                    );
                  });
            },
          ),
        );
      },
    );
  }
}
