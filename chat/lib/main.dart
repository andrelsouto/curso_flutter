import 'package:chat/chat_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      primaryColor: Colors.blue,
      iconTheme: (IconThemeData(
        color: Colors.blue
      ))
    ),
    home: MyApp(),
  ));

}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Firebase.initializeApp(),
      builder: (context, snapshot){
          if (snapshot.connectionState == ConnectionState.done) {
            return ChatScreen();
          }
          if (snapshot.hasError) {
            return Container(
              child: Text('Erro ao iniciar Firebase'),
            );
          };
          return Container(
            child: Text('Iniciando Firebase'),
          );
      },
    );
  }
}
