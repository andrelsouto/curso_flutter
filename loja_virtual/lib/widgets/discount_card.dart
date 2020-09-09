import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:loja_virtual/models/cart_model.dart';

class DiscountCard extends StatefulWidget {
  @override
  _DiscountCardState createState() => _DiscountCardState();
}

class _DiscountCardState  extends State<DiscountCard> {

  var isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: ExpansionTile(
        title: Text('Cupom de Desconte',
          textAlign: TextAlign.start,
        style: TextStyle(fontWeight: FontWeight.w500, color: Colors.grey[700])),
        leading: Icon(Icons.card_giftcard),
        onExpansionChanged: (value) {
          setState(() {
            isExpanded = value;
          });
        },
        trailing: Icon(isExpanded ? Icons.remove : Icons.add),
        children: [
          Padding(
            padding: EdgeInsets.all(8),
            child: TextFormField(
              initialValue: CartModel.of(context).couponCode ?? '',
              decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Digite seu cupom'),
              onFieldSubmitted: (text) {
                FirebaseFirestore.instance.collection('coupons').doc(text.toUpperCase()).get()
                    .then((value) {
                      if (value.data() != null) {
                        CartModel.of(context).setCoupon(text, value.data()['percent']);
                        Scaffold.of(context).showSnackBar(SnackBar(
                          backgroundColor: Theme.of(context).primaryColor,
                          duration: Duration(seconds: 2),
                          content: Text('Desconto de ${value.data()['percent']}% aplicado!'),
                        ));
                        return;
                      }
                      CartModel.of(context).setCoupon(null, 0);
                      Scaffold.of(context).showSnackBar(SnackBar(
                        backgroundColor: Colors.redAccent,
                        duration: Duration(seconds: 2),
                        content: Text('Cupom Inválido!'),
                      ));
                });
              },
            ),
          )
        ],
      ),
    );
  }
}
