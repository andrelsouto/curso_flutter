import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    home: Splash(),
    debugShowCheckedModeBanner: false,
  ));
}


class Splash extends StatefulWidget {
  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {

  String _anim = 'spin1';


  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 3)).then((value) => Navigator.of(context).push(MaterialPageRoute(builder: (context) => Home())));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: GestureDetector(
          onTap: () {
            setState(() {
              _anim = _anim == 'spin1' ? 'spin2' : 'spin1';
            });
          },
          child: Container(
            width: 70,
            height: 70,
            child: FlareActor('assets/Gears.flr', animation: _anim,),
          ),
        ),
      ),
    );
  }
}

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('Flutter + Flare', style: TextStyle(fontSize: 30), textAlign: TextAlign.center,),
          Container(
            height: 100,
            width: 100,
            child: FlareActor('assets/AnimeHeart.flr', animation: 'pulse',),
          )
        ],
      ),
    );
  }
}

