import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class Setores extends StatefulWidget {
  const Setores({
    Key? key,
  }) : super(key: key);

  @override
  _Setores createState() => _Setores();
}

class Error {
  String? mensageError;

  Error({
    required this.mensageError,
  });

  factory Error.fromJson(Map<String, dynamic> json) => Error(
        mensageError: json["msg_error"],
      );
}

class _Setores extends State<Setores> {
  @override
  void initState() {
    super.initState();
    _loadUSerData();
    login3 = this.login;
    fetchSector();
  }

  String _scanBarcode = '';
  String _scanBarNome = '';
  String _scanBarWhatsApp = '';
  String _scanBarPertenceIgreja = '';
  String _scanBarStatus = 'aguardando scaneamento...';

// Platform messages are asynchronous, so we initialize in an async method.
  Future<void> scanBarcodeNormal() async {
    String barCodeScanRes;
    String barNome;
    String barStatus;
    String barWhatsApp;
    String barPertenceIgreja;
    String jsonData;
    setState(() {
      _scanBarStatus = 'carregando...';
    });
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      var barcodeScanRes2 = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Cancelar', true, ScanMode.QR);

      var url = Uri.parse(
          'https://nossoclamor.com/gto/confirma?id=25&code=$barcodeScanRes2&r=@1chinvcb2@');
      var result = await http.get(url, headers: {"Accept": "application/json"});

      if (jsonDecode(result.body)['cod_erro'] == "00") {
        barStatus = "INSCRIÇÃO OK!";
        barNome = jsonDecode(result.body)['nome'];
        barWhatsApp = jsonDecode(result.body)['whatsapp'];
        barPertenceIgreja = jsonDecode(result.body)['qual_igreja'];
      } else {
        barStatus = jsonDecode(result.body)['msg_erro'];
        barNome = "-";
        barWhatsApp = "-";
        barPertenceIgreja = "-";
      }
      barCodeScanRes = jsonDecode(result.body)['code'];

      print("<===barcodeScanRes===>");
      print(barCodeScanRes);
    } on PlatformException {
      barCodeScanRes = 'Failed to get platform version.';
      barStatus = 'erro';
      barNome = '';
      barWhatsApp = '';
      barPertenceIgreja = '';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _scanBarcode = barCodeScanRes;
      _scanBarStatus = barStatus;
      _scanBarNome = barNome;
      _scanBarWhatsApp = barWhatsApp;
      _scanBarPertenceIgreja = barPertenceIgreja;
      //Map<String, dynamic> data = jsonDecode(barcodeScanRes);
      print("barcodeScanRes===>");
      print(_scanBarcode);
      //print(data['cod']);
    });
  }

  List<SetoresResponse> _setoresResponse = [];
  //String selectedName;

  final PageController signUpController = PageController();

  int? statusCode;
  List? dataTime;
  String? _mySelectionTime;
  String? sid;
  String login = '';
  String? value;
  String? senha;

  List data = [];

  Future fetchSector() async {
    final prefs = await SharedPreferences.getInstance();

    this.login = prefs.getString('login')!;
    this.senha = prefs.getString('senha')!;

    var url = Uri.parse(
        'https://apps01.tre-mg.jus.br/aplicativos/php/inventario/scannerCB/index.php?u=$login&s=$senha');
    var result = await http.get(url, headers: {"Accept": "application/json"});
    var jsonData = json.decode(result.body);

    setState(() {
      data = jsonData;
    });
    return jsonData;
  }

  String? login3;

  final maskCpf = MaskTextInputFormatter(
      mask: "###.###.###-##", filter: {"#": RegExp(r'[0-9]')});
  final maskTelefone = MaskTextInputFormatter(
      mask: "## #####-####", filter: {"#": RegExp(r'[0-9]')});

  void _loadUSerData() async {
    final prefs = await SharedPreferences.getInstance();

    this.login = prefs.getString('login')!;
    setState(() {
      login = prefs.getString('login')!;
      senha = prefs.getString('senha')!;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          decoration: BoxDecoration(
            //color: Colors.grey,
            image: DecorationImage(
              image: AssetImage("images/fundoCativou.jpg"),
              fit: BoxFit.fill,
            ),
          ),
          child: PageView(
              controller: signUpController,
              physics: NeverScrollableScrollPhysics(),
              children: [
                Center(
                  child: SafeArea(
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
                            const SizedBox(height: 40),
                            SizedBox(
                                child: RichText(
                              text: TextSpan(
                                  text: 'CAPTURE O QR CODE:',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold)),
                              textAlign: TextAlign.center,
                            )),
                            const SizedBox(
                              height: 26,
                              width: 300,
                            ),
                            const SizedBox(height: 5),
                            ConstrainedBox(
                              constraints: const BoxConstraints.tightFor(
                                  width: 200, height: 40),
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  primary: Color.fromARGB(255, 9, 51, 75),
                                  onPrimary: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30.0),
                                  ),
                                ),
                                //onPressed: () => scanBarcodeNormal(),
                                onPressed: () {
                                  scanBarcodeNormal();
                                },
                                /**/
                                child: Text("Escanear".toUpperCase(),
                                    style: const TextStyle(fontSize: 20)),
                              ),
                            ),
                            const SizedBox(height: 70),
                            /*Text('RESULTADO:',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold)),*/

                            SizedBox(
                              width: 400.0,
                              child: Card(
                                  color: Color.fromARGB(236, 252, 216, 162),
                                  borderOnForeground: true,
                                  child: Padding(
                                      padding: EdgeInsets.all(10.0),
                                      child: Row(children: [
                                        Text(
                                          'Status: '.toUpperCase(),
                                          style: TextStyle(
                                              color: Color.fromARGB(
                                                  255, 39, 33, 33),
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                          '$_scanBarStatus',
                                          style: TextStyle(
                                              color: Color.fromARGB(
                                                  255, 39, 33, 33),
                                              fontSize: 14),
                                        ),
                                      ]))),
                            ),
                            SizedBox(
                              width: 400.0,
                              child: Card(
                                  color: Color.fromARGB(236, 252, 216, 162),
                                  borderOnForeground: true,
                                  child: Padding(
                                      padding: EdgeInsets.all(10.0),
                                      child: Row(children: [
                                        Text(
                                          'Nome: ',
                                          style: TextStyle(
                                              color: Color.fromARGB(
                                                  255, 39, 33, 33),
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                          '$_scanBarNome',
                                          style: TextStyle(
                                              color: Color.fromARGB(
                                                  255, 39, 33, 33),
                                              fontSize: 14),
                                        ),
                                      ]))),
                            ),
                            SizedBox(
                              width: 400.0,
                              child: Card(
                                  color: Color.fromARGB(236, 252, 216, 162),
                                  borderOnForeground: true,
                                  child: Padding(
                                      padding: EdgeInsets.all(10.0),
                                      child: Row(children: [
                                        Text(
                                          'Whats App: ',
                                          style: TextStyle(
                                              color: Color.fromARGB(
                                                  255, 39, 33, 33),
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                          '$_scanBarWhatsApp',
                                          style: TextStyle(
                                              color: Color.fromARGB(
                                                  255, 39, 33, 33),
                                              fontSize: 14),
                                        ),
                                      ]))),
                            ),
                            SizedBox(
                              width: 400.0,
                              child: Card(
                                  color: Color.fromARGB(236, 252, 216, 162),
                                  borderOnForeground: true,
                                  child: Padding(
                                      padding: EdgeInsets.all(10.0),
                                      child: Row(children: [
                                        Text(
                                          'Igreja: ',
                                          style: TextStyle(
                                              color: Color.fromARGB(
                                                  255, 39, 33, 33),
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                          '$_scanBarPertenceIgreja',
                                          style: TextStyle(
                                              color: Color.fromARGB(
                                                  255, 39, 33, 33),
                                              fontSize: 14),
                                        ),
                                      ]))),
                            ),

                            /* Text('Código: $_scanBarcode\n',
                                style: TextStyle(fontSize: 20)),
                            Text('Setor: $_scanBarsetor\n',
                                style: TextStyle(fontSize: 20))*/
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ]),
        ),
      ),

      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

class SetoresResponse {
  final String siglaSetorASI;
  final String cdSetorASI;

  SetoresResponse({required this.siglaSetorASI, required this.cdSetorASI});
  factory SetoresResponse.fromJson(Map<String, dynamic> json) {
    return new SetoresResponse(
        siglaSetorASI: json['id'], cdSetorASI: json['name']);
  }
}

_onAlertButtonsPressed(context) {
  Alert(
    context: context,
    type: AlertType.warning,
    title: "Selecione um setor",
    desc: "",
    buttons: [
      DialogButton(
        child: Text(
          "OK",
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
        onPressed: () => Navigator.pop(context),
        color: Color.fromRGBO(0, 179, 134, 1.0),
      )
    ],
  ).show();
}
