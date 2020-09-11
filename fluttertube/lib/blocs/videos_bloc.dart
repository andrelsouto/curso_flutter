import 'dart:async';

import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:fluttertube/api.dart';
import 'package:fluttertube/models/video.dart';

class VideosBloc extends BlocBase {

  Api api;
  List<Video> videos;
  final _videosController = StreamController<List<Video>>();
  final _searchController = StreamController<String>();
  Stream get outVideos => _videosController.stream;
  Sink get inSearch => _searchController.sink;

  VideosBloc(){
    api = Api();

    _searchController.stream.listen(_search);
  }

  void _search(String search) async {

    if (search != null) {
      _videosController.sink.add([]);
      videos = await api.search(search);
    }
    if (search == null)
      videos += await api.nextPage();
    _videosController.sink.add(videos);
  }

  @override
  void dispose() {
    _videosController.close();
    _searchController.close();
    super.dispose();
  }
}