import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:flutter_youtube/flutter_youtube.dart';
import 'package:fluttertube/api.dart';
import 'package:fluttertube/blocs/favorite_bloc.dart';
import 'package:fluttertube/models/video.dart';

class FavoritesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final favBloc = BlocProvider.getBloc<FavoriteBloc>();
    return Scaffold(
      appBar: AppBar(
        title: Text('Favoritos'),
        centerTitle: true,
        backgroundColor: Colors.black,
      ),
      backgroundColor: Colors.black,
      body: StreamBuilder<Map<String, Video>>(
        stream: favBloc.outFav,
        initialData: {},
        builder: (context, snapshot){
          return ListView(
            children:
              snapshot.data.values.map((video) =>
                InkWell(
                  onTap: () =>
                    FlutterYoutube.playYoutubeVideoById(
                        apiKey: API_KEY,
                        videoId: video.id,
                        appBarColor: Colors.black,),
                  onLongPress: () => favBloc.toggleFavorite(video),
                  child: Row(
                    children: [
                      Container(
                        width: 100,
                        height: 50,
                        child: Image.network(video.thumb),
                      ),
                      Expanded(
                        child: Text(video.title, style: TextStyle(color: Colors.white70), maxLines: 2,),
                      )
                    ],
                  ),
                )).toList(),
          );
        },
      ),
    );
  }
}
