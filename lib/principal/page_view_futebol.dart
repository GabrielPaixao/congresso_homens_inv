import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'dart:async';
import 'package:webview_flutter/webview_flutter.dart';

class PageViewFutebol extends StatefulWidget {
  const PageViewFutebol({
    Key? key,
  }) : super(key: key);

  @override
  _PageViewFutebolState createState() => _PageViewFutebolState();
}

class Jogo {
  final String campeonato;
  final String rodada;
  final String data;
  final String hora;
  final String timeCasa;
  final String escudoCasa;
  final String timeVisitante;
  final String escudoVisitante;

  Jogo(
      {required this.data,
      required this.hora,
      required this.timeVisitante,
      required this.escudoVisitante,
      required this.rodada,
      required this.campeonato,
      required this.timeCasa,
      required this.escudoCasa});

  factory Jogo.fromJson(Map<String, dynamic> json) {
    return Jogo(
      campeonato: json['campeonato'],
      rodada: json['rodada'],
      timeCasa: json['time_casa'],
      escudoCasa: json['escudo_casa'],
      timeVisitante: json['time_visitante'],
      escudoVisitante: json['escudo_visitante'],
      data: json['data'],
      hora: json['hora'],
    );
  }
}

class _PageViewFutebolState extends State<PageViewFutebol> {
  final PageController pageController = PageController();

  List? data;

//método para listar todos os jogos de um estádio
  Future<String> getData() async {
    var response = await http.get(
        Uri.parse("https://gmpx.com.br/cativou/api/public/jogos/1"),
        headers: {"Accept": "application/json"});

    this.setState(() {
      data = json.decode(response.body);
      /* print(response.body); */
    });

    return "Success!";
  }

  //método para acessar apenas um jogo pelo id_jogo

  Future<Jogo> getDataJogo() async {
    var responseJogo = await http.get(
        Uri.parse(
            "https://gmpx.com.br/cativou/api/public/jogos_by_id/$selectdJogo"),
        headers: {"Accept": "application/json"});
    print(responseJogo.body);
    return Jogo.fromJson(jsonDecode(responseJogo.body));
  }

