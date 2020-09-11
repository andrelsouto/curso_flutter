import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:fluttertube/blocs/favorite_bloc.dart';
import 'package:fluttertube/blocs/videos_bloc.dart';
import 'package:fluttertube/delagates/data_search.dart';
import 'package:fluttertube/models/video.dart';
import 'package:fluttertube/screens/favorites_screen.dart';
import 'package:fluttertube/widgets/video_tile.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final videoBloc = BlocProvider.getBloc<VideosBloc>();
    final favBloc = BlocProvider.getBloc<FavoriteBloc>();
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Container(
          height: 25,
          child: Image.asset('images/logo.png'),
        ),
        elevation: 0,
        backgroundColor: Colors.black87,
        actions: [
          StreamBuilder<Map<String, Video>>(
            initialData: { },
            stream: favBloc.outFav,
            builder: (context, snapshot) {
              return Align(
                alignment: Alignment.center,
                child: Text(snapshot.data.length.toString(), textAlign: TextAlign.center,),
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.star),
            onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (context) => FavoritesScreen())),
          ),
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () async
            {
              String result = await showSearch(context: context, delegate: DataSearch());
              if (result != null) videoBloc.inSearch.add(result);
            },
          )
        ],
      ),
      body: StreamBuilder(
        initialData: [],
        stream: videoBloc.outVideos,
        builder: (context, snapshot) {
          if (!snapshot.hasData) return Container();
          return ListView.builder(
              itemCount: snapshot.data.length + 1,
              itemBuilder: (context, index){
                if (index < snapshot.data.length) {
                  return VideoTile(snapshot.data[index]);
                }
                if (index > 1) {
                  videoBloc.inSearch.add(null);
                  return Container(
                    height: 40,
                    width: 14,
                    alignment: Alignment.center,
                    child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.red),),);
                }

                return Container();
              });
        },
      ),
    );
  }
}
