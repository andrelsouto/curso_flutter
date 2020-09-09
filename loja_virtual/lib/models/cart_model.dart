import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:loja_virtual/datas/cart_product.dart';
import 'package:loja_virtual/models/user_model.dart';
import 'package:scoped_model/scoped_model.dart';

class CartModel extends Model {

  UserModel user;
  List<CartProduct> products = [];
  bool isLoading = false;
  String couponCode;
  int discountPercentage = 0;

  CartModel(this.user) {
    if (user.isLoggedIn()) _loadCartItems();
  }

  static CartModel of(BuildContext context) => ScopedModel.of<CartModel>(context);

  void addCartItem(CartProduct product){
    products.add(product);
    FirebaseFirestore.instance.collection('users').doc(user.firebaseUser.uid)
      .collection('cart').add(product.toMap()).then((doc) => product.cid = doc.id);
    notifyListeners();
  }

  void removeCartItem(CartProduct product) {
    FirebaseFirestore.instance.collection('users')
        .doc(user.firebaseUser.uid).collection('cart').doc(product.cid).delete();

    products.remove(product);
    notifyListeners();
  }

  void decProduct(CartProduct cartProduct) {
    cartProduct.quantity--;
    FirebaseFirestore.instance.collection('users').doc(user.firebaseUser.uid)
        .collection('cart').doc(cartProduct.cid).update(cartProduct.toMap());

    notifyListeners();
  }

  void incProduct(CartProduct cartProduct) {
    cartProduct.quantity++;
    
    FirebaseFirestore.instance.collection('users').doc(user.firebaseUser.uid)
      .collection('cart').doc(cartProduct.cid).update(cartProduct.toMap());

    notifyListeners();
  }

  void setCoupon(String coupomCode, int discountPercentage) {
    this.couponCode = coupomCode;
    this.discountPercentage = discountPercentage;
  }

  double getProductsPrice() {
    if (products != null && products.length > 0) {
      var total = products.map((p) => (p.productData != null ? p.productData.price : 0.0) * p.quantity).reduce((value, element) => value += element);
      return total;
    }
    return 0.0;
  }

  double getShipPrice() {
    return 9.99;
  }

  double getDiscount() {
    return getProductsPrice() * discountPercentage / 100;
  }

  void updatePrices() {
    notifyListeners();
  }

  Future<String> finishOrder() async {

    if(products.length == 0) return null;

    isLoading = true;
    notifyListeners();

    double productPrices = getProductsPrice();
    double shipPrice = getShipPrice();
    double discount = getDiscount();
    
    var docRef = await FirebaseFirestore.instance.collection('orders')
      .add({
      'clientId': user.firebaseUser.uid,
      'products': products.map((prod) => prod.toMap()).toList(),
      'shipPrice': shipPrice,
      'productsPrice': productPrices,
      'discount': discount,
      'totalPrice': productPrices + shipPrice - discount,
      'status': 1
    });
    
    await FirebaseFirestore.instance.collection('users').doc(user.firebaseUser.uid)
      .collection('orders').doc(docRef.id).set({
       'orderId': docRef.id
    });

    var query = await FirebaseFirestore.instance.collection('users').doc(user.firebaseUser.uid)
        .collection('cart').get();

    query.docs.forEach((productCart) async => await productCart.reference.delete());

    products.clear();
    discountPercentage = 0;
    couponCode = null;
    isLoading = false;
    notifyListeners();

    return docRef.id;
  }

  void _loadCartItems() async {
    var querySnapshot = await FirebaseFirestore.instance.collection('users').doc(user.firebaseUser.uid)
        .collection('cart').get();

    products = querySnapshot.docs.map((product) => CartProduct.fromDocument(product)).toList();
    notifyListeners();
  }

}
