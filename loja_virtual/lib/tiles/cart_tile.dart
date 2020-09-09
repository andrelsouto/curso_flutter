import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:loja_virtual/datas/cart_product.dart';
import 'package:loja_virtual/datas/product_data.dart';
import 'package:loja_virtual/models/cart_model.dart';

class CartTile extends StatelessWidget {

  final CartProduct _cartProduct;

  CartTile(this._cartProduct);

  @override
  Widget build(BuildContext context) {

    Widget _buildContent() {
      CartModel.of(context).updatePrices();
      return Row(
        children: [
          Container(
            padding: EdgeInsets.all(8),
            width: 120,
            child: Image.network(_cartProduct.productData.images[0], fit: BoxFit.cover,),
          ),
          Expanded(
            child: Container(
              padding: EdgeInsets.all(9),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(_cartProduct.productData.title, style: TextStyle(fontWeight: FontWeight.w500, fontSize: 17),),
                  Text('Tamanho ${_cartProduct.size}', style: TextStyle(fontWeight: FontWeight.w300),),
                  Text('R\$ ${_cartProduct.productData.price.toStringAsFixed(2)}',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Theme.of(context).primaryColor),),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      IconButton(
                        icon: Icon(Icons.remove),
                        color: Theme.of(context).primaryColor,
                        onPressed: _cartProduct.quantity > 1 ? () => CartModel.of(context).decProduct(_cartProduct) : null,
                      ),
                      Text(_cartProduct.quantity.toString()),
                      IconButton(
                        icon: Icon(Icons.add),
                        color: Theme.of(context).primaryColor,
                        onPressed: () => CartModel.of(context).incProduct(_cartProduct),
                      ),
                      FlatButton(
                        child: Text('Remover'),
                        textColor: Colors.grey[500],
                        onPressed: () => CartModel.of(context).removeCartItem(_cartProduct),
                      )
                    ],
                  )
                ],
              ),
            ),
          )
        ],
      );
    }

    return Card(
      margin: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      child: _cartProduct.productData == null ?
        FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance.collection('products').doc(_cartProduct.category)
          .collection('items').doc(_cartProduct.pid).get(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            _cartProduct.productData = ProductData.fromDocument(snapshot.data);
            return _buildContent();
          }
          return Container(
            height: 70,
            child: CircularProgressIndicator(),
            alignment: Alignment.center,
          );
    }
    ) :
        _buildContent()
    );

  }
}
