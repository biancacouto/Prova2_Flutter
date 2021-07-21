import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:music_ap/controllers/MusicController.dart';
import 'package:music_ap/models/Artist.dart';
import 'package:music_ap/models/Music.dart';
import 'package:provider/provider.dart';

class MusicPage extends StatefulWidget {
  final Artist currentArtist;
  MusicPage({required this.currentArtist});

  @override
  _MusicPageState createState() => _MusicPageState();
}

class _MusicPageState extends State<MusicPage> {
  final _formKey = GlobalKey<FormState>();

  String musicName = '';
  String musicDuration = '';
  String musicStyle = '';
  List<Music> currentList = [];

  @override
  Widget build(BuildContext context) {
    return Consumer<MusicController>(builder: (_, musicController, __) {
      return Scaffold(
        backgroundColor: Color(0xFFEEEEEE),
        appBar: AppBar(
          title: Text(widget.currentArtist.name),
          elevation: 0,
        ),
        body: Container(
          padding: EdgeInsets.all(16),
          child: ListView.builder(
            itemCount: musicController.musics.length,
            itemBuilder: (context, index) {
              return Card(
                  elevation: 3,
                  color: Colors.white,
                  clipBehavior: Clip.antiAlias,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Container(
                      height: 80,
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const SizedBox(width: 16),
                                Text(
                                  musicController.musics[index].name,
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 22,
                                  ),
                                ),
                                Spacer(),
                                Text(
                                  musicController.musics[index].duration,
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.normal,
                                    fontSize: 22,
                                  ),
                                ),
                                Spacer(),
                                Text(
                                  musicController.musics[index].style,
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.normal,
                                    fontSize: 22,
                                  ),
                                ),
                                const SizedBox(width: 16),
                              ],
                            ),
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
                                                          "Editar Musica",
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
                                                            child:
                                                                TextFormField(
                                                              decoration:
                                                                  InputDecoration(
                                                                      labelText:
                                                                          'Nome da Música'),
                                                              onSaved: (value) {
                                                                musicName =
                                                                    value!;
                                                              },
                                                            )),
                                                        Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(8),
                                                            child:
                                                                TextFormField(
                                                              decoration:
                                                                  InputDecoration(
                                                                      labelText:
                                                                          'Duração da Música'),
                                                              onSaved: (value) {
                                                                musicDuration =
                                                                    value!;
                                                              },
                                                            )),
                                                        Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(8),
                                                            child:
                                                                TextFormField(
                                                              decoration:
                                                                  InputDecoration(
                                                                      labelText:
                                                                          'Estilo da Música'),
                                                              onSaved: (value) {
                                                                musicStyle =
                                                                    value!;
                                                              },
                                                            )),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(8),
                                                          child: ElevatedButton(
                                                            onPressed:
                                                                () async {
                                                              _formKey
                                                                  .currentState!
                                                                  .save();

                                                              Music musicCurrent = new Music(
                                                                  name:
                                                                      musicName,
                                                                  duration:
                                                                      musicDuration,
                                                                  style:
                                                                      musicStyle);
                                                              await musicController
                                                                  .edit(
                                                                musicController
                                                                    .musics[
                                                                        index]
                                                                    .id!,
                                                                widget
                                                                    .currentArtist
                                                                    .id!,
                                                                musicCurrent,
                                                              );
                                                              ScaffoldMessenger
                                                                      .of(context)
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
                                                                'Editar Música'),
                                                          ),
                                                        )
                                                      ]),
                                                ),
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
                                      await musicController.delete(
                                          widget.currentArtist.id!,
                                          musicController.musics[index].id!);
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(
                                              content:
                                                  Text('Artista Deletado!')));
                                    },
                                  )
                                ])
                          ])));
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
                            "Cadastrar Música",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Padding(
                              padding: const EdgeInsets.all(8),
                              child: TextFormField(
                                decoration: InputDecoration(
                                    labelText: 'Nome da Música'),
                                onSaved: (value) {
                                  musicName = value!;
                                },
                              )),
                          Padding(
                              padding: const EdgeInsets.all(8),
                              child: TextFormField(
                                decoration: InputDecoration(
                                    labelText: 'Duração da Música'),
                                onSaved: (value) {
                                  musicDuration = value!;
                                },
                              )),
                          Padding(
                              padding: const EdgeInsets.all(8),
                              child: TextFormField(
                                decoration: InputDecoration(
                                    labelText: 'Estilo da Música'),
                                onSaved: (value) {
                                  musicStyle = value!;
                                },
                              )),
                          Padding(
                            padding: const EdgeInsets.all(8),
                            child: ElevatedButton(
                              onPressed: () async {
                                _formKey.currentState!.save();

                                Music musicCurrent = new Music(
                                    name: musicName,
                                    duration: musicDuration,
                                    style: musicStyle);
                                await musicController.create(
                                    musicCurrent, widget.currentArtist.id!);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Salvo com Sucesso!'),
                                  ),
                                );
                                Navigator.pop(context);
                              },
                              child: Text('Cadastrar Música'),
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
    });
  }
}
