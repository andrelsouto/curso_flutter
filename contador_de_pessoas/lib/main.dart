import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    title: 'Contador de Pessoas',
    home: Home()
  ));
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  var _counter = 0;
  var _infoText = 'Pode Entrar!';

  void changedCounter(int delta) {
    setState(() {
      _counter += delta;
      if (_counter < 0) {
        _infoText = 'Mundo invertido?!';
      } else if (_counter <= 10) {
        _infoText = 'Pode Entrar!';
      } else {
        _infoText = 'Lotado!';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Image.asset('images/restaurant.jpg',
          fit: BoxFit.cover,
          height: 10000,),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Pessoas: $_counter',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.all(10.0),
                  child: FlatButton(
                    child: Text('+1', style: TextStyle(
                        fontSize: 40,
                        color: Colors.white
                    ),),
                    onPressed: () {
                      changedCounter(1);
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(10.0),
                  child: FlatButton(
                    child: Text('-1', style: TextStyle(
                        fontSize: 40,
                        color: Colors.white
                    ),),
                    onPressed: () {
                      changedCounter(-1);
                    },
                  ),
                ),
              ],
            ),
            Text(_infoText,
              style: TextStyle(color: Colors.white, fontStyle: FontStyle.italic, fontSize: 30.0),)
          ],
        )
      ],
    );
  }
}

