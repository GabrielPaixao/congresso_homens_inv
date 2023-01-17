import 'dart:convert';

import 'package:cativou/login/shared/inital_page.dart';
//import 'package:cativou/signUp/alugarSignUp/step_one.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:shared_preferences/shared_preferences.dart';

//import 'package:cativou/login/shared/choiceStadium.dart';
import 'package:cativou/principal/principal_page.dart';
//import 'package:cativou/profile/privacyAndPolicy.dart';

class TabControllerPerfil extends StatefulWidget {
  const TabControllerPerfil({
    Key? key,
  }) : super(key: key);

  @override
  TabControllerPerfilState createState() => TabControllerPerfilState();
}

class UserInfo {
  final String? nome;
  final String? cpf;
  final String? celular;
  final String? email;
  final String? senha;
  final String? imgPerfil;
  final String idtime;
  final String? banco;
  final String? agencia;
  final String? conta;
  final String? pix;

  UserInfo({
    this.banco,
    this.agencia,
    this.conta,
    this.pix,
    required this.nome,
    this.cpf,
    this.celular,
    required this.email,
    this.senha,
    this.imgPerfil,
    required this.idtime,
  });

  Map<String, dynamic> toMap() {
    return {
      'nome': nome,
      'cpf': cpf,
      'celular': celular,
      'email': email,
      'senha': senha,
      'imgPerfil': imgPerfil,
      'idtime': idtime,
      'banco': banco,
      'conta': conta,
      'agencia': agencia,
      'pix': pix,
    };
  }

