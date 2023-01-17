import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'dart:async';

class HistoricoPage extends StatefulWidget {
  const HistoricoPage(
      {Key? key, required this.idUserToShow, required this.colorUserToShow})
      : super(key: key);

  final String idUserToShow;
  final String colorUserToShow;

  @override
  _HistoricoPageState createState() => _HistoricoPageState();
}

class _HistoricoPageState extends State<HistoricoPage> {
  @override
  void initState() {
    super.initState();
    _loadUSerData();
    if (Platform.isAndroid) WebView.platform = AndroidWebView();
  }

  String _colorUser = '';

  late int corDoTime = int.parse(_colorUser);

  void _loadUSerData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _colorUser = (prefs.getString('user_color') ?? '0xff99ff00');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage("images/fundoCativou.jpg"),
          fit: BoxFit.fill,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          leading: GestureDetector(
            onTap: () => Navigator.pop(context, true),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
              child: Image.asset(
                'images/tour/leftIco.png',
                color: Color(corDoTime),
              ),
            ),
          ),
          leadingWidth: 40,
        ),
        body: Container(
          child: WebView(
            initialUrl:
                'https://gmpx.com.br/cativou/webview/historico.php?id_usuario=${widget.idUserToShow}',
            javascriptMode: JavascriptMode.unrestricted,
            gestureRecognizers: Set()
              ..add(
                Factory<VerticalDragGestureRecognizer>(
                  () => VerticalDragGestureRecognizer(),
                ), // or null
              ),
          ),
        ),
      ),
    );
  }
}
