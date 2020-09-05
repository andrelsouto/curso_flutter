import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

const request = 'https://api.hgbrasil.com/finance?key=19e8c784';

main() async {

  runApp(MaterialApp(
    home: Home(),
    theme: ThemeData(
      hintColor: Colors.amber,
      primaryColor: Colors.white,
      inputDecorationTheme: InputDecorationTheme(
        enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.amber)),
        focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
        hintStyle: TextStyle(color: Colors.amber)
      ),
    ),
  ));
}

Future<Map> getData() async {
  var response = await http.get(request);
  return jsonDecode(response.body);
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  final realController = TextEditingController();
  final dolarController = TextEditingController();
  final euroController = TextEditingController();
  double dollar;
  double euro;

  void _realChanged(String text) {
    var real = double.parse(text);
    dolarController.text = (real / dollar).toStringAsFixed(2);
    euroController.text = (real / euro).toStringAsFixed(2);
  }

  void _dolarChanged(String text) {
    var dolar = double.parse(text);
    realController.text = (dolar * this.dollar).toStringAsFixed(2);
    euroController.text = (dolar * this.dollar / euro).toStringAsFixed(2);
  }

  void _euroChanged(String text) {
    var euro = double.parse(text);
    realController.text = (euro * this.euro).toStringAsFixed(2);
    euroController.text = (euro * this.euro / dollar).toStringAsFixed(2);

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(title: Text('\$ Conversor \$'),
        backgroundColor: Colors.amber,
        centerTitle: true,),
      body: FutureBuilder<Map>(
        future: getData(),
        builder: (context, snapshot) {
          switch(snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
              return Center(
                child: Text('Carregando dados',
                style: TextStyle(color: Colors.amber, fontSize: 25), textAlign: TextAlign.center,),);
            default:
              if (snapshot.hasError) {
                return Center(
                  child: Text('Erro ao carregar dados :(',
                    style: TextStyle(color: Colors.amber, fontSize: 25), textAlign: TextAlign.center,),);
              } else {
                 dollar = snapshot.data['results']['currencies']['USD']['buy'];
                 euro = snapshot.data['results']['currencies']['EUR']['buy'];
                return SingleChildScrollView(
                  padding: EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Icon(Icons.monetization_on, size: 150, color: Colors.amber,),
                      buildTextFild('Reais', 'R\$', realController, _realChanged),
                      Divider(),
                      buildTextFild('Dólares', 'US\$', dolarController, _dolarChanged),
                      Divider(),
                      buildTextFild('Euros', '€', euroController, _euroChanged)
                    ],
                  ),
                );
              }
          }
        },
      ),
    );
  }
}

Widget buildTextFild(String label, String prefix, TextEditingController controllerText, Function changed) {
  return TextField(
    decoration: InputDecoration(
        labelText: label, labelStyle: TextStyle(color: Colors.amber),
        prefixText: '$prefix '
    ),
    style: TextStyle(color: Colors.amber, fontSize: 25),
    controller: controllerText,
    onChanged: changed,
    keyboardType: TextInputType.numberWithOptions(decimal: true),
  );
}
