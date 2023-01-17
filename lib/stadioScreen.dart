import 'dart:convert';
import 'dart:io';
import 'package:cativou/principal/principal_page.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http_parser/http_parser.dart';
import 'package:webview_flutter/webview_flutter.dart';

class EstadioPage extends StatefulWidget {
  const EstadioPage({Key? key}) : super(key: key);

  @override
  State<EstadioPage> createState() => EstadioPageState();
}

class EstadioPageState extends State<EstadioPage> {
//controller para o cadastro da cadeira cativa

  final PageController pageController = PageController();

  @override
  void initState() {
    super.initState();
    this._loadUSerData();
  }

  //método pra carregar a imagem que vai ser postada no perfil do usuário
  File? _imageFile;
  _pickImageFromGallery(ImageSource source) async {
    final PickedFile = await ImagePicker().getImage(source: source);
    if (PickedFile != null) {
      setState(() => this._imageFile = File(PickedFile.path));
      final croppedImage =
          await ImageCropper.cropImage(sourcePath: _imageFile!.path);
      setState(() => this._imageFile = croppedImage);
    }
  }

  String _idUser = '';
  String _tipoUser = '';
  String _colorUser = '';
  late int corDoTime = int.parse(_colorUser);
//método pra carregar o id do usuário
  void _loadUSerData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _idUser = (prefs.getString('user_id') ?? '0');
      _tipoUser = (prefs.getString('user_tipo') ?? '0').trim();
      _colorUser = (prefs.getString('user_color') ?? '0xff99ff00');
    });
  }

  String? _valueCadeira;
//método pra carregar o id da cadeira que foi cadastrado
  void _loadIdCadeira() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _valueCadeira = (prefs.getString('userIdToUploadCadeira') ?? 'default');
      print(_valueCadeira);
    });
  }

