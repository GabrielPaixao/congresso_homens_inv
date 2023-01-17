import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:webview_flutter/webview_flutter.dart';

class TabControllerTicket extends StatefulWidget {
  const TabControllerTicket({
    Key? key,
  }) : super(key: key);

  @override
  TabControllerTicketState createState() => TabControllerTicketState();
}

class TabControllerTicketState extends State<TabControllerTicket> {
  int data = 0;

  String _idUser = '';
  String _colorUser = '';
  String _tipoUser = '';
  late int corDoTime = int.parse(_colorUser);

  @override
  void initState() {
    super.initState();
    _loadUSerData();
  }

  void _loadUSerData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _idUser = (prefs.getString('user_id') ?? '0');
      _colorUser = (prefs.getString('user_color') ?? '0xff99ff00');
      _tipoUser = (prefs.getString('user_tipo') ?? '0').trim();
    });
  }

  void onDataChange(int newData) {
    setState(() => data = newData);
  }

  @override
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Column(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              color: Colors.transparent,
            ),
            height: 1,
            constraints: BoxConstraints(maxHeight: 60.0, minHeight: 40.0),
            child: Material(
              color: Color(corDoTime),
              child: TabBar(
                isScrollable: false,
                indicatorWeight: 2,
                indicatorColor: Colors.white,
                indicator: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                        width: 3, color: Colors.white), // for right side
                  ),
                ),
                tabs: [
                  Tab(
                    icon: Text(
                      'FUTEBOL',
                      style: const TextStyle(fontSize: 17),
                    ),
                  ),
                  Tab(
                      icon: Text('EVENTOS',
                          style: const TextStyle(fontSize: 17))),
                ],
              ),
            ),
          ),
          Expanded(
            child: TabBarView(
              physics: NeverScrollableScrollPhysics(),
              children: [
                Center(
                  child: Container(
                      child: _tipoUser == '1'
                          ? WebView(
                              initialUrl:
                                  'https://www.gmpx.com.br/cativou/webview/cartoes_usuario_manager.php?id_usuario=$_idUser',
                              javascriptMode: JavascriptMode.disabled,
                              gestureRecognizers: Set()
                                ..add(
                                  Factory<VerticalDragGestureRecognizer>(
                                    () => VerticalDragGestureRecognizer(),
                                  ), // or null
                                ),
                            )
                          : WebView(
                              initialUrl:
                                  'https://www.gmpx.com.br/cativou/webview/cartoes_usuario.php?id_usuario=$_idUser',
                              javascriptMode: JavascriptMode.disabled,
                              gestureRecognizers: Set()
                                ..add(
                                  Factory<VerticalDragGestureRecognizer>(
                                    () => VerticalDragGestureRecognizer(),
                                  ), // or null
                                ),
                            )),
                ),
                Center(
                  child: Container(
                      child: _tipoUser == '1'
                          ? WebView(
                              initialUrl:
                                  'https://www.gmpx.com.br/cativou/webview/cartoes_usuario_manager.php?id_usuario=$_idUser',
                              javascriptMode: JavascriptMode.disabled,
                              gestureRecognizers: Set()
                                ..add(
                                  Factory<VerticalDragGestureRecognizer>(
                                    () => VerticalDragGestureRecognizer(),
                                  ), // or null
                                ),
                            )
                          : WebView(
                              initialUrl:
                                  'https://www.gmpx.com.br/cativou/webview/cartoes_usuario.php?id_usuario=$_idUser',
                              javascriptMode: JavascriptMode.disabled,
                              gestureRecognizers: Set()
                                ..add(
                                  Factory<VerticalDragGestureRecognizer>(
                                    () => VerticalDragGestureRecognizer(),
                                  ), // or null
                                ),
                            )),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
