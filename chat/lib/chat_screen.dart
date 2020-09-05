import 'dart:io';

import 'package:chat/chat_message.dart';
import 'package:chat/text_composer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {

  final googleSingin = GoogleSignIn();
  User currentUser;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  var _isLoading = false;

  @override
  void initState() {
    super.initState();

    FirebaseAuth.instance.authStateChanges().listen((user) {
      setState(() {
        currentUser = user;
      });
    });
  }

  Future<User> _getUser() async {
    if (currentUser != null) return currentUser;

    try {
      final googleSignInAccount = await googleSingin.signIn();
      final googleSinginAuthentication = await googleSignInAccount.authentication;

      final authCredenial = GoogleAuthProvider.credential(
        accessToken: googleSinginAuthentication.accessToken,
        idToken: googleSinginAuthentication.idToken
      );

      final authResult = await FirebaseAuth.instance.signInWithCredential(authCredenial);

      return authResult.user;

    } catch (e) {
      return null;
    }
  }

  void _sendMessage({ String text, File image }) async {

    final user = await _getUser();
    if (user == null) {
      scaffoldKey.currentState.showSnackBar(
        SnackBar(
          content: Text('Não foi possível fazer o login. Tente novamente!'),
          backgroundColor: Colors.red,
        )
      );
    }

    Map<String, dynamic> data = { 'uid': user.uid, 'senderName': user.displayName, 'senderPhotoUrl': user.photoURL, 'time': DateTime.now() };

    if (image != null) {
      final task = FirebaseStorage.instance.ref().child(
        '${user.uid}${DateTime.now().millisecondsSinceEpoch.toString()}'
      ).putFile(image);
      setState(() {
        _isLoading = true;
      });
      final taskSnapshot = await task.onComplete;
      final String urlDownload = await taskSnapshot.ref.getDownloadURL();
      data['imgUrl'] = urlDownload;

      setState(() {
        _isLoading = false;
      });
    }

    if (text != null)
      data['text'] = text;

    FirebaseFirestore.instance.collection('messages')
        .add(data);
  }

  @override
  Widget build(BuildContext context) {
    Firebase.initializeApp().then((value) {

    });
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Text(currentUser != null ? 'Olá, ${currentUser.displayName}' : 'ChatApp'),
        elevation: 0,
        actions: [
          currentUser != null ?
              IconButton(
                icon: Icon(Icons.exit_to_app),
                onPressed: () {
                  FirebaseAuth.instance.signOut();
                  googleSingin.signOut();
                  scaffoldKey.currentState.showSnackBar(
                      SnackBar(
                        content: Text('Você saiu com sucesso!', textAlign: TextAlign.center,),
                      )
                  );
                },
              ) : Container()
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder(
              stream: FirebaseFirestore.instance.collection('messages').orderBy('time').snapshots(),
              builder: (context, snapshot) {
                switch(snapshot.connectionState) {
                  case ConnectionState.none:
                  case ConnectionState.waiting:
                    return  Center(
                      child: CircularProgressIndicator(),
                    );
                  default: {
                    var documents = snapshot.data.docs.reversed.toList();

                    var listView = ListView.builder(
                        itemCount: documents.length,
                        scrollDirection: Axis.vertical,
                        reverse: true,
                        itemBuilder: (context, index) {
                          return ChatMessage(documents[index].data(), documents[index].data()['uid'] == currentUser?.uid);
                        });
                    return listView;
                  }
                }
              },
            ),
          ),
          _isLoading ? LinearProgressIndicator() : Container(),
          TextComposer(_sendMessage)
        ],
      ),
    );
  }
}
