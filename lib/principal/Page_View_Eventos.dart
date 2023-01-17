import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'dart:async';
import 'package:webview_flutter/webview_flutter.dart';

class PageViewEventos extends StatefulWidget {
  const PageViewEventos({Key? key}) : super(key: key);

  @override
  _PageViewEventosState createState() => _PageViewEventosState();
}

class _PageViewEventosState extends State<PageViewEventos> {
  @override
  final PageController pageController = PageController();

  List? dataEventos;

//método para listar todos os jogos de um estádio
  Future<String> getDataEventos() async {
    var responseEventos = await http.get(
        Uri.parse("https://gmpx.com.br/cativou/api/public/eventos"),
        headers: {"Accept": "application/json"});

    this.setState(() {
      dataEventos = json.decode(responseEventos.body);
    });

    print(responseEventos.body);

    return "Success!";
  }

  @override
  void initState() {
    this.getDataEventos();
    _loadUSerData();
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  String? selectedEvento;
  String _idUser = '';
  String _colorUser = '';
  String _tipoUser = '';
  late int corDoTime = int.parse(_colorUser);

  void _loadUSerData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _idUser = (prefs.getString('user_id') ?? 'default');
      _colorUser = (prefs.getString('user_color') ?? '0xff99ff00');
      _tipoUser = (prefs.getString('user_tipo') ?? '0').trim();
      print(_colorUser);
      print(_idUser);
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
            child: Text(
              'Lançamento em breve',
              style: TextStyle(color: Colors.white, fontSize: 25),
            ),
          )
          /* Center(
            child: ListView.builder(
                itemCount: dataEventos == null ? 0 : dataEventos?.length,
                itemBuilder: (BuildContext context, int index) {
                  return Card(
                    elevation: 0,
                    color: Colors.transparent,
                    child: Column(children: [
                      SizedBox(
                        height: 5,
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(30, 10, 30, 0),
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Color(corDoTime),
                              style: BorderStyle.solid,
                              width: 2.0,
                            ),
                            color: Colors.transparent,
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(30),
                            child: Center(
                              child: Image.network(
                                'https://www.gmpx.com.br/cativou-adm/admin/files/${dataEventos?[index]["imagem"]}',
                                fit: BoxFit.fill,
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        dataEventos?[index]["artista"],
                        style: TextStyle(fontSize: 20, color: Color(corDoTime)),
                      ),
                      Text(
                        ' ${dataEventos?[index]["data"]} | ${dataEventos?[index]["hora"]}',
                        style:
                            const TextStyle(fontSize: 15, color: Colors.white),
                      ),
                      if (_tipoUser == '2')
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: Color(corDoTime),
                            onPrimary: Colors.black,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0),
                            ),
                          ),
                          onPressed: () {
                            if (pageController.hasClients) {
                              setState(() {
                                selectedEvento = dataEventos![index]["id"];
                              });
                              pageController.animateToPage(
                                1,
                                duration: const Duration(milliseconds: 400),
                                curve: Curves.easeInOut,
                              );
                            }
                          },
                          child: Text("Alugar cadeira".toUpperCase(),
                              style: const TextStyle(
                                  fontSize: 15, color: Colors.white)),
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
                                      borderRadius: BorderRadius.circular(30.0),
                                    ),
                                  ),
                                  onPressed: () {
                                    if (pageController.hasClients) {
                                      setState(() {
                                        selectedEvento =
                                            dataEventos![index]["id"];
                                        tipoUserSelected = '2';
                                      });
                                      pageController.animateToPage(
                                        1,
                                        duration:
                                            const Duration(milliseconds: 400),
                                        curve: Curves.easeInOut,
                                      );
                                    } else {}
                                  },
                                  child: Text("Reservar".toUpperCase(),
                                      style: const TextStyle(
                                          fontSize: 15, color: Colors.black)),
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
                                      borderRadius: BorderRadius.circular(30.0),
                                    ),
                                  ),
                                  onPressed: () {
                                    if (pageController.hasClients) {
                                      setState(() {
                                        selectedEvento =
                                            dataEventos![index]["id"];
                                        tipoUserSelected = '1';
                                      });
                                      pageController.animateToPage(
                                        1,
                                        duration:
                                            const Duration(milliseconds: 400),
                                        curve: Curves.easeInOut,
                                      );
                                    } else {}
                                  },
                                  child: Text("Disponibilizar".toUpperCase(),
                                      style: const TextStyle(
                                          fontSize: 15, color: Colors.white)),
                                ),
                              ),
                            ],
                          ),
                        ),
                      const SizedBox(height: 10),
                    ]),
                  );
                }),
          ),
          if (_tipoUser == '2')
            Center(
              child: WebView(
                initialUrl:
                    'https://www.gmpx.com.br/cativou/webview/setores_evento.php?id_usuario=$_idUser&id_evento=$selectedEvento',
                javascriptMode: JavascriptMode.unrestricted,
                gestureRecognizers: Set()
                  ..add(
                    Factory<VerticalDragGestureRecognizer>(
                      () => VerticalDragGestureRecognizer(),
                    ), // or null
                  ),
              ),
            )
          else
            Center(
              child: WebView(
                initialUrl:
                    'https://www.gmpx.com.br/cativou/webview/setores_evento_usuario.php?id_usuario=$_idUser&id_evento=$selectedEvento&tipo_select=$tipoUserSelected',
                javascriptMode: JavascriptMode.unrestricted,
                gestureRecognizers: Set()
                  ..add(
                    Factory<VerticalDragGestureRecognizer>(
                      () => VerticalDragGestureRecognizer(),
                    ), // or null
                  ),
              ),
            ), */
        ]);
  }
}

final linhaDivisao = Divider(
  color: Colors.white,
  height: 20,
  thickness: 3,
  indent: 150,
  endIndent: 150,
);
