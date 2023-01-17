import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

Future<Album> fetchAlbum() async {
  final response = await http.get(
      Uri.parse('https://www.gmpx.com.br/cativou/api/public/jogos_by_id/1'));

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    print(response.body);
    return Album.fromJson(jsonDecode(response.body));
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.

    throw Exception('Failed to load album');
  }
}

class Album {
  final String campeonato;
  final String rodada;
  final String timeCasa;
  final String timeVisitante;
  final String data;
  final String hora;
  final String escudo_casa;
  final String escudo_visitante;

  Album({
    required this.rodada,
    required this.campeonato,
    required this.timeCasa,
    required this.timeVisitante,
    required this.data,
    required this.hora,
    required this.escudo_casa,
    required this.escudo_visitante,
  });

  factory Album.fromJson(Map<String, dynamic> json) {
    return Album(
        campeonato: json['campeonato'],
        rodada: json['rodada'],
        timeCasa: json['time_casa'] ?? "sem time",
        timeVisitante: json['time_visitante'] ?? "sem time",
        data: json['data'] ?? "sem data",
        hora: json['hora'] ?? "sem hora",
        escudo_casa: json['escudo_casa'] ?? "sem hora",
        escudo_visitante: json['escudo_visitante'] ?? "sem hora");
  }
}

class CardPage extends StatefulWidget {
  const CardPage({Key? key}) : super(key: key);

  @override
  _CardPageState createState() => _CardPageState();
}

class _CardPageState extends State<CardPage> {
  late Future<Album> futureAlbum;

  @override
  void initState() {
    super.initState();
    futureAlbum = fetchAlbum();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Center(
        child: FutureBuilder<Album>(
          future: futureAlbum,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Center(
                child: Card(
                  elevation: 0,
                  color: Colors.transparent,
                  child: Column(children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          snapshot.data!.timeCasa,
                          style: const TextStyle(
                              fontSize: 15, color: Colors.white),
                        ),
                        Center(
                            child: Image.network(
                                'https://www.gmpx.com.br/cativou-adm/admin/dist/img/ico_time_DEFAULT.png')),
                        Text(
                          'X',
                          style: const TextStyle(
                              fontSize: 50, color: Colors.white),
                        ),
                        Center(
                            child: Image.network(
                                'https://www.gmpx.com.br/cativou-adm/admin/dist/img/ico_time_DEFAULT.png')),
                        Text(
                          snapshot.data!.timeVisitante,
                          style: const TextStyle(
                              fontSize: 15, color: Colors.white),
                        ),
                      ],
                    ),
                    Text(
                      snapshot.data!.campeonato,
                      style: const TextStyle(
                          fontSize: 15, color: Colors.lightGreen),
                    ),
                    Text(
                      '${snapshot.data!.rodada} | ${snapshot.data!.data} | SETEMBRO | ${snapshot.data!.hora}',
                      style: const TextStyle(fontSize: 13, color: Colors.white),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: Color(0xff99ff00),
                        onPrimary: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                      ),
                      onPressed: () {
                        /* if (pageController.hasClients) {
                              pageController.animateToPage(
                                1,
                                duration: const Duration(milliseconds: 400),
                                curve: Curves.easeInOut,
                              );
                            } */
                      },
                      child: Text("Alugar cadeira".toUpperCase(),
                          style: const TextStyle(fontSize: 15)),
                    ),
                  ]),
                ),
              );
            } else if (snapshot.hasError) {
              return Text('${snapshot.error}');
            }

            // By default, show a loading spinner.
            return const CircularProgressIndicator();
          },
        ),
      ),
    );
  }
}