  factory UserInfo.fromMap(Map<String, dynamic> map) {
    String setImage() {
      if (map['img_perfil'] == null) {
        return 'https://www.gmpx.com.br/cativou-adm/admin/dist/img/img_perfil.png';
      } else {
        if (map['img_perfil'].toString().contains('https://')) {
          return map['img_perfil'];
        } else {
          return 'https://gmpx.com.br/cativou/api/public/files/${map['img_perfil']}';
        }
      }
    }

    return UserInfo(
      nome: map['nome'] ?? '',
      cpf: map['cpf'] ?? '',
      celular: map['celular'],
      email: map['email'] ?? '',
      senha: map['senha'] ?? '',
      imgPerfil: setImage(),
      idtime: map['idtime'] ?? '',
      conta: map['conta'] ?? '',
      agencia: map['agencia'] ?? '',
      banco: map['banco'] ?? '',
      pix: map['pix'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory UserInfo.fromJson(String source) =>
      UserInfo.fromMap(json.decode(source));
}

class TabControllerPerfilState extends State<TabControllerPerfil> {
  late TextEditingController nomeController = TextEditingController();
  late TextEditingController celularController = TextEditingController();
  late TextEditingController emailController = TextEditingController();
  late TextEditingController newSenhaController = TextEditingController();
  late TextEditingController bancoController = TextEditingController();
  late TextEditingController contaController = TextEditingController();
  late TextEditingController agenciaController = TextEditingController();
  late TextEditingController chavePixController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadUSerData();
    getDataTimes();
  }

  int dataData = 0;
  String _idUser = '';
  String _colorUser = '';
  String _tipoUser = '';
  late int corDoTime = int.parse(
    _colorUser,
  );
  List? dataTime;
  String? _mySelectionTime;

  Future<void> _loadUSerData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _colorUser = (prefs.getString('user_color') ?? '0xff99ff00');
      _idUser = (prefs.getString('user_id') ?? '0');
      _tipoUser = (prefs.getString('user_tipo') ?? '0').trim();
      print(_colorUser);
      print(_idUser);
      print(_tipoUser);
    });
  }

  @override
  bool _customTileExpanded = false;
  final double profileHeight = 100;

  Future<UserInfo?> fetch() async {
    try {
      var url =
          'https://gmpx.com.br/cativou/api/public/carregaUsuario/$_idUser';
      var resposta = await http.get(Uri.parse(url));

      if (resposta.statusCode == 200) {
        return UserInfo.fromJson(resposta.body);
      } else {
        throw Exception('Falha ao carregar informações do usuário');
      }
    } catch (e) {
      print(e);
    }
  }

  Future updateDadosPessoais() async {
    var url =
        Uri.parse('https://www.gmpx.com.br/cativou/api/public/updateAba1');
    var resposta = await http.post(
      url,
      body: {
        'id_usuario': _idUser,
        'id_tipo': _tipoUser,
        'nome': nomeController.text,
        'celular': celularController.text,
        'id_time': _mySelectionTime
      },
    );
    if (resposta.statusCode == 200) {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text("Dados Pessoias"),
              content: Text("Dados pessoais atualizados com sucesso!"),
              actions: [
                ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => PrincipalPage()));
                    },
                    child: Text("OK"))
              ],
            );
          });
    } else {}
  }

  Future updateDadosAcesso() async {
    var url =
        Uri.parse('https://www.gmpx.com.br/cativou/api/public/updateAba2');
    var resposta = await http.post(
      url,
      body: {
        'id_usuario': _idUser,
        'id_tipo': _tipoUser,
        'email': emailController.text,
        'senha': newSenhaController.text,
        "id_time": _mySelectionTime,
      },
    );
    if (resposta.statusCode == 200) {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text("Dados de Acesso"),
              content: Text("Dados de acesso atualizados com sucesso!"),
              actions: [
                ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => PrincipalPage()));
                    },
                    child: Text("OK"))
              ],
            );
          });
    } else {}
  }

  Future updateDadosBancarios() async {
    var url = Uri.parse(
        'https://gmpx.com.br/cativou/api/public/atualizaDadosBancarios');
    var resposta = await http.post(
      url,
      body: {
        'id_usuario': _idUser,
        'tipo_conta': 1.toString(),
        "banco": bancoController.text,
        "conta": contaController.text,
        "pix": chavePixController.text,
        "agencia": agenciaController.text,
      },
    );
    if (resposta.statusCode == 200) {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text("Dados Bancários"),
              content: Text("Dados Bancários atualizados com sucesso!"),
              actions: [
                ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => PrincipalPage()));
                    },
                    child: Text("OK"))
              ],
            );
          });
    } else {}
  }

  void onDataChange(int newData) {
    setState(() => dataData = newData);
  }

  //método para listar todos os times
  Future<String> getDataTimes() async {
    var responseTime = await http.get(
        Uri.parse("https://gmpx.com.br/cativou/api/public/times"),
        headers: {"Accept": "application/json"});

    this.setState(() {
      dataTime = json.decode(responseTime.body);
    });

    return "Success!";
  }

  final maskTelefone = MaskTextInputFormatter(
      mask: "## #####-####", filter: {"#": RegExp(r'[0-9]')});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Column(children: <Widget>[
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
                FutureBuilder<UserInfo?>(
                  future: fetch(),
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if (snapshot.hasData) {
                      //valida se os campos tem dados inseridos para efetuar upload
                      if (nomeController != null) {
                        nomeController = TextEditingController(
                            text: snapshot.data.nome ?? '');
                      } else {
                        nomeController = nomeController;
                      }
                      if (celularController != null) {
                        celularController = TextEditingController(
                            text: snapshot.data.celular ?? '');
                      } else {
                        celularController = celularController;
                      }
                      if (emailController != null) {
                        emailController = TextEditingController(
                            text: snapshot.data.email ?? '');
                      } else {
                        emailController = emailController;
                      }
                      //valida se o usuario é do tipo gerente e carrega dos dados para efetuar upload
                      if (_tipoUser == '1') {
                        if (bancoController != null) {
                          bancoController = TextEditingController(
                              text: snapshot.data.banco ?? '');
                        } else {
                          bancoController = bancoController;
                        }
                        if (contaController != null) {
                          contaController = TextEditingController(
                              text: snapshot.data.conta ?? '');
                        } else {
                          contaController = contaController;
                        }
                        if (agenciaController != null) {
                          agenciaController = TextEditingController(
                              text: snapshot.data.agencia ?? '');
                        } else {
                          agenciaController = agenciaController;
                        }
                        if (chavePixController != null) {
                          chavePixController = TextEditingController(
                              text: snapshot.data.pix ?? '');
                        } else {
                          chavePixController = chavePixController;
                        }
                      }

                      return Container(
                          child: Padding(
                        padding: const EdgeInsets.fromLTRB(20, 30, 20, 20),
                        child: Container(
                          color: Colors.transparent,
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.white,
                                style: BorderStyle.solid,
                                width: 2.0,
                              ),
                              color: Colors.transparent,
                              borderRadius: BorderRadius.circular(30.0),
                            ),
                            child: SingleChildScrollView(
                              child: Column(children: [
                                Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Container(
                                    width: 100,
                                    height: 100,
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                          color: Color(corDoTime),
                                          style: BorderStyle.solid,
                                          width: 2.0),
                                      borderRadius: new BorderRadius.only(
                                        topLeft: const Radius.circular(30.0),
                                        topRight: const Radius.circular(30.0),
                                        bottomRight:
                                            const Radius.circular(30.0),
                                      ),
                                    ),
                                    child: CircleAvatar(
                                        backgroundColor: Colors.transparent,
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.only(
                                              topRight: Radius.circular(30.0),
                                              topLeft: Radius.circular(30.0),
                                              bottomRight:
                                                  Radius.circular(30.0)),
                                          child: Image.network(
                                            snapshot.data.imgPerfil,
                                            fit: BoxFit.cover,
                                            height: 150.0,
                                            width: 100.0,
                                          ),
                                        )),
                                  ),
                                ),
                                SizedBox(
                                  child: RichText(
                                    text: TextSpan(
                                      text: '@' + snapshot.data.nome,
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  child: RichText(
                                    text: TextSpan(
                                      text: snapshot.data.nome,
                                      style: TextStyle(
                                          color: Color(corDoTime),
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(30, 30, 30, 40),
                                  child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              20, 0, 0, 5),
                                          child: SizedBox(
                                            child: RichText(
                                              text: TextSpan(
                                                text: 'MINHA CONTA ',
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 15,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              textAlign: TextAlign.start,
                                            ),
                                          ),
                                        ),
                                        SingleChildScrollView(
                                          child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Divider(
                                                  color: Color(corDoTime),
                                                  height: 20,
                                                  thickness: 3,
                                                  indent: 10,
                                                  endIndent: 10,
                                                ),
                                                ExpansionTile(
                                                  textColor: Colors.white,
                                                  title: Text(
                                                    'Dados Pessoais',
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 15,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                    textAlign: TextAlign.start,
                                                  ),
                                                  children: <Widget>[
                                                    Padding(
                                                      padding:
                                                          EdgeInsets.all(8.0),
                                                      child: TextField(
                                                        style: TextStyle(
                                                            color:
                                                                Colors.white),
                                                        keyboardType:
                                                            TextInputType
                                                                .emailAddress,
                                                        autofocus: true,
                                                        controller:
                                                            nomeController,
                                                        decoration:
                                                            InputDecoration(
                                                          labelText: 'Nome',
                                                          labelStyle: TextStyle(
                                                            color: Colors.white,
                                                          ),
                                                          border:
                                                              OutlineInputBorder(
                                                            borderRadius:
                                                                BorderRadius.all(
                                                                    Radius.circular(
                                                                        32.0)),
                                                            borderSide:
                                                                BorderSide(
                                                              width: 2.0,
                                                              color:
                                                                  Colors.white,
                                                            ),
                                                          ),
                                                          enabledBorder:
                                                              OutlineInputBorder(
                                                            borderRadius:
                                                                BorderRadius.all(
                                                                    Radius.circular(
                                                                        32.0)),
                                                            borderSide: BorderSide(
                                                                color: Color(
                                                                    corDoTime)),
                                                          ),
                                                          filled: true,
                                                          fillColor: Colors
                                                              .transparent,
                                                          hintStyle: TextStyle(
                                                              color:
                                                                  Colors.white),
                                                          contentPadding:
                                                              EdgeInsets
                                                                  .fromLTRB(
                                                                      10.0,
                                                                      10.0,
                                                                      10.0,
                                                                      10.0),
                                                        ),
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding:
                                                          EdgeInsets.all(8.0),
                                                      child: TextField(
                                                        style: TextStyle(
                                                            color:
                                                                Colors.white),
                                                        keyboardType:
                                                            TextInputType
                                                                .emailAddress,
                                                        inputFormatters: [
                                                          maskTelefone
                                                        ],
                                                        autofocus: true,
                                                        controller:
                                                            celularController,
                                                        decoration:
                                                            InputDecoration(
                                                          labelText: 'Celular',
                                                          labelStyle: TextStyle(
                                                            color: Colors.white,
                                                          ),
                                                          border:
                                                              OutlineInputBorder(
                                                            borderRadius:
                                                                BorderRadius.all(
                                                                    Radius.circular(
                                                                        32.0)),
                                                            borderSide:
                                                                BorderSide(
                                                              width: 2.0,
                                                              color:
                                                                  Colors.white,
                                                            ),
                                                          ),
                                                          enabledBorder:
                                                              OutlineInputBorder(
                                                            borderRadius:
                                                                BorderRadius.all(
                                                                    Radius.circular(
                                                                        32.0)),
                                                            borderSide: BorderSide(
                                                                color: Color(
                                                                    corDoTime)),
                                                          ),
                                                          filled: true,
                                                          fillColor: Colors
                                                              .transparent,
                                                          hintStyle: TextStyle(
                                                              color:
                                                                  Colors.white),
                                                          contentPadding:
                                                              EdgeInsets
                                                                  .fromLTRB(
                                                                      10.0,
                                                                      10.0,
                                                                      10.0,
                                                                      10.0),
                                                        ),
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding:
                                                          EdgeInsets.all(8.0),
                                                      child: Center(
                                                        child: Text(
                                                          " As cores do seu time serão carregadas\n quando se logar novamente ",
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.grey),
                                                        ),
                                                      ),
                                                    ),
                                                    Container(
                                                      padding:
                                                          EdgeInsets.fromLTRB(
                                                              55.0,
                                                              0.0,
                                                              55.0,
                                                              0.0),
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(32.0),
                                                        color: Colors.white,
                                                      ),
                                                      child: DropdownButton(
                                                        dropdownColor:
                                                            Colors.white,
                                                        items: dataTime
                                                            ?.map((item) {
                                                          return new DropdownMenuItem(
                                                            child: new Text(
                                                              item['time'],
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .black),
                                                            ),
                                                            value: item['id']
                                                                .toString(),
                                                          );
                                                        }).toList(),
                                                        onChanged:
                                                            (newValTime) {
                                                          setState(() {
                                                            _mySelectionTime =
                                                                newValTime
                                                                    as String?;
                                                          });
                                                        },
                                                        value: _mySelectionTime,
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding: const EdgeInsets
                                                              .fromLTRB(
                                                          180, 0, 0, 0),
                                                      child: SizedBox(
                                                        child: ElevatedButton(
                                                          style: ElevatedButton
                                                              .styleFrom(
                                                            primary: Color(
                                                                corDoTime),
                                                            onPrimary:
                                                                Colors.white,
                                                            shape: RoundedRectangleBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            30.0)),
                                                          ),
                                                          onPressed: () {
                                                            updateDadosPessoais();
                                                          },
                                                          child: Text('salvar'),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                if (_tipoUser == '1')
                                                  Divider(
                                                    color: Color(corDoTime),
                                                    height: 0,
                                                    thickness: 3,
                                                    indent: 10,
                                                    endIndent: 10,
                                                  ),
                                                if (_tipoUser == '1')
                                                  ExpansionTile(
                                                    textColor: Colors.white,
                                                    title: Text(
                                                      'Dados bancários',
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 15,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                      textAlign:
                                                          TextAlign.start,
                                                    ),
                                                    children: <Widget>[
                                                      Padding(
                                                        padding:
                                                            EdgeInsets.all(8.0),
                                                        child: TextField(
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white),
                                                          keyboardType:
                                                              TextInputType
                                                                  .text,
                                                          autofocus: false,
                                                          controller:
                                                              bancoController,
                                                          decoration:
                                                              InputDecoration(
                                                            labelText: 'Banco',
                                                            labelStyle:
                                                                TextStyle(
                                                              color:
                                                                  Colors.white,
                                                            ),
                                                            border:
                                                                OutlineInputBorder(
                                                              borderRadius: BorderRadius
                                                                  .all(Radius
                                                                      .circular(
                                                                          32.0)),
                                                              borderSide:
                                                                  BorderSide(
                                                                width: 2.0,
                                                                color: Colors
                                                                    .white,
                                                              ),
                                                            ),
                                                            enabledBorder:
                                                                OutlineInputBorder(
                                                              borderRadius: BorderRadius
                                                                  .all(Radius
                                                                      .circular(
                                                                          32.0)),
                                                              borderSide: BorderSide(
                                                                  color: Color(
                                                                      corDoTime)),
                                                            ),
                                                            filled: true,
                                                            fillColor: Colors
                                                                .transparent,
                                                            hintStyle: TextStyle(
                                                                color: Colors
                                                                    .white),
                                                            contentPadding:
                                                                EdgeInsets
                                                                    .fromLTRB(
                                                                        10.0,
                                                                        10.0,
                                                                        10.0,
                                                                        10.0),
                                                          ),
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding:
                                                            EdgeInsets.all(8.0),
                                                        child: TextField(
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white),
                                                          keyboardType:
                                                              TextInputType
                                                                  .number,
                                                          autofocus: false,
                                                          controller:
                                                              contaController,
                                                          decoration:
                                                              InputDecoration(
                                                            labelText: 'Conta',
                                                            labelStyle:
                                                                TextStyle(
                                                              color:
                                                                  Colors.white,
                                                            ),
                                                            border:
                                                                OutlineInputBorder(
                                                              borderRadius: BorderRadius
                                                                  .all(Radius
                                                                      .circular(
                                                                          32.0)),
                                                              borderSide:
                                                                  BorderSide(
                                                                width: 2.0,
                                                                color: Colors
                                                                    .white,
                                                              ),
                                                            ),
                                                            enabledBorder:
                                                                OutlineInputBorder(
                                                              borderRadius: BorderRadius
                                                                  .all(Radius
                                                                      .circular(
                                                                          32.0)),
                                                              borderSide: BorderSide(
                                                                  color: Color(
                                                                      corDoTime)),
                                                            ),
                                                            filled: true,
                                                            fillColor: Colors
                                                                .transparent,
                                                            hintStyle: TextStyle(
                                                                color: Colors
                                                                    .white),
                                                            contentPadding:
                                                                EdgeInsets
                                                                    .fromLTRB(
                                                                        10.0,
                                                                        10.0,
                                                                        10.0,
                                                                        10.0),
                                                          ),
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding:
                                                            EdgeInsets.all(8.0),
                                                        child: TextField(
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white),
                                                          keyboardType:
                                                              TextInputType
                                                                  .number,
                                                          autofocus: false,
                                                          controller:
                                                              agenciaController,
                                                          decoration:
                                                              InputDecoration(
                                                            labelText:
                                                                'Agência',
                                                            labelStyle:
                                                                TextStyle(
                                                              color:
                                                                  Colors.white,
                                                            ),
                                                            border:
                                                                OutlineInputBorder(
                                                              borderRadius: BorderRadius
                                                                  .all(Radius
                                                                      .circular(
                                                                          32.0)),
                                                              borderSide:
                                                                  BorderSide(
                                                                width: 2.0,
                                                                color: Colors
                                                                    .white,
                                                              ),
                                                            ),
                                                            enabledBorder:
                                                                OutlineInputBorder(
                                                              borderRadius: BorderRadius
                                                                  .all(Radius
                                                                      .circular(
                                                                          32.0)),
                                                              borderSide: BorderSide(
                                                                  color: Color(
                                                                      corDoTime)),
                                                            ),
                                                            filled: true,
                                                            fillColor: Colors
                                                                .transparent,
                                                            hintStyle: TextStyle(
                                                                color: Colors
                                                                    .white),
                                                            contentPadding:
                                                                EdgeInsets
                                                                    .fromLTRB(
                                                                        10.0,
                                                                        10.0,
                                                                        10.0,
                                                                        10.0),
                                                          ),
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding:
                                                            EdgeInsets.all(8.0),
                                                        child: TextField(
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white),
                                                          keyboardType:
                                                              TextInputType
                                                                  .number,
                                                          autofocus: false,
                                                          controller:
                                                              chavePixController,
                                                          decoration:
                                                              InputDecoration(
                                                            labelText:
                                                                'Chave PIX',
                                                            labelStyle:
                                                                TextStyle(
                                                              color:
                                                                  Colors.white,
                                                            ),
                                                            border:
                                                                OutlineInputBorder(
                                                              borderRadius: BorderRadius
                                                                  .all(Radius
                                                                      .circular(
                                                                          32.0)),
                                                              borderSide:
                                                                  BorderSide(
                                                                width: 2.0,
                                                                color: Colors
                                                                    .white,
                                                              ),
                                                            ),
                                                            enabledBorder:
                                                                OutlineInputBorder(
                                                              borderRadius: BorderRadius
                                                                  .all(Radius
                                                                      .circular(
                                                                          32.0)),
                                                              borderSide: BorderSide(
                                                                  color: Color(
                                                                      corDoTime)),
                                                            ),
                                                            filled: true,
                                                            fillColor: Colors
                                                                .transparent,
                                                            hintStyle: TextStyle(
                                                                color: Colors
                                                                    .white),
                                                            contentPadding:
                                                                EdgeInsets
                                                                    .fromLTRB(
                                                                        10.0,
                                                                        10.0,
                                                                        10.0,
                                                                        10.0),
                                                          ),
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .fromLTRB(
                                                                180, 0, 0, 0),
                                                        child: SizedBox(
                                                          child: ElevatedButton(
                                                            style:
                                                                ElevatedButton
                                                                    .styleFrom(
                                                              primary: Color(
                                                                  corDoTime),
                                                              onPrimary:
                                                                  Colors.white,
                                                              shape: RoundedRectangleBorder(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              30.0)),
                                                            ),
                                                            onPressed: () {
                                                              updateDadosBancarios();
                                                            },
                                                            child:
                                                                Text('salvar'),
                                                          ),
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding:
                                                            EdgeInsets.all(8.0),
                                                      ),
                                                    ],
                                                  ),
                                                //fim de tile para cadastro bancário
                                                Divider(
                                                  color: Color(corDoTime),
                                                  height: 0,
                                                  thickness: 3,
                                                  indent: 10,
                                                  endIndent: 10,
                                                ),
                                                ExpansionTile(
                                                  textColor: Colors.white,
                                                  title: Text(
                                                    'Dados de acesso',
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 15,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                    textAlign: TextAlign.start,
                                                  ),
                                                  children: <Widget>[
                                                    Padding(
                                                      padding:
                                                          EdgeInsets.all(8.0),
                                                      child: TextField(
                                                        style: TextStyle(
                                                            color:
                                                                Colors.white),
                                                        keyboardType:
                                                            TextInputType
                                                                .emailAddress,
                                                        autofocus: false,
                                                        controller:
                                                            emailController,
                                                        decoration:
                                                            InputDecoration(
                                                          labelText: 'Email',
                                                          labelStyle: TextStyle(
                                                            color: Colors.white,
                                                          ),
                                                          border:
                                                              OutlineInputBorder(
                                                            borderRadius:
                                                                BorderRadius.all(
                                                                    Radius.circular(
                                                                        32.0)),
                                                            borderSide:
                                                                BorderSide(
                                                              width: 2.0,
                                                              color:
                                                                  Colors.white,
                                                            ),
                                                          ),
                                                          enabledBorder:
                                                              OutlineInputBorder(
                                                            borderRadius:
                                                                BorderRadius.all(
                                                                    Radius.circular(
                                                                        32.0)),
                                                            borderSide: BorderSide(
                                                                color: Color(
                                                                    corDoTime)),
                                                          ),
                                                          filled: true,
                                                          fillColor: Colors
                                                              .transparent,
                                                          hintStyle: TextStyle(
                                                              color:
                                                                  Colors.white),
                                                          contentPadding:
                                                              EdgeInsets
                                                                  .fromLTRB(
                                                                      10.0,
                                                                      10.0,
                                                                      10.0,
                                                                      10.0),
                                                        ),
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding:
                                                          EdgeInsets.all(8.0),
                                                      child: TextField(
                                                        style: TextStyle(
                                                            color:
                                                                Colors.white),
                                                        keyboardType:
                                                            TextInputType
                                                                .emailAddress,
                                                        autofocus: false,
                                                        controller:
                                                            newSenhaController,
                                                        decoration:
                                                            InputDecoration(
                                                          labelText:
                                                              'Nova senha',
                                                          labelStyle: TextStyle(
                                                            color: Colors.white,
                                                          ),
                                                          border:
                                                              OutlineInputBorder(
                                                            borderRadius:
                                                                BorderRadius.all(
                                                                    Radius.circular(
                                                                        32.0)),
                                                            borderSide:
                                                                BorderSide(
                                                              width: 2.0,
                                                              color:
                                                                  Colors.white,
                                                            ),
                                                          ),
                                                          enabledBorder:
                                                              OutlineInputBorder(
                                                            borderRadius:
                                                                BorderRadius.all(
                                                                    Radius.circular(
                                                                        32.0)),
                                                            borderSide: BorderSide(
                                                                color: Color(
                                                                    corDoTime)),
                                                          ),
                                                          filled: true,
                                                          fillColor: Colors
                                                              .transparent,
                                                          hintStyle: TextStyle(
                                                              color:
                                                                  Colors.white),
                                                          contentPadding:
                                                              EdgeInsets
                                                                  .fromLTRB(
                                                                      10.0,
                                                                      10.0,
                                                                      10.0,
                                                                      10.0),
                                                        ),
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding: const EdgeInsets
                                                              .fromLTRB(
                                                          180, 0, 0, 0),
                                                      child: SizedBox(
                                                        child: ElevatedButton(
                                                          style: ElevatedButton
                                                              .styleFrom(
                                                            primary: Color(
                                                                corDoTime),
                                                            onPrimary:
                                                                Colors.white,
                                                            shape: RoundedRectangleBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            30.0)),
                                                          ),
                                                          onPressed: () {
                                                            updateDadosBancarios();
                                                          },
                                                          child: Text('salvar'),
                                                        ),
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding:
                                                          EdgeInsets.all(8.0),
                                                    ),
                                                  ],
                                                ),
                                                Divider(
                                                  color: Color(corDoTime),
                                                  height: 0,
                                                  thickness: 3,
                                                  indent: 10,
                                                  endIndent: 10,
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.fromLTRB(
                                                          20, 5, 0, 0),
                                                  child: SizedBox(
                                                    child: TextButton(
                                                      onPressed: () async {
                                                        bool saiu =
                                                            await sair();
                                                        if (saiu) {
                                                          Navigator.pushReplacement(
                                                              context,
                                                              MaterialPageRoute(
                                                                  builder:
                                                                      (context) =>
                                                                          MyHomePage()));
                                                        }
                                                      },
                                                      child: Text(
                                                        'Sair da conta ',
                                                        style: TextStyle(
                                                            color: Color(
                                                                corDoTime),
                                                            fontSize: 15,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ]),
                                        ),
                                      ]),
                                ),
                              ]),
                            ),
                          ),
                        ),
                      ));
                    } else if (snapshot.hasError) {
                      return Text(
                        '${snapshot.error}',
                        style: TextStyle(color: Colors.red),
                      );
                    }

                    // By default, show a loading spinner.
                    return Center(child: const CircularProgressIndicator());
                  },
                ),

                //inicia perfil para aba de eventos
                FutureBuilder<UserInfo?>(
                  future: fetch(),
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if (snapshot.hasData) {
                      //valida se os campos tem dados inseridos para efetuar upload
                      if (nomeController != null) {
                        nomeController = TextEditingController(
                            text: snapshot.data.nome ?? '');
                      } else {
                        nomeController = nomeController;
                      }
                      if (celularController != null) {
                        celularController = TextEditingController(
                            text: snapshot.data.celular ?? '');
                      } else {
                        celularController = celularController;
                      }
                      if (emailController != null) {
                        emailController = TextEditingController(
                            text: snapshot.data.email ?? '');
                      } else {
                        emailController = emailController;
                      }
                      //valida se o usuario é do tipo gerente e carrega dos dados para efetuar upload
                      if (_tipoUser == '1') {
                        if (bancoController != null) {
                          bancoController = TextEditingController(
                              text: snapshot.data.banco ?? '');
                        } else {
                          bancoController = bancoController;
                        }
                        if (contaController != null) {
                          contaController = TextEditingController(
                              text: snapshot.data.conta ?? '');
                        } else {
                          contaController = contaController;
                        }
                        if (agenciaController != null) {
                          agenciaController = TextEditingController(
                              text: snapshot.data.agencia ?? '');
                        } else {
                          agenciaController = agenciaController;
                        }
                        if (chavePixController != null) {
                          chavePixController = TextEditingController(
                              text: snapshot.data.pix ?? '');
                        } else {
                          chavePixController = chavePixController;
                        }
                      }

                      return Container(
                          child: Padding(
                        padding: const EdgeInsets.fromLTRB(20, 30, 20, 20),
                        child: Container(
                          color: Colors.transparent,
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.white,
                                style: BorderStyle.solid,
                                width: 2.0,
                              ),
                              color: Colors.transparent,
                              borderRadius: BorderRadius.circular(30.0),
                            ),
                            child: SingleChildScrollView(
                              child: Column(children: [
                                Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Container(
                                    width: 100,
                                    height: 100,
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                          color: Color(corDoTime),
                                          style: BorderStyle.solid,
                                          width: 2.0),
                                      borderRadius: new BorderRadius.only(
                                        topLeft: const Radius.circular(30.0),
                                        topRight: const Radius.circular(30.0),
                                        bottomRight:
                                            const Radius.circular(30.0),
                                      ),
                                    ),
                                    child: CircleAvatar(
                                        backgroundColor: Colors.transparent,
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.only(
                                              topRight: Radius.circular(30.0),
                                              topLeft: Radius.circular(30.0),
                                              bottomRight:
                                                  Radius.circular(30.0)),
                                          child: Image.network(
                                            snapshot.data.imgPerfil,
                                            fit: BoxFit.cover,
                                            height: 150.0,
                                            width: 100.0,
                                          ),
                                        )),
                                  ),
                                ),
                                SizedBox(
                                  child: RichText(
                                    text: TextSpan(
                                      text: '@' + snapshot.data.nome,
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  child: RichText(
                                    text: TextSpan(
                                      text: snapshot.data.nome,
                                      style: TextStyle(
                                          color: Color(corDoTime),
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(30, 30, 30, 40),
                                  child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              20, 0, 0, 5),
                                          child: SizedBox(
                                            child: RichText(
                                              text: TextSpan(
                                                text: 'MINHA CONTA ',
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 15,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              textAlign: TextAlign.start,
                                            ),
                                          ),
                                        ),
                                        SingleChildScrollView(
                                          child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Divider(
                                                  color: Color(corDoTime),
                                                  height: 20,
                                                  thickness: 3,
                                                  indent: 10,
                                                  endIndent: 10,
                                                ),
                                                ExpansionTile(
                                                  textColor: Colors.white,
                                                  title: Text(
                                                    'Dados Pessoais',
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 15,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                    textAlign: TextAlign.start,
                                                  ),
                                                  children: <Widget>[
                                                    Padding(
                                                      padding:
                                                          EdgeInsets.all(8.0),
                                                      child: TextField(
                                                        style: TextStyle(
                                                            color:
                                                                Colors.white),
                                                        keyboardType:
                                                            TextInputType
                                                                .emailAddress,
                                                        autofocus: true,
                                                        controller:
                                                            nomeController,
                                                        decoration:
                                                            InputDecoration(
                                                          labelText: 'Nome',
                                                          labelStyle: TextStyle(
                                                            color: Colors.white,
                                                          ),
                                                          border:
                                                              OutlineInputBorder(
                                                            borderRadius:
                                                                BorderRadius.all(
                                                                    Radius.circular(
                                                                        32.0)),
                                                            borderSide:
                                                                BorderSide(
                                                              width: 2.0,
                                                              color:
                                                                  Colors.white,
                                                            ),
                                                          ),
                                                          enabledBorder:
                                                              OutlineInputBorder(
                                                            borderRadius:
                                                                BorderRadius.all(
                                                                    Radius.circular(
                                                                        32.0)),
                                                            borderSide: BorderSide(
                                                                color: Color(
                                                                    corDoTime)),
                                                          ),
                                                          filled: true,
                                                          fillColor: Colors
                                                              .transparent,
                                                          hintStyle: TextStyle(
                                                              color:
                                                                  Colors.white),
                                                          contentPadding:
                                                              EdgeInsets
                                                                  .fromLTRB(
                                                                      10.0,
                                                                      10.0,
                                                                      10.0,
                                                                      10.0),
                                                        ),
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding:
                                                          EdgeInsets.all(8.0),
                                                      child: TextField(
                                                        style: TextStyle(
                                                            color:
                                                                Colors.white),
                                                        keyboardType:
                                                            TextInputType
                                                                .emailAddress,
                                                        inputFormatters: [
                                                          maskTelefone
                                                        ],
                                                        autofocus: true,
                                                        controller:
                                                            celularController,
                                                        decoration:
                                                            InputDecoration(
                                                          labelText: 'Celular',
                                                          labelStyle: TextStyle(
                                                            color: Colors.white,
                                                          ),
                                                          border:
                                                              OutlineInputBorder(
                                                            borderRadius:
                                                                BorderRadius.all(
                                                                    Radius.circular(
                                                                        32.0)),
                                                            borderSide:
                                                                BorderSide(
                                                              width: 2.0,
                                                              color:
                                                                  Colors.white,
                                                            ),
                                                          ),
                                                          enabledBorder:
                                                              OutlineInputBorder(
                                                            borderRadius:
                                                                BorderRadius.all(
                                                                    Radius.circular(
                                                                        32.0)),
                                                            borderSide: BorderSide(
                                                                color: Color(
                                                                    corDoTime)),
                                                          ),
                                                          filled: true,
                                                          fillColor: Colors
                                                              .transparent,
                                                          hintStyle: TextStyle(
                                                              color:
                                                                  Colors.white),
                                                          contentPadding:
                                                              EdgeInsets
                                                                  .fromLTRB(
                                                                      10.0,
                                                                      10.0,
                                                                      10.0,
                                                                      10.0),
                                                        ),
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding:
                                                          EdgeInsets.all(8.0),
                                                      child: Center(
                                                        child: Text(
                                                          " As cores do seu time serão carregadas\n quando se logar novamente ",
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.grey),
                                                        ),
                                                      ),
                                                    ),
                                                    Container(
                                                      padding:
                                                          EdgeInsets.fromLTRB(
                                                              55.0,
                                                              0.0,
                                                              55.0,
                                                              0.0),
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(32.0),
                                                        color: Colors.white,
                                                      ),
                                                      child: DropdownButton(
                                                        dropdownColor:
                                                            Colors.white,
                                                        items: dataTime
                                                            ?.map((item) {
                                                          return new DropdownMenuItem(
                                                            child: new Text(
                                                              item['time'],
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .black),
                                                            ),
                                                            value: item['id']
                                                                .toString(),
                                                          );
                                                        }).toList(),
                                                        onChanged:
                                                            (newValTime) {
                                                          setState(() {
                                                            _mySelectionTime =
                                                                newValTime
                                                                    as String?;
                                                          });
                                                        },
                                                        value: _mySelectionTime,
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding: const EdgeInsets
                                                              .fromLTRB(
                                                          180, 0, 0, 0),
                                                      child: SizedBox(
                                                        child: ElevatedButton(
                                                          style: ElevatedButton
                                                              .styleFrom(
                                                            primary: Color(
                                                                corDoTime),
                                                            onPrimary:
                                                                Colors.white,
                                                            shape: RoundedRectangleBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            30.0)),
                                                          ),
                                                          onPressed: () {
                                                            updateDadosPessoais();
                                                          },
                                                          child: Text('salvar'),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                if (_tipoUser == '1')
                                                  Divider(
                                                    color: Color(corDoTime),
                                                    height: 0,
                                                    thickness: 3,
                                                    indent: 10,
                                                    endIndent: 10,
                                                  ),
                                                if (_tipoUser == '1')
                                                  ExpansionTile(
                                                    textColor: Colors.white,
                                                    title: Text(
                                                      'Dados bancários',
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 15,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                      textAlign:
                                                          TextAlign.start,
                                                    ),
                                                    children: <Widget>[
                                                      Padding(
                                                        padding:
                                                            EdgeInsets.all(8.0),
                                                        child: TextField(
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white),
                                                          keyboardType:
                                                              TextInputType
                                                                  .text,
                                                          autofocus: false,
                                                          controller:
                                                              bancoController,
                                                          decoration:
                                                              InputDecoration(
                                                            labelText: 'Banco',
                                                            labelStyle:
                                                                TextStyle(
                                                              color:
                                                                  Colors.white,
                                                            ),
                                                            border:
                                                                OutlineInputBorder(
                                                              borderRadius: BorderRadius
                                                                  .all(Radius
                                                                      .circular(
                                                                          32.0)),
                                                              borderSide:
                                                                  BorderSide(
                                                                width: 2.0,
                                                                color: Colors
                                                                    .white,
                                                              ),
                                                            ),
                                                            enabledBorder:
                                                                OutlineInputBorder(
                                                              borderRadius: BorderRadius
                                                                  .all(Radius
                                                                      .circular(
                                                                          32.0)),
                                                              borderSide: BorderSide(
                                                                  color: Color(
                                                                      corDoTime)),
                                                            ),
                                                            filled: true,
                                                            fillColor: Colors
                                                                .transparent,
                                                            hintStyle: TextStyle(
                                                                color: Colors
                                                                    .white),
                                                            contentPadding:
                                                                EdgeInsets
                                                                    .fromLTRB(
                                                                        10.0,
                                                                        10.0,
                                                                        10.0,
                                                                        10.0),
                                                          ),
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding:
                                                            EdgeInsets.all(8.0),
                                                        child: TextField(
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white),
                                                          keyboardType:
                                                              TextInputType
                                                                  .number,
                                                          autofocus: false,
                                                          controller:
                                                              contaController,
                                                          decoration:
                                                              InputDecoration(
                                                            labelText: 'Conta',
                                                            labelStyle:
                                                                TextStyle(
                                                              color:
                                                                  Colors.white,
                                                            ),
                                                            border:
                                                                OutlineInputBorder(
                                                              borderRadius: BorderRadius
                                                                  .all(Radius
                                                                      .circular(
                                                                          32.0)),
                                                              borderSide:
                                                                  BorderSide(
                                                                width: 2.0,
                                                                color: Colors
                                                                    .white,
                                                              ),
                                                            ),
                                                            enabledBorder:
                                                                OutlineInputBorder(
                                                              borderRadius: BorderRadius
                                                                  .all(Radius
                                                                      .circular(
                                                                          32.0)),
                                                              borderSide: BorderSide(
                                                                  color: Color(
                                                                      corDoTime)),
                                                            ),
                                                            filled: true,
                                                            fillColor: Colors
                                                                .transparent,
                                                            hintStyle: TextStyle(
                                                                color: Colors
                                                                    .white),
                                                            contentPadding:
                                                                EdgeInsets
                                                                    .fromLTRB(
                                                                        10.0,
                                                                        10.0,
                                                                        10.0,
                                                                        10.0),
                                                          ),
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding:
                                                            EdgeInsets.all(8.0),
                                                        child: TextField(
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white),
                                                          keyboardType:
                                                              TextInputType
                                                                  .number,
                                                          autofocus: false,
                                                          controller:
                                                              agenciaController,
                                                          decoration:
                                                              InputDecoration(
                                                            labelText:
                                                                'Agência',
                                                            labelStyle:
                                                                TextStyle(
                                                              color:
                                                                  Colors.white,
                                                            ),
                                                            border:
                                                                OutlineInputBorder(
                                                              borderRadius: BorderRadius
                                                                  .all(Radius
                                                                      .circular(
                                                                          32.0)),
                                                              borderSide:
                                                                  BorderSide(
                                                                width: 2.0,
                                                                color: Colors
                                                                    .white,
                                                              ),
                                                            ),
                                                            enabledBorder:
                                                                OutlineInputBorder(
                                                              borderRadius: BorderRadius
                                                                  .all(Radius
                                                                      .circular(
                                                                          32.0)),
                                                              borderSide: BorderSide(
                                                                  color: Color(
                                                                      corDoTime)),
                                                            ),
                                                            filled: true,
                                                            fillColor: Colors
                                                                .transparent,
                                                            hintStyle: TextStyle(
                                                                color: Colors
                                                                    .white),
                                                            contentPadding:
                                                                EdgeInsets
                                                                    .fromLTRB(
                                                                        10.0,
                                                                        10.0,
                                                                        10.0,
                                                                        10.0),
                                                          ),
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding:
                                                            EdgeInsets.all(8.0),
                                                        child: TextField(
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white),
                                                          keyboardType:
                                                              TextInputType
                                                                  .number,
                                                          autofocus: false,
                                                          controller:
                                                              chavePixController,
                                                          decoration:
                                                              InputDecoration(
                                                            labelText:
                                                                'Chave PIX',
                                                            labelStyle:
                                                                TextStyle(
                                                              color:
                                                                  Colors.white,
                                                            ),
                                                            border:
                                                                OutlineInputBorder(
                                                              borderRadius: BorderRadius
                                                                  .all(Radius
                                                                      .circular(
                                                                          32.0)),
                                                              borderSide:
                                                                  BorderSide(
                                                                width: 2.0,
                                                                color: Colors
                                                                    .white,
                                                              ),
                                                            ),
                                                            enabledBorder:
                                                                OutlineInputBorder(
                                                              borderRadius: BorderRadius
                                                                  .all(Radius
                                                                      .circular(
                                                                          32.0)),
                                                              borderSide: BorderSide(
                                                                  color: Color(
                                                                      corDoTime)),
                                                            ),
                                                            filled: true,
                                                            fillColor: Colors
                                                                .transparent,
                                                            hintStyle: TextStyle(
                                                                color: Colors
                                                                    .white),
                                                            contentPadding:
                                                                EdgeInsets
                                                                    .fromLTRB(
                                                                        10.0,
                                                                        10.0,
                                                                        10.0,
                                                                        10.0),
                                                          ),
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .fromLTRB(
                                                                180, 0, 0, 0),
                                                        child: SizedBox(
                                                          child: ElevatedButton(
                                                            style:
                                                                ElevatedButton
                                                                    .styleFrom(
                                                              primary: Color(
                                                                  corDoTime),
                                                              onPrimary:
                                                                  Colors.white,
                                                              shape: RoundedRectangleBorder(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              30.0)),
                                                            ),
                                                            onPressed: () {
                                                              updateDadosBancarios();
                                                            },
                                                            child:
                                                                Text('salvar'),
                                                          ),
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding:
                                                            EdgeInsets.all(8.0),
                                                      ),
                                                    ],
                                                  ),
                                                //fim de tile para cadastro bancário
                                                Divider(
                                                  color: Color(corDoTime),
                                                  height: 0,
                                                  thickness: 3,
                                                  indent: 10,
                                                  endIndent: 10,
                                                ),
                                                ExpansionTile(
                                                  textColor: Colors.white,
                                                  title: Text(
                                                    'Dados de acesso',
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 15,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                    textAlign: TextAlign.start,
                                                  ),
                                                  children: <Widget>[
                                                    Padding(
                                                      padding:
                                                          EdgeInsets.all(8.0),
                                                      child: TextField(
                                                        style: TextStyle(
                                                            color:
                                                                Colors.white),
                                                        keyboardType:
                                                            TextInputType
                                                                .emailAddress,
                                                        autofocus: false,
                                                        controller:
                                                            emailController,
                                                        decoration:
                                                            InputDecoration(
                                                          labelText: 'Email',
                                                          labelStyle: TextStyle(
                                                            color: Colors.white,
                                                          ),
                                                          border:
                                                              OutlineInputBorder(
                                                            borderRadius:
                                                                BorderRadius.all(
                                                                    Radius.circular(
                                                                        32.0)),
                                                            borderSide:
                                                                BorderSide(
                                                              width: 2.0,
                                                              color:
                                                                  Colors.white,
                                                            ),
                                                          ),
                                                          enabledBorder:
                                                              OutlineInputBorder(
                                                            borderRadius:
                                                                BorderRadius.all(
                                                                    Radius.circular(
                                                                        32.0)),
                                                            borderSide: BorderSide(
                                                                color: Color(
                                                                    corDoTime)),
                                                          ),
                                                          filled: true,
                                                          fillColor: Colors
                                                              .transparent,
                                                          hintStyle: TextStyle(
                                                              color:
                                                                  Colors.white),
                                                          contentPadding:
                                                              EdgeInsets
                                                                  .fromLTRB(
                                                                      10.0,
                                                                      10.0,
                                                                      10.0,
                                                                      10.0),
                                                        ),
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding:
                                                          EdgeInsets.all(8.0),
                                                      child: TextField(
                                                        style: TextStyle(
                                                            color:
                                                                Colors.white),
                                                        keyboardType:
                                                            TextInputType
                                                                .emailAddress,
                                                        autofocus: false,
                                                        controller:
                                                            newSenhaController,
                                                        decoration:
                                                            InputDecoration(
                                                          labelText:
                                                              'Nova senha',
                                                          labelStyle: TextStyle(
                                                            color: Colors.white,
                                                          ),
                                                          border:
                                                              OutlineInputBorder(
                                                            borderRadius:
                                                                BorderRadius.all(
                                                                    Radius.circular(
                                                                        32.0)),
                                                            borderSide:
                                                                BorderSide(
                                                              width: 2.0,
                                                              color:
                                                                  Colors.white,
                                                            ),
                                                          ),
                                                          enabledBorder:
                                                              OutlineInputBorder(
                                                            borderRadius:
                                                                BorderRadius.all(
                                                                    Radius.circular(
                                                                        32.0)),
                                                            borderSide: BorderSide(
                                                                color: Color(
                                                                    corDoTime)),
                                                          ),
                                                          filled: true,
                                                          fillColor: Colors
                                                              .transparent,
                                                          hintStyle: TextStyle(
                                                              color:
                                                                  Colors.white),
                                                          contentPadding:
                                                              EdgeInsets
                                                                  .fromLTRB(
                                                                      10.0,
                                                                      10.0,
                                                                      10.0,
                                                                      10.0),
                                                        ),
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding: const EdgeInsets
                                                              .fromLTRB(
                                                          180, 0, 0, 0),
                                                      child: SizedBox(
                                                        child: ElevatedButton(
                                                          style: ElevatedButton
                                                              .styleFrom(
                                                            primary: Color(
                                                                corDoTime),
                                                            onPrimary:
                                                                Colors.white,
                                                            shape: RoundedRectangleBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            30.0)),
                                                          ),
                                                          onPressed: () {
                                                            updateDadosBancarios();
                                                          },
                                                          child: Text('salvar'),
                                                        ),
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding:
                                                          EdgeInsets.all(8.0),
                                                    ),
                                                  ],
                                                ),
                                                Divider(
                                                  color: Color(corDoTime),
                                                  height: 0,
                                                  thickness: 3,
                                                  indent: 10,
                                                  endIndent: 10,
                                                ),
                                                Divider(
                                                  color: Color(corDoTime),
                                                  height: 0,
                                                  thickness: 3,
                                                  indent: 10,
                                                  endIndent: 10,
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.fromLTRB(
                                                          20, 5, 0, 0),
                                                  child: SizedBox(
                                                    child: TextButton(
                                                      onPressed: () async {
                                                        bool saiu =
                                                            await sair();
                                                        if (saiu) {
                                                          Navigator.pushReplacement(
                                                              context,
                                                              MaterialPageRoute(
                                                                  builder:
                                                                      (context) =>
                                                                          MyHomePage()));
                                                        }
                                                      },
                                                      child: Text(
                                                        'Sair da conta ',
                                                        style: TextStyle(
                                                            color: Color(
                                                                corDoTime),
                                                            fontSize: 15,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ]),
                                        ),
                                      ]),
                                ),
                              ]),
                            ),
                          ),
                        ),
                      ));
                    } else if (snapshot.hasError) {
                      return Text(
                        '${snapshot.error}',
                        style: TextStyle(color: Colors.red),
                      );
                    }

                    // By default, show a loading spinner.
                    return Center(child: const CircularProgressIndicator());
                  },
                ),

                //finaliza perfil para aba de eventos
              ],
            ),
          )
        ]));
  }

  Future<bool> sair() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.clear();
    return true;
  }

  final GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email']);

  Future<void> signOutGoogle() async {
    await _googleSignIn.disconnect();
  }

  AccessToken? _accessToken;
  //UserModelFacebook? _currentUserFacebook;
/*
  Future<void> signOutFacebook() async {
    await FacebookAuth.i.logOut();
    setState(() {
      _currentUserFacebook = null;
      _accessToken = null;
    });
  }*/
}
