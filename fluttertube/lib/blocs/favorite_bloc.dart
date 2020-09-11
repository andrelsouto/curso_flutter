import 'dart:async';
import 'dart:convert';

import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:fluttertube/models/video.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FavoriteBloc extends BlocBase {

  Map<String, Video> _favorites = { };
  final _favController = BehaviorSubject<Map<String, Video>>();
  Stream<Map<String, Video>> get outFav => _favController.stream;

  FavoriteBloc() {
    SharedPreferences.getInstance()
        .then((prefs) {
          if (prefs.getKeys().contains('favorites')) {
            _favorites = json.decode(prefs.getString('favorites')).map(
                (k, v) => MapEntry(k, Video.fromJson(v))
            ).cast<String, Video>();
          _favController.sink.add(_favorites);
          }
    });
  }

  void toggleFavorite(Video video) {
    if (_favorites.containsKey(video.id)) {
      _favorites.remove(video.id);
    } else _favorites[video.id] = video;

    _favController.sink.add(_favorites);

    _saveFav();
  }

  @override
  void dispose() {
    _favController.close();
    super.dispose();
  }

  void _saveFav() {
    SharedPreferences.getInstance().then((value) {
      value.setString('favorites', json.encode(_favorites));
    });
  }
}