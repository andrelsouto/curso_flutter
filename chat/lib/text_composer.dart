import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class TextComposer extends StatefulWidget {

  final Function({ String text, File image }) send;

  @override
  _TextComposerState createState() => _TextComposerState();

  TextComposer(this.send);
}

class _TextComposerState extends State<TextComposer> {

  var textController = TextEditingController();
  final _picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 6),
      child: Row(
        children: [
          IconButton(
            icon: Icon(Icons.photo_camera),
          onPressed: () async {
              final imgFile = await _picker.getImage(source: ImageSource.camera);
              var file = File(imgFile.path);
              if (file == null) return;

              widget.send(image: file);

          },),
          Expanded(
           child: TextField(
             decoration: InputDecoration.collapsed(hintText: 'Enviar uma mensagem'),
             controller: textController,
             onChanged: (text){
               setState(() { });
             },
             onSubmitted: (text) {
               widget.send(text: text);
               _resetController();
             },
           ),
          ),
          IconButton(
            icon: Icon(Icons.send, ),
            onPressed: textController.text == null || textController.text.isEmpty ?
            null : () {
              widget.send(text: textController.text);
              _resetController();
            },
            disabledColor: Colors.grey,
          )
        ],
      ),
    );
  }

  void _resetController() {
    return setState(() {
              textController.clear();
            });
  }
}
