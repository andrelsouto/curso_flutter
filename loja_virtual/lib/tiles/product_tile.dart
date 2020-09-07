import 'package:flutter/material.dart';
import 'package:loja_virtual/datas/product_data.dart';
import 'package:loja_virtual/screens/product_screen.dart';

class ProductTile extends StatelessWidget {

  final String viewMode;
  final ProductData product;

  ProductTile(this.viewMode, this.product);

  @override
  Widget build(BuildContext context) {

    return InkWell(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(builder: (context) => ProductScreen(product)));
      },
      child: Card(
        child: viewMode == 'grid' ?
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              AspectRatio(
                aspectRatio: 0.85,
                child: Image.network(
                    product.images[0],
                    fit: BoxFit.cover,),
              ),
              Expanded(
                child: Container(
                  padding: EdgeInsets.all(8),
                  child: Column(
                    children: [
                      Text(product.title, style: TextStyle(fontWeight: FontWeight.w500),),
                      Text('R\$ ${product.price.toStringAsFixed(2)}',
                        style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontSize: 18,
                            fontWeight: FontWeight.bold),),
                    ],
                  ),
                ),
              )
            ],
          ) :
        Row(
          children: [
            Flexible(
              flex: 1,
              child: Image.network(
                product.images[0],
                height: 250,
                fit: BoxFit.cover,),
            ),
            Flexible(
              flex: 1,
              child: Container(
                padding: EdgeInsets.all(8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(product.title, style: TextStyle(fontWeight: FontWeight.w500),),
                    Text('R\$ ${product.price.toStringAsFixed(2)}',
                      style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontSize: 18,
                          fontWeight: FontWeight.bold),),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );

  }
}
