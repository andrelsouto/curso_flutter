import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:loja_virtual/models/cart_model.dart';
import 'package:loja_virtual/models/user_model.dart';
import 'package:loja_virtual/screens/home_screen.dart';
import 'package:loja_virtual/screens/login_screen.dart';
import 'package:scoped_model/scoped_model.dart';

void main() => runApp(ClothesApp());

class ClothesApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Firebase.initializeApp(),
      builder: (context, snapshot){
        if (snapshot.connectionState == ConnectionState.done) {
          return ScopedModel<UserModel>(
            model: UserModel(),
            child: ScopedModelDescendant<UserModel>(
              builder: (context, child, model) {
                return ScopedModel<CartModel>(
                  model: CartModel(model),
                  child: MaterialApp(
                    title: 'Flutter\'s Clothing',
                    theme: ThemeData(
                        primarySwatch: Colors.blue,
                        primaryColor: Color.fromARGB(255, 4, 125, 141)
                    ),
                    debugShowCheckedModeBanner: false,
                    home: HomeScreen(),
                  ),
                );
              },
            ),
          );
        }
        if (snapshot.hasError) {
          return Container(child: Text('Ocorreu algum erro!'),);
        }
        return Container(
          color: Colors.white,
          child: Center(
            child: SizedBox(
              height: 50,
              child: CircularProgressIndicator(),
            )
          ),
        );
      },
    );
  }
}