  @override
  void initState() {
    super.initState();
    this.getData();
    if (Platform.isAndroid) WebView.platform = AndroidWebView();
    _loadUSerData();
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  String? selectdJogo;
  String _idUser = '';
  String _colorUser = '';
  String _tipoUser = '';
  late int corDoTime = int.parse(_colorUser);

  void _loadUSerData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _idUser = (prefs.getString('user_id') ?? '0');
      _colorUser = (prefs.getString('user_color') ?? '0xff99ff00');
      _tipoUser = (prefs.getString('user_tipo') ?? '0').trim();
    });
  }

  String? tipoUserSelected = '';

  @override
  Widget build(BuildContext context) {
    return PageView(
        controller: pageController,
        physics: new NeverScrollableScrollPhysics(),
        children: [
          Center(
            child: ListView.builder(
              itemCount: data == null ? 0 : data?.length,
              itemBuilder: (BuildContext context, int index) {
                return new Card(
                  elevation: 0,
                  color: Colors.transparent,
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    data?[index]["time_casa"],
                                    style: const TextStyle(
                                        fontSize: 15, color: Colors.white),
                                  ),
                                  Image.network(
                                    'https://www.gmpx.com.br/cativou-adm/admin/files/${data?[index]["escudo_casa"]}',
                                    width: 50,
                                  ),
                                ],
                              ),
                            ),
                            Center(
                              child: Text(
                                'X',
                                style: const TextStyle(
                                    fontSize: 35, color: Colors.white),
                              ),
                            ),
                            Expanded(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Image.network(
                                    'https://www.gmpx.com.br/cativou-adm/admin/files/${data?[index]["escudo_visitante"]}',
                                    width: 50,
                                  ),
                                  Text(
                                    data?[index]["time_visitante"],
                                    style: const TextStyle(
                                        fontSize: 15, color: Colors.white),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        Text(
                          data?[index]["campeonato"],
                          style:
                              TextStyle(fontSize: 15, color: Color(corDoTime)),
                        ),
                        Text(
                          '${data?[index]["rodada"]}ª RODADA | ${data?[index]["data"]} | ${data?[index]["hora"]}',
                          style: const TextStyle(
                              fontSize: 13, color: Colors.white),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(30, 0, 30, 0),
                          child: Column(
                            children: [
                              if (_tipoUser == '2')
                                Center(
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      primary: Color(corDoTime),
                                      onPrimary: Colors.black,
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(30.0),
                                      ),
                                    ),
                                    onPressed: () {
                                      if (pageController.hasClients) {
                                        setState(() {
                                          selectdJogo = data![index]["id_jogo"];
                                        });
                                        pageController.animateToPage(
                                          3,
                                          duration:
                                              const Duration(milliseconds: 400),
                                          curve: Curves.easeInOut,
                                        );
                                      } else {}
                                    },
                                    child: Text("Alugar cadeira".toUpperCase(),
                                        style: const TextStyle(
                                            fontSize: 15, color: Colors.white)),
                                  ),
                                )
                              else
                                Center(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Center(
                                        child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            primary: Colors.white,
                                            onPrimary: Colors.black,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(30.0),
                                            ),
                                          ),
                                          onPressed: () {
                                            if (pageController.hasClients) {
                                              setState(() {
                                                selectdJogo =
                                                    data![index]["id_jogo"];
                                                tipoUserSelected = '2';
                                              });
                                              pageController.animateToPage(
                                                1,
                                                duration: const Duration(
                                                    milliseconds: 400),
                                                curve: Curves.easeInOut,
                                              );
                                            } else {}
                                          },
                                          child: Text("Reservar".toUpperCase(),
                                              style: const TextStyle(
                                                  fontSize: 15,
                                                  color: Colors.black)),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Center(
                                        child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            primary: Color(corDoTime),
                                            onPrimary: Colors.black,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(30.0),
                                            ),
                                          ),
                                          onPressed: () {
                                            if (pageController.hasClients) {
                                              setState(() {
                                                selectdJogo =
                                                    data![index]["id_jogo"];
                                                tipoUserSelected = '1';
                                              });
                                              pageController.animateToPage(
                                                1,
                                                duration: const Duration(
                                                    milliseconds: 400),
                                                curve: Curves.easeInOut,
                                              );
                                            } else {}
                                          },
                                          child: Text(
                                              "Disponibilizar".toUpperCase(),
                                              style: const TextStyle(
                                                  fontSize: 15,
                                                  color: Colors.white)),
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(2.0),
                          child: linhaDivisao,
                        ),
                      ]),
                );
              },
            ),
          ),
          if (_tipoUser == '1')
            Container(
              child: WebView(
                initialUrl:
                    'https://www.gmpx.com.br/cativou/webview/setores_usuario.php?id_usuario=$_idUser&id_jogo=$selectdJogo&tipo_select=$tipoUserSelected',
                javascriptMode: JavascriptMode.unrestricted,
                gestureRecognizers: Set()
                  ..add(
                    Factory<HorizontalDragGestureRecognizer>(
                      () => HorizontalDragGestureRecognizer(),
                    ), // or null
                  ),
              ),
            )
          else
            Container(
              child: WebView(
                initialUrl:
                    'https://www.gmpx.com.br/cativou/webview/setores.php?id_usuario=$_idUser&id_jogo=$selectdJogo',
                javascriptMode: JavascriptMode.unrestricted,
                gestureRecognizers: Set()
                  ..add(
                    Factory<HorizontalDragGestureRecognizer>(
                      () => HorizontalDragGestureRecognizer(),
                    ), // or null
                  ),
              ),
            ),
        ]);
  }
}

final linhaDivisao = Divider(
  color: Colors.white,
  height: 20,
  thickness: 5,
  indent: 150,
  endIndent: 150,
);