//método pra fazer o cadastro da cadeira cativa do gerente de cadeira
  postCadeiraCativa() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    final url =
        "https://www.gmpx.com.br/cativou/api/public/cadastroCadeiraCativa";
    var response = await http.post(Uri.parse(url), body: {
      "id_usuario": _idUser,
      "id_estadio": 1.toString(),
      "fila": filaValue,
      "bloco": blocoValue,
      "cadeira": cadeiraValue,
    });
    print(response.statusCode);
    print(response.body);

    if (response.statusCode == 200) {
      await sharedPreferences.setString('userIdToUploadCadeira',
          " ${jsonDecode(response.body)['id_last_cadeira']}");

      _loadIdCadeira();
      //controller que chama a próxima página
      if (pageController.hasClients) {
        pageController.animateToPage(
          2,
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeInOut,
        );
      }
    } else if (response.statusCode == 201) {
      throw Exception('Ocorreu um erro inesperado');
    }
  }

  int? statusCodeCadeira;
  String blocoValue = '';
  String filaValue = '';
  String cadeiraValue = '';
  //método pra enviar a foto da cadeira do gerente para a api
  postFotoCadeira() {
    var requestFoto = http.MultipartRequest(
      'POST',
      Uri.parse("https://www.gmpx.com.br/cativou/api/public/uploadCartao"),
    );
    Map<String, String> headers = {"Content-type": "multipart/form-data"};
    requestFoto.fields["id_cartao"] = _valueCadeira!;
    requestFoto.files.add(
      http.MultipartFile(
        'cartao',
        _imageFile!.readAsBytes().asStream(),
        _imageFile!.lengthSync(),
        filename: "filename",
        contentType: MediaType('image', 'jpeg'),
      ),
    );
    requestFoto.headers.addAll(headers);
    print("request: " + requestFoto.toString());
    requestFoto.send().then((value) => statusCodeCadeira = value.statusCode);

    if (statusCodeCadeira == 200) {
    } else {
      print('erro ao enviar');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Center(
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("images/fundoCativou.jpg"),
              fit: BoxFit.cover,
            ),
          ),
          child: PageView(
              controller: pageController,
              physics: new NeverScrollableScrollPhysics(),
              children: [
                Column(
                  children: [
                    Expanded(
                      child: SizedBox(
                        width: 400,
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                          child: WebView(
                            initialUrl:
                                'https://www.gmpx.com.br/cativou/webview/estadio.php?id_usuario=$_idUser',
                            javascriptMode: JavascriptMode.unrestricted,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          if (_tipoUser == '1')
                            Center(
                              child: ConstrainedBox(
                                constraints: const BoxConstraints.tightFor(
                                    width: 250, height: 40),
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    primary: Color(corDoTime),
                                    onPrimary: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30.0),
                                    ),
                                  ),
                                  onPressed: () {
                                    if (pageController.hasClients) {
                                      pageController.animateToPage(
                                        1,
                                        duration:
                                            const Duration(milliseconds: 400),
                                        curve: Curves.easeInOut,
                                      );
                                    }
                                  },
                                  child: Text(
                                      "Cadastrar nova cadeira".toUpperCase(),
                                      style: const TextStyle(fontSize: 15)),
                                ),
                              ),
                            )
                          else
                            Center(
                              child: ConstrainedBox(
                                constraints: const BoxConstraints.tightFor(
                                    width: 250, height: 40),
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    primary: Color(corDoTime),
                                    onPrimary: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30.0),
                                    ),
                                  ),
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              PrincipalPage()),
                                    );
                                  },
                                  child: Text(
                                      "Alugar mais cadeiras".toUpperCase(),
                                      style: const TextStyle(fontSize: 15)),
                                ),
                              ),
                            ),
                        ],
                      ),
                    )
                  ],
                ),
                Scaffold(
                  backgroundColor: Colors.transparent,
                  body: Center(
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(45, 20, 45, 52),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
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
                            const SizedBox(height: 10),
                            SizedBox(
                                child: RichText(
                              text: TextSpan(
                                  text: 'DADOS DA CADEIRA CATIVA ',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold)),
                            )),
                            const SizedBox(height: 5),
                            SizedBox(
                                child: RichText(
                              text: TextSpan(
                                  text:
                                      'Informe os dados da cadeira cativa que pretende alugar ',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 17)),
                              textAlign: TextAlign.center,
                            )),
                            const SizedBox(height: 10),
                            Container(
                              padding: EdgeInsets.fromLTRB(25.0, 0, 100.0, 0),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(32.0),
                                color: Colors.white,
                              ),
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(0, 0, 75, 0),
                                child: DropdownButton(
                                  value:
                                      blocoValue.isNotEmpty ? blocoValue : null,
                                  hint: Text(
                                    'Bloco',
                                  ),
                                  dropdownColor: Colors.white,
                                  onChanged: (String? newValueBloco) {
                                    setState(() {
                                      blocoValue = newValueBloco!;
                                      if (blocoValue == '501' ||
                                          blocoValue == '502' ||
                                          blocoValue == '503' ||
                                          blocoValue == '509' ||
                                          blocoValue == '510' ||
                                          blocoValue == '511') {
                                        selectedFila = filaAteFinal;
                                      } else if (blocoValue == '504' ||
                                          blocoValue == '505' ||
                                          blocoValue == '507' ||
                                          blocoValue == '508') {
                                        selectedFila = filaAteLetraP;
                                      }
                                    });
                                  },
                                  items: <String>[
                                    '501',
                                    '502',
                                    '503',
                                    '504',
                                    '505',
                                    '507',
                                    '508',
                                    '509',
                                    '510',
                                    '511',
                                  ].map<DropdownMenuItem<String>>(
                                      (String value) {
                                    return new DropdownMenuItem<String>(
                                      child: new Text(
                                        value,
                                        style: TextStyle(color: Colors.black),
                                      ),
                                      value: value,
                                    );
                                  }).toList(),
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            Container(
                              padding: EdgeInsets.fromLTRB(25.0, 0, 115.0, 0),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(32.0),
                                color: Colors.white,
                              ),
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(0, 0, 75, 0),
                                child: DropdownButton(
                                  value:
                                      filaValue.isNotEmpty ? filaValue : null,
                                  hint: Text(
                                    'Fila',
                                  ),
                                  dropdownColor: Colors.white,
                                  onChanged: (String? newValueFila) {
                                    setState(() {
                                      filaValue = newValueFila!;
                                    });
                                  },
                                  items: selectedFila
                                      .map<DropdownMenuItem<String>>(
                                          (String valueFila) {
                                    return new DropdownMenuItem<String>(
                                      child: Text(
                                        valueFila,
                                        style: TextStyle(color: Colors.black),
                                      ),
                                      value: valueFila,
                                    );
                                  }).toList(),
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            Container(
                              padding: EdgeInsets.fromLTRB(25.0, 0, 80.0, 0),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(32.0),
                                color: Colors.white,
                              ),
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(0, 0, 75, 0),
                                child: DropdownButton(
                                  value: cadeiraValue.isNotEmpty
                                      ? cadeiraValue
                                      : null,
                                  hint: Text(
                                    'Cadeira',
                                  ),
                                  dropdownColor: Colors.white,
                                  onChanged: (String? newValueCadeira) {
                                    setState(() {
                                      cadeiraValue = newValueCadeira!;
                                    });
                                  },
                                  items: <String>[
                                    '01',
                                    '02',
                                    '03',
                                    '04',
                                    '05',
                                    '06',
                                    '07',
                                    '08',
                                    '09',
                                    '10',
                                    '11',
                                    '12',
                                    '13',
                                    '14',
                                    '15',
                                    '16',
                                    '17',
                                    '18',
                                    '19',
                                    '20',
                                    '21',
                                    '22',
                                    '23',
                                    '24',
                                    '25',
                                    '26',
                                    '27',
                                    '28',
                                    '29',
                                    '30',
                                    '31',
                                  ].map<DropdownMenuItem<String>>(
                                      (String valueCadeira) {
                                    return new DropdownMenuItem<String>(
                                      child: new Text(
                                        valueCadeira,
                                        style: TextStyle(color: Colors.black),
                                      ),
                                      value: valueCadeira,
                                    );
                                  }).toList(),
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            ConstrainedBox(
                              constraints: const BoxConstraints.tightFor(
                                  width: 270, height: 40),
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  primary: Color(corDoTime),
                                  onPrimary: Colors.black,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30.0),
                                  ),
                                ),
                                onPressed: () {
                                  postCadeiraCativa();
                                },
                                child: Text("Prosseguir".toUpperCase(),
                                    style: const TextStyle(fontSize: 20)),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),

                //Cadastro da foto da cadeira

                Container(
                  child: Center(
                    child: Column(
                      children: [
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
                        SizedBox(
                          child: RichText(
                            text: TextSpan(
                                text: ' Foto do cartão '.toUpperCase(),
                                style: TextStyle(
                                    color: Color(corDoTime), fontSize: 25)),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(25, 5, 35, 0),
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(10, 5, 0, 0),
                              child: SingleChildScrollView(
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Column(
                                          children: [
                                            Image.asset(
                                              'images/ico_foto_perfil.png',
                                              width: 90,
                                              color: Color(corDoTime),
                                            ),
                                            SizedBox(
                                              height: 15,
                                            ),
                                            Text(
                                              'Carregue a \n imagem do seu \n cartão',
                                              textAlign: TextAlign.left,
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 13),
                                            ),
                                            SizedBox(
                                              height: 20,
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                      0, 0, 0, 50),
                                              child: ConstrainedBox(
                                                constraints:
                                                    const BoxConstraints
                                                            .tightFor(
                                                        width: 140, height: 30),
                                                child: ElevatedButton(
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                    primary: Colors.white,
                                                    onPrimary: Colors.black,
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              30.0),
                                                    ),
                                                  ),
                                                  onPressed: () async =>
                                                      _pickImageFromGallery(
                                                          ImageSource.gallery),
                                                  child: Text(
                                                      "Carregar".toUpperCase(),
                                                      style: const TextStyle(
                                                          fontSize: 15)),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          width: 25,
                                        ),
                                        Column(
                                          children: [
                                            Column(
                                              children: [
                                                Image.asset(
                                                  'images/ico_camera_perfil.png',
                                                  width: 90,
                                                  color: Color(corDoTime),
                                                ),
                                                SizedBox(
                                                  height: 13,
                                                ),
                                                Text(
                                                  'Tire uma foto do \n seu cartão \n com sua camera',
                                                  textAlign: TextAlign.left,
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 13),
                                                ),
                                                SizedBox(
                                                  height: 20,
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.fromLTRB(
                                                          0, 0, 0, 50),
                                                  child: ConstrainedBox(
                                                    constraints:
                                                        const BoxConstraints
                                                                .tightFor(
                                                            width: 140,
                                                            height: 30),
                                                    child: ElevatedButton(
                                                      style: ElevatedButton
                                                          .styleFrom(
                                                        primary: Colors.white,
                                                        onPrimary: Colors.black,
                                                        shape:
                                                            RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      30.0),
                                                        ),
                                                      ),
                                                      onPressed: () async =>
                                                          _pickImageFromGallery(
                                                              ImageSource
                                                                  .camera),
                                                      child: Text(
                                                          "Tirar foto"
                                                              .toUpperCase(),
                                                          style:
                                                              const TextStyle(
                                                                  fontSize:
                                                                      15)),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                    Padding(
                                      padding:
                                          const EdgeInsets.fromLTRB(0, 0, 0, 0),
                                      child: Container(
                                        child: SizedBox(
                                          child: Center(
                                            child: Column(
                                              children: [
                                                // ignore: unnecessary_null_comparison
                                                if (this._imageFile == null)
                                                  const Icon(
                                                    Icons.photo,
                                                    size: 70,
                                                  )
                                                else
                                                  Image.file(
                                                    this._imageFile!,
                                                    width: 180,
                                                    height: 180,
                                                  ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                          child: ConstrainedBox(
                            constraints: const BoxConstraints.tightFor(
                                width: 270, height: 40),
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                primary: Colors.white,
                                onPrimary: Colors.black,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30.0),
                                ),
                              ),
                              onPressed: () {
                                postFotoCadeira();
                                showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        title: Text("Cadastro de Cadeira"),
                                        content: Text(
                                            "Cadeira cadastrada com sucesso!"),
                                        actions: [
                                          ElevatedButton(
                                              onPressed: () {
                                                Navigator.push(
                                                    this.context,
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          PrincipalPage(),
                                                    ));
                                              },
                                              child: Text("OK"))
                                        ],
                                      );
                                    });
                              },
                              child: Text("finalizar".toUpperCase(),
                                  style: const TextStyle(fontSize: 20)),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ]),
          // This trailing comma makes auto-formatting nicer for build methods.
        ),
      ),
    );
  }

  List<String> selectedFila = [];
  List<String> filaAteFinal = [
    'A',
    'B',
    'C',
    'D',
    'E',
    'F',
    'G',
    'H',
    'I',
    'J',
    'K',
    'L',
    'M',
    'N',
    'O',
    'P',
    'Q',
    'R',
    'S',
    'T',
    'U',
  ];

  List<String> filaAteLetraP = [
    'A',
    'B',
    'C',
    'D',
    'E',
    'F',
    'G',
    'H',
    'I',
    'J',
    'K',
    'L',
    'M',
    'N',
    'O',
    'P',
  ];
}
