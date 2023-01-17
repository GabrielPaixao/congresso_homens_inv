//import 'package:cativou/signUp/alugarSignUp/step_one.dart';
//import 'package:cativou/signUp/gerenciarSignUp/step_oneGerenciar.dart';
import 'package:cativou/splash.dart';
import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CONGRESSO DOS HOMENS',
      debugShowCheckedModeBanner: false,
      home: VerificarScreen(),
    );
  }
}
