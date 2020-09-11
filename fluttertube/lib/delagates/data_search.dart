import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class DataSearch extends SearchDelegate<String> {
  @override
  List<Widget> buildActions(BuildContext context) {
    // TODO: implement buildActions
    return [
      IconButton(icon: Icon(Icons.clear), onPressed: () => query = '',)
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    // TODO: implement buildLeading
    return IconButton(
      icon: AnimatedIcon(icon: AnimatedIcons.menu_arrow, progress: transitionAnimation,), onPressed: () => close(context, null),);
  }

  @override
  Widget buildResults(BuildContext context) {
    // TODO: implement buildResults
    Future.delayed(Duration.zero).then((value) => close(context, query));
    return Container();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // TODO: implement buildSuggestions
    if (query.isEmpty) return Container();
    return FutureBuilder<List>(
      future: suggestions(query),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return Center(child: CircularProgressIndicator(),);

        return ListView.builder(
            itemCount: snapshot.data.length,
            itemBuilder: (context, index){
              return ListTile(
                title: Text(snapshot.data[index]),
                leading: Icon(Icons.play_arrow),
                onTap: () => close(context, snapshot.data[index]),
              );
            });
      },
    );
  }

  Future<List> suggestions(String search) async {
    var response = await http.get('http://suggestqueries.google.com/complete/search?hl=en&ds=yt&client=youtube&hjson=t&cp=1&q=$search&format=5&alt=json');

    if (response.statusCode == 200) {
      return jsonDecode(response.body)[1]
        .map((element) => element[0]).toList();
    }

    throw Exception('Failed to loag suggestions');
  }

}