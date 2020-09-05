import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:loja_virtual/screens/home_screen.dart';

void main() => runApp(ClothesApp());

class ClothesApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Firebase.initializeApp(),
      builder: (context, snapshot){
        if (snapshot.connectionState == ConnectionState.done) {
          return MaterialApp(
            title: 'Flutter\'s Clothing',
            theme: ThemeData(
                primarySwatch: Colors.blue,
                primaryColor: Color.fromARGB(255, 4, 125, 141)
            ),
            debugShowCheckedModeBanner: false,
            home: HomeScreen(),
          );
        }
        if (snapshot.hasError) {
          return Container(child: Text('Ocorreu algum erro!'),);
        }
        return Container(
          child: Center(
            child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation(Colors.white),),
          ),
        );
      },
    );
  }
}
