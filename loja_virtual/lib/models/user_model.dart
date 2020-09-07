import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

class UserModel extends Model {

  final _auth = FirebaseAuth.instance;
  User firebaseUser;
  Map<String, dynamic> userData = Map();
  bool isLoading = false;

  void signUp(
      { @required Map<String, dynamic> userData,
        @required String pass,
        @required VoidCallback onSuccess,
        @required VoidCallback onFail }) {
    isLoading = true;
    notifyListeners();
    _auth.createUserWithEmailAndPassword(email: userData['email'], password: pass)
        .then((user) async {
          firebaseUser = user.user;
          await _saveUserData(userData);
          onSuccess();
          isLoading = false;
          notifyListeners();
        })
        .catchError((e) {
          onFail();
          isLoading = false;
          notifyListeners();
        });
  }

  void signIn() async {
    isLoading = true;
    notifyListeners();

    await Future.delayed(Duration(seconds: 4));
    isLoading = false;
    notifyListeners();
  }

  void recoverPass() {}

  Future<void> _saveUserData(Map<String, dynamic> userData) async{
    this.userData = userData;
    await FirebaseFirestore.instance.collection('users').doc(firebaseUser.uid).set(userData);
  }

  void signOut() async {
    await _auth.signOut();
    userData = Map();
    firebaseUser = null;
    notifyListeners();
  }

  bool isLoggedIn() {
    return firebaseUser != null;
  }

}