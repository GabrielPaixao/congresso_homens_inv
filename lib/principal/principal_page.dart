import 'package:cativou/principal/app_tabcontroller.dart';
import 'package:cativou/principal/historico_page.dart';
import 'package:cativou/principal/topNavBar.dart';
//import 'package:cativou/tabController/appTabControllerPerfil.dart';
//import 'package:cativou/tabController/appTabControllerStadio.dart';
//import 'package:cativou/tabController/appTabControllerTickets.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PrincipalPage extends StatefulWidget {
  PrincipalPage({
    Key? key,
  }) : super(key: key);

  final screens = [];

  @override
  State<PrincipalPage> createState() => _PrincipalPageWidget();
}

class _PrincipalPageWidget extends State<PrincipalPage> {
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _loadUSerData();
  }

  String _tipoUser = '';
  String _colorUser = '';
  String _idUser = '';
  late int corDoTime = int.parse(_colorUser);

  void _loadUSerData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _idUser = (prefs.getString('user_id') ?? '0');
      _colorUser = (prefs.getString('user_color') ?? '0xff99ff00');
      _tipoUser = (prefs.getString('user_tipo') ?? '0').trim();
    });
  }

  /*final screens = [
    Center(
      child: TabControllerOne(),
    ),
    Center(
      child: Center(
        child: TabControllerTicket(),
      ),
    ),
    Center(
      child: Center(
        child: TabControllerStadio(),
      ),
    ),
    Center(
      child: Center(
        child: TabControllerPerfil(),
      ),
    ),
  ];*/

  @override
  Widget build(BuildContext context) {
    return Material(
        color: Colors.transparent,
        child: Center(
            child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("images/fundoCativou.jpg"),
              fit: BoxFit.fill,
            ),
          ),
          child: Scaffold(
            backgroundColor: Colors.transparent,
            appBar: AppBar(
              leading: GestureDetector(
                onTap: () => Navigator.push(context,
                    MaterialPageRoute(builder: (context) => PrincipalPage())),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
                  child: Image.asset(
                    'images/backIco.png',
                    color: Color(corDoTime),
                    width: 100,
                    height: 100,
                  ),
                ),
              ),
              leadingWidth: 70,
              automaticallyImplyLeading: false,
              actions: [
                if (corDoTime != null)
                  Center(
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                      child: Image.asset(
                        "images/cativouLogoWhite.png",
                        fit: BoxFit.cover,
                        width: 150,
                      ),
                    ),
                  )
                else
                  Center(
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                      child: Image.asset(
                        "images/cativouLogo.png",
                        fit: BoxFit.cover,
                        width: 150,
                      ),
                    ),
                  ),
                if (_tipoUser == '1')
                  new GestureDetector(
                    child: IconButton(
                      icon: new Image.asset(
                        'images/historicoFinanIco.png',
                        color: Color(corDoTime),
                        width: 30,
                        fit: BoxFit.cover,
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => HistoricoPage(
                                    idUserToShow: _idUser,
                                    colorUserToShow: _colorUser,
                                  )),
                        );
                      },
                    ),
                  )
                else
                  Center(
                      child: Padding(
                    padding: EdgeInsets.fromLTRB(10, 10, 35, 10),
                  )),
                const SizedBox(
                  width: 5,
                ),
                new GestureDetector(
                  child: IconButton(
                    icon: new Image.asset(
                      'images/homeIco.png',
                      color: Color(corDoTime),
                      width: 30,
                      fit: BoxFit.cover,
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => PrincipalPage()),
                      );
                    },
                  ),
                ),
                const SizedBox(
                  width: 5,
                )
              ],
              backgroundColor: Colors.transparent,
            ),
            body: IndexedStack(
              index: _selectedIndex,
              // children: screens,
            ),
            bottomNavigationBar: Container(
                height: 60,
                width: 30,
                child: ClipRRect(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(15.0),
                    topRight: Radius.circular(15.0),
                  ),
                  child: BottomNavigationBar(
                    type: BottomNavigationBarType.fixed,
                    backgroundColor: Color(0xffcccccc),
                    selectedItemColor: Colors.lightGreen,
                    unselectedItemColor: Colors.black,
                    showSelectedLabels: false,
                    showUnselectedLabels: false,
                    selectedFontSize: 0,
                    unselectedFontSize: 0,

                    currentIndex: _selectedIndex, //New
                    onTap: (index) => setState(() => _selectedIndex = index),
                    items: [
                      BottomNavigationBarItem(
                        //title: Text(''),
                        icon: _selectedIndex == 0
                            ? Image.asset(
                                "images/bottomNav/icoCalendarAlt.png",
                                width: 30,
                              )
                            : Image.asset(
                                "images/bottomNav/icoCalendar.png",
                                width: 30,
                              ),
                      ),
                      BottomNavigationBarItem(
                        //title: Text(''),
                        icon: _selectedIndex == 1
                            ? Image.asset(
                                "images/bottomNav/icoTicketAlt.png",
                                width: 35,
                              )
                            : Image.asset(
                                "images/bottomNav/icoTicket.png",
                                width: 35,
                              ),
                      ),
                      BottomNavigationBarItem(
                        //title: Text(''),
                        icon: _tipoUser == '2'
                            ? _selectedIndex == 2
                                ? Image.asset(
                                    "images/bottomNav/icoEstadioAlt.png",
                                    width: 35,
                                  )
                                : Image.asset(
                                    "images/bottomNav/icoEstadio.png",
                                    width: 35,
                                  )
                            : _selectedIndex == 2
                                ? Image.asset(
                                    "images/bottomNav/icoCadeiraAlt.png",
                                    width: 30,
                                  )
                                : Image.asset(
                                    "images/bottomNav/icoCadeira.png",
                                    width: 30,
                                  ),
                      ),
                      BottomNavigationBarItem(
                        // title: Text(''),
                        icon: _selectedIndex == 3
                            ? Image.asset(
                                "images/bottomNav/icoPerfilAlt.png",
                                width: 35,
                              )
                            : Image.asset(
                                "images/bottomNav/icoPerfil.png",
                                width: 30,
                              ),
                      ),
                    ],
                  ),
                )),
          ),
          // This trailing comma makes auto-formatting nicer for build methods.
        )));
  }
}
