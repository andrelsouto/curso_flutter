import 'package:flutter/material.dart';
import 'package:giphy/ui/home_page.dart';

main() {
  runApp(MaterialApp(
    home: HomePage(),
    theme: ThemeData(

        inputDecorationTheme: InputDecorationTheme(
          enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white))
        )),
  ));
}
