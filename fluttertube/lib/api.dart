import 'dart:convert';

import 'package:fluttertube/models/video.dart';
import 'package:http/http.dart' as http;

const String API_KEY = 'AIzaSyCpc5d0oyiDMYmJz8-HtmHBDXatUsWHO94';

class Api {

  String _token;
  String _search;

  Future<List<Video>> search(String search) async {
    var response = await http.get('https://www.googleapis.com/youtube/v3/search?part=snippet&q=$search&type=video&key=$API_KEY&maxResults=10');
    _search = search;
    return decode(response);
  }

  Future<List<Video>> nextPage() async {
    var response = await http.get('https://www.googleapis.com/youtube/v3/search?part=snippet&q=$_search&type=video&key=$API_KEY&maxResults=10&pageToken=$_token');

    return decode(response);
  }

  List<Video> decode(http.Response response) {
    if (response.statusCode == 200) {
      var decoded = json.decode(response.body);
      _token = decoded['nextPageToken'];
      List<Video> videos = decoded['items'].map<Video>((v) => Video.fromJson(v)).toList();
      return videos;
    }

    throw Exception('Faild to load videos');
  }



}