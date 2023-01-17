import 'dart:convert';
//import 'package:cativou/login/shared/choiceStadium.dart';
import 'package:cativou/login/shared/inital_page.dart';
//import 'package:cativou/login/shared/passRecovery.dart';
import 'package:cativou/principal/principal_page.dart';
import 'package:cativou/principal/setores_and_start.dart';
//import 'package:cativou/signUp/alugarSignUp/step_one.dart';
//import 'package:cativou/signUp/gerenciarSignUp/step_oneGerenciar.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key, required this.tipo}) : super(key: key);

  final int tipo;

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class SegundaRota extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Segunda Rota (tela)"),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text('Retornar !'),
        ),
      ),
    );
  }
}

final GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email']);

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController senhaController = TextEditingController();
  final TextEditingController loginController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final maskCpf = MaskTextInputFormatter(
      mask: "###.###.###-##", filter: {"#": RegExp(r'[0-9]')});

  @override
  Widget build(BuildContext context) {
    /* GoogleSignInAccount? user = _currentUserGoogle;
    print(_currentUserGoogle);
    if (user != null) {
      tokenGoogle = user.id;
      postDataGoogle();
    }
    UserModelFacebook? userFacebook = _currentUserFacebook;
    if (userFacebook != null) {
      tokenFacebook = userFacebook.id!;
      postDataFacebook();
    }*/
    return Material(
      child: Center(
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("images/fundoCativou.jpg"),
              fit: BoxFit.fill,
            ),
          ),
          child: Form(
            key: _formKey,
            child: Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(45, 55, 45, 35),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(
                        width: 180,
                        child: Image.asset(
                          "images/cativouLogo.png",
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(height: 25),
                      SizedBox(
                          child: RichText(
                        text: TextSpan(
                            text: 'Autenticação',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold)),
                      )),
                      const SizedBox(height: 10),
                      TextFormField(
                        keyboardType: TextInputType.text,
                        autofocus: false,
                        controller: loginController,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          hintText: 'Login',
                          contentPadding:
                              EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 20.0),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16.0),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        keyboardType: TextInputType.visiblePassword,
                        obscureText: true,
                        autofocus: false,
                        controller: senhaController,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          hintText: 'Senha',
                          contentPadding:
                              EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 20.0),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16.0),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      ConstrainedBox(
                        constraints: const BoxConstraints.tightFor(
                            width: 150, height: 40),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: Color.fromARGB(255, 15, 119, 189),
                            onPrimary: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16.0),
                            ),
                          ),
                          onPressed: () async {
                            FocusScopeNode currentFocus =
                                FocusScope.of(context);
                            if (_formKey.currentState!.validate()) {
                              bool loginOk = await login();
                              if (!currentFocus.hasPrimaryFocus) {
                                currentFocus.unfocus();
                              }
                              if (loginOk) {
                                //print('ENTROU NA TELA');
                                /*Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => ChoicePage()));*/
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Setores()),
                                );
                              } else {
                                //print('NÃO ENTROU NA TELA');
                                senhaController.clear();
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(snackBar);
                              }
                            }
                          },
                          child: Text("Acessar".toUpperCase(),
                              style: const TextStyle(fontSize: 14)),
                        ),
                      ),
                      /* const SizedBox(height: 10),
                      InkWell(
                          child: SizedBox(
                            child: RichText(
                              text: TextSpan(
                                  text: 'Esqueceu a senha?',
                                  style: TextStyle(
                                      color: Colors.lightGreenAccent[400],
                                      fontSize: 20)),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          onTap: () {
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => PassRecovery()));
                          }),
                      const SizedBox(height: 10),
                      SizedBox(
                          child: RichText(
                        text: TextSpan(
                            text:
                                'Caso não tenha cadastro,\n clique aqui para se cadastrar!',
                            style:
                                TextStyle(color: Colors.white, fontSize: 17)),
                        textAlign: TextAlign.center,
                      )),
                      const SizedBox(height: 10),
                      ConstrainedBox(
                        constraints: const BoxConstraints.tightFor(
                            width: 150, height: 40),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: Colors.lightGreenAccent[400],
                            onPrimary: Colors.black,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0),
                            ),
                          ),
                          onPressed: () {
                            if (widget.tipo == 1) {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => StepOne()));
                            } else if (widget.tipo == 2) {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          StepOneGerenciar()));
                            }
                          },
                          child: Text("Cadastrar-se".toUpperCase(),
                              style: const TextStyle(fontSize: 12)),
                        ),
                      ),
                      const SizedBox(height: 10),
                      ConstrainedBox(
                        constraints: const BoxConstraints.tightFor(
                            width: 150, height: 40),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: Colors.white,
                            onPrimary: Colors.black,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0),
                            ),
                          ),
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => MyHomePage()));
                          },
                          child: Text("Voltar".toUpperCase(),
                              style: const TextStyle(fontSize: 12)),
                        ),
                      ),
                      const SizedBox(height: 10),
                      SizedBox(
                          child: RichText(
                        text: TextSpan(
                            text: 'Faça login Também por',
                            style:
                                TextStyle(color: Colors.white, fontSize: 17)),
                        textAlign: TextAlign.center,
                      )),
                      const SizedBox(height: 10),
                      ConstrainedBox(
                        constraints: const BoxConstraints.tightFor(
                            width: 280, height: 40),
                        child: // with custom text
                            SignInButton(
                          Buttons.Google,
                          text: "Login usando o google",
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                          onPressed: () async {
                            final _response = await signInGoogle();
                            setState(() {
                              _currentUserGoogle = _response;
                            });
                          },
                        ),
                      ),
                      const SizedBox(height: 15),
                      ConstrainedBox(
                        constraints: const BoxConstraints.tightFor(
                            width: 280, height: 40),
                        child: SignInButton(
                          Buttons.Facebook,
                          text: "Login usando o Facebook",
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                          onPressed: () {
                            signInFacebook();
                          },
                        ),
                      ),*/
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),

      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  final snackBar = SnackBar(
    content: Text(
      "email ou senha inválidos",
      textAlign: TextAlign.center,
    ),
    backgroundColor: Colors.redAccent,
  );
/*
  Future<String> getData() async {
    var response = await http.get(
        Uri.parse("https://gmpx.com.br/cativou/api/public/jogos/1"),
        headers: {"Accept": "application/json"});

    this.setState(() {
      estadios = json.decode(response.body);
      /* print(response.body); */
    });

    return "Success!";
  }*/

  bool login() {
    var login = loginController.text.replaceAll('.', '');
    var senha = senhaController.text;

    if (login == "recep" && senha == "ch1!@") {
      /*await sharedPreferences.setString(
            'login', "${login.replaceAll('-', '')}");
        await sharedPreferences.setString('senha', "${senhaController.text}");*/
      return true;
    } else {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text("Erro"),
              content: Text("Login ou senha inválida"),
              actions: [
                ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text("OK"))
              ],
            );
          });
      return false;
    }
    /*
    if (resposta.statusCode == 200) {
      print('Teste');
      print(resposta.body.toString());
      var verify = resposta.body.toString();
      if (verify == "[[]]") {
        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text("Erro"),
                content: Text("Usuário não cadastrado ou senha inválida"),
                actions: [
                  ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text("OK"))
                ],
              );
            });

        return false;
      } else {
        await sharedPreferences.setString(
            'login', "${login.replaceAll('-', '')}");
        await sharedPreferences.setString('senha', "${senhaController.text}");
        return true;
      }
      

    } else {
      print('Erro');
      print(resposta.body);
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text("Erro ao efetuar login"),
              content: Text("E-mail ou senha incorretos! Por favor, revise."),
              actions: [
                ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text("OK"))
              ],
            );
          });
      return false;
    }*/
  }

  //início dos códigos para google auth api

  /* GoogleSignInAccount? _currentUserGoogle;
  String tokenGoogle = '';

  void signOutGoogle() {
    _googleSignIn.disconnect();
  }

  Future<GoogleSignInAccount?> signInGoogle() async {
    final GoogleSignInAccount? _user;
    try {
      if (await _googleSignIn.isSignedIn() == true) {
        await _googleSignIn.disconnect();
        _user = await _googleSignIn.signIn();
      } else {
        _user = await _googleSignIn.signIn();
      }

      return _user;
    } catch (e) {
      print('erro $e');
    }
  }

  postDataGoogle() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    final url = "https://gmpx.com.br/cativou/api/public/login_by_google";
    var responseGoogle = await http.post(Uri.parse(url), body: {
      "token_google": tokenGoogle,
      "id_tipo": '2',
    });

    var jsonResponseGoogle = Error.fromJson((jsonDecode(responseGoogle.body)));
    print('aqui');
    print(responseGoogle.body);

    if (responseGoogle.statusCode == 200) {
      await sharedPreferences.setString('token_jwt',
          "TokenResp ${jsonDecode(responseGoogle.body)['token_jwt']}");
      await sharedPreferences.setString(
          'user_id', " ${jsonDecode(responseGoogle.body)['id']}");
      await sharedPreferences.setString(
          'user_color', " ${jsonDecode(responseGoogle.body)['color_user']}");
      await sharedPreferences.setString(
          'user_tipo', " ${jsonDecode(responseGoogle.body)['id_tipo']}");
      await sharedPreferences.setString(
          'image_perfil', " ${jsonDecode(responseGoogle.body)['img_perfil']}");

      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => ChoicePage()));
    } else {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text("Erro ao efetuar cadastro"),
              content: Text(jsonResponseGoogle.mensageError!),
              actions: [
                ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text("OK"))
              ],
            );
          });
    }
  }*/

  //Fim código para google auth api
  //incício dos códigos para facebook auth api
  /*AccessToken? _accessToken;
  UserModelFacebook? _currentUserFacebook;

  Future<void> signInFacebook() async {
    if (await FacebookAuth.i.accessToken != null) {
      await getUserFacebook();
    } else {
      final LoginResult result = await FacebookAuth.i.login();
      if (result.status == LoginStatus.success) {
        await getUserFacebook();
      }
    }
  }*/
/*
  Future<void> getUserFacebook() async {
    final data = await FacebookAuth.i.getUserData();
    UserModelFacebook model = UserModelFacebook.fromJson(data);
    await FacebookAuth.i.logOut();
    setState(() {
      _currentUserFacebook = model;
    });
  }

  Future<void> signOutFacebook() async {
    await FacebookAuth.i.logOut();

    setState(() {
      _currentUserFacebook = null;
      _accessToken = null;
    });
  }

  String tokenFacebook = '';

  postDataFacebook() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    final url = "https://gmpx.com.br/cativou/api/public/login_by_facebook";
    var responseFacebook = await http.post(Uri.parse(url), body: {
      "token_facebook": tokenFacebook,
    });

    var jsonResponseFacebook =
        Error.fromJson((jsonDecode(responseFacebook.body)));
    print(responseFacebook.body);

    if (responseFacebook.statusCode == 200) {
      await sharedPreferences.setString('token_jwt',
          "TokenResp ${jsonDecode(responseFacebook.body)['token_jwt']}");
      await sharedPreferences.setString(
          'user_id', " ${jsonDecode(responseFacebook.body)['id']}");
      await sharedPreferences.setString(
          'user_color', " ${jsonDecode(responseFacebook.body)['color_user']}");
      await sharedPreferences.setString(
          'user_tipo', " ${jsonDecode(responseFacebook.body)['id_tipo']}");
      await sharedPreferences.setString('image_perfil',
          " ${jsonDecode(responseFacebook.body)['img_perfil']}");
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => ChoicePage()));
    } else {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text("Erro ao efetuar cadastro"),
              content: Text(jsonResponseFacebook.mensageError!),
              actions: [
                ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text("OK"))
              ],
            );
          });
    }
  }*/
  //fim do código para facebook auth api

}

//class error to google api login
/*class Error {
  String? mensageError;

  Error({
    required this.mensageError,
  });

  factory Error.fromJson(Map<String, dynamic> json) => Error(
        mensageError: json["msg_error"],
      );
}*/

//classes usadas pelo faceboook api
/*
class UserModelFacebook {
  final String? email;
  final String? id;
  final String? name;

  const UserModelFacebook({this.email, this.name, this.id});

  factory UserModelFacebook.fromJson(Map<String, dynamic> json) =>
      UserModelFacebook(
          email: json['email'], id: json['id'] as String?, name: json['name']);
}*/
