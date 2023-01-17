import 'package:cativou/principal/Page_View_Eventos.dart';
import 'package:cativou/principal/page_view_futebol.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TabControllerOne extends StatefulWidget {
  const TabControllerOne({
    Key? key,
  }) : super(key: key);

  @override
  TabControllerOneState createState() => TabControllerOneState();
}

class TabControllerOneState extends State<TabControllerOne> {
  int data = 0;

  String _colorUser = '';
  late int corDoTime = int.parse(_colorUser);

  @override
  void initState() {
    super.initState();
    _loadUSerData();
  }

  void _loadUSerData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _colorUser = (prefs.getString('user_color') ?? '0xff99ff00');
      print(_colorUser);
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
                        width: 4, color: Colors.white), // for right side
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
                PageViewFutebol(),
                PageViewEventos(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
