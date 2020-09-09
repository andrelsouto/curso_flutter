import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:loja_virtual/datas/product_data.dart';
import 'package:loja_virtual/tiles/product_tile.dart';

class CategoryScreen extends StatelessWidget {

  final DocumentSnapshot snapshot;

  CategoryScreen(this.snapshot);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(snapshot.data()['title']),
          centerTitle: true,
          bottom: TabBar(
            indicatorColor: Colors.white,
            tabs: [
              Tab(icon: Icon(Icons.grid_on),),
              Tab(icon: Icon(Icons.list),)
            ],
          ),
        ),
        body: FutureBuilder<QuerySnapshot>(
          future:
          FirebaseFirestore.instance.collection('products').doc(snapshot.id).collection('items').get(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) return Center(child: CircularProgressIndicator(),);

            return TabBarView(
              children: [
                GridView.builder(
                  padding: EdgeInsets.all(4),
                  gridDelegate:
                  SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 4,
                      crossAxisSpacing: 4,
                      childAspectRatio: 0.65),
                  itemCount: snapshot.data.docs.length,
                  itemBuilder: (context, index) {
                    var productData = ProductData.fromDocument(snapshot.data.docs[index])
                      ..category = this.snapshot.id;
                    return ProductTile('grid',
                        productData);
                  },
                ),
                ListView.builder(
                    itemCount: snapshot.data.docs.length,
                    itemBuilder: (context, index) {
                          var productData = ProductData.fromDocument(
                                  snapshot.data.docs[index])
                            ..category = this.snapshot.id;
                          return ProductTile(
                              'list',
                              productData);
                        })
              ],
            );
          },
        ),
      ),
    );
  }
}
