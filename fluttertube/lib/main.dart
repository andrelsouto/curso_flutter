import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:fluttertube/blocs/favorite_bloc.dart';
import 'package:fluttertube/blocs/videos_bloc.dart';
import 'package:fluttertube/screens/home_screen.dart';

void main() => runApp(BlocProvider(
  blocs: [
    Bloc((i) => VideosBloc()),
    Bloc((i) => FavoriteBloc())
  ],
  child: MaterialApp(
    home: Home(),
    debugShowCheckedModeBanner: false,
  ),
));


