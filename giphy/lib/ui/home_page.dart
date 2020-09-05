import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:giphy/ui/gif_page.dart';
import 'package:http/http.dart' as http;
import 'package:share/share.dart';
import 'package:transparent_image/transparent_image.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  String _search;
  var _offset = 0;

  Future<Map> _getGif() async {

    http.Response response;

    if (_search == null || _search.isEmpty) {
      response = await http.get('https://api.giphy.com/v1/gifs/trending?api_key=tNsAXt86yuaUKIn34DyXDMG6egEJo0W4&limit=20&rating=g');
    } else {
      response = await http.get('https://api.giphy.com/v1/gifs/search?api_key=tNsAXt86yuaUKIn34DyXDMG6egEJo0W4&q=$_search&limit=19&offset=$_offset&rating=g&lang=pt');
    }

    return jsonDecode(response.body);
  }


  @override
  void initState() {
    super.initState();

    _getGif().then((value) => print(value));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Image.network('https://developers.giphy.com/static/img/dev-logo-lg.7404c00322a8.gif'),
        centerTitle: true,
      ),
      backgroundColor: Colors.black,
      body: Column(
        children: [
          Padding(padding: EdgeInsets.all(10),
          child: TextField(
            decoration: InputDecoration(
                labelText: 'Pesquise aqui',
                labelStyle: TextStyle(color: Colors.white),
                border: OutlineInputBorder()
            ),
            style: TextStyle(color: Colors.white, fontSize: 18),
            textAlign: TextAlign.center,
            onSubmitted: (value) {
              setState(() {
                _search = value;
                _offset = 0;
              });
            },
          ),),
          Expanded(
            child: FutureBuilder(
              future: _getGif(),
              builder: (context, snapshot) {
                switch(snapshot.connectionState) {
                  case ConnectionState.waiting:
                  case ConnectionState.none:
                    return Container(
                      width: 200,
                      height: 200,
                      alignment: Alignment.center,
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        strokeWidth: 5,
                      ),
                    );
                  default:
                    if (snapshot.hasError) return Container();
                    return _createGifTable(context, snapshot);
                }
              },
            ),
          )
        ],
      ),
    );
  }

  int _getCount(List data) {
    if (_search == null) return data.length;

    return data.length + 1;
  }

  Widget _createGifTable(BuildContext context, AsyncSnapshot snapshot) {
    return GridView.builder(
        padding: EdgeInsets.all(10),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10
        ),
        itemCount: _getCount(snapshot.data['data']),
        itemBuilder: (contex, index) {

          if (_search == null || _search.isEmpty || index < snapshot.data['data'].length) {
            return GestureDetector(
              child: FadeInImage.memoryNetwork(
                  placeholder: kTransparentImage,
                  image: snapshot.data['data'][index]['images']['fixed_height']['url'],
                  height: 300,
                  fit: BoxFit.cover,),
              onTap: () {
                Navigator.push(context,
                  MaterialPageRoute(builder: (context) => GiphyPage(snapshot.data['data'][index])));
              },
            onLongPress: () {
                Share.share(snapshot.data['data'][index]['images']['fixed_height']['url']);
            },);
          }

          return Container(
            child: GestureDetector(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.add, color: Colors.white, size: 70,),
                  Text('Carregar mais...', style: TextStyle(color: Colors.white, fontSize: 22),)
                ],
              ),
              onTap: () {
                setState(() {
                  _offset += 19;
                });
              },
            ),
          );

        });
  }
}
