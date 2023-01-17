//import 'package:cativou/login/shared/choiceStadium.dart';
import 'package:cativou/login/shared/inital_page.dart';
import 'package:cativou/principal/principal_page.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class VerificarScreen extends StatefulWidget {
  const VerificarScreen({Key? key}) : super(key: key);

  @override
  State<VerificarScreen> createState() => VerificarScreenState();
}

class VerificarScreenState extends State<VerificarScreen> {
  @override
  void initState() {
    if (mounted) {
      super.initState();
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => MyHomePage()));
      /*VerificarToken().then((value) {
          if (value) {
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (context) => ChoicePage()));
          } else {
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (context) => MyHomePage()));
          }
        });*/
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('images/fundoCativou.jpg'),
            ),
          ),
          child: Image.asset('images/cativouInitialLogo.png'),
        ),
      ),
    );
  }

  Future<bool> VerificarToken() async {
    SharedPreferences sharedPreference = await SharedPreferences.getInstance();
    if (sharedPreference.getString('token_jwt') != null) {
      return true;
    } else {
      return false;
    }
  }
}
