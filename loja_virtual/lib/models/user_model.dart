import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

class UserModel extends Model {

  final _auth = FirebaseAuth.instance;
  User firebaseUser;
  Map<String, dynamic> userData = Map();
  bool isLoading = false;

  static UserModel of(BuildContext context) => ScopedModel.of<UserModel>(context);

  @override
  void addListener(VoidCallback listener) {
    super.addListener(listener);
    _loadCurrentUser();
  }

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

  void signIn(
      { @required String email,
        @required String pass,
        @required VoidCallback onSuccess,
        @required VoidCallback onFail}) async {
    isLoading = true;
    notifyListeners();

    final auth = await _auth.signInWithEmailAndPassword(email: email, password: pass)
      .catchError((e){
        onFail();
        isLoading = false;
        notifyListeners();
        return null;
    });
    if (auth != null && auth.user != null) {
      firebaseUser = auth.user;
      onSuccess();
      await _loadCurrentUser();
    }

    isLoading = false;
    notifyListeners();
  }

  void recoverPass(String email) {
    _auth.sendPasswordResetEmail(email: email);
  }

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

  Future<void> _loadCurrentUser() async {
    if (firebaseUser == null)
      firebaseUser = _auth.currentUser;
    if (firebaseUser != null && userData['name'] == null) {
      final docUser = await FirebaseFirestore.instance.collection('users').doc(firebaseUser.uid).get();
      userData = docUser.data();
    }

    notifyListeners();
  }

}
