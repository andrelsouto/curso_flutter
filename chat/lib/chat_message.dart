import 'package:flutter/material.dart';

class ChatMessage extends StatelessWidget {

  final Map<String, dynamic> data;
  final bool mine;

  ChatMessage(this.data, this.mine);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
      child: Row(
        children: [
          !mine ?
          Padding(
            padding: EdgeInsets.only(right: 14),
            child:
            CircleAvatar(
              backgroundImage: NetworkImage(data['senderPhotoUrl']),
            ),
          ) : Container(),
          Expanded(
            child: Column(
              crossAxisAlignment: mine ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: [
                data['imgUrl'] != null ?
                    Image.network(data['imgUrl'], width: 210,) :
                    Text(data['text'], style: TextStyle(fontSize: 16),
                    textAlign: mine ? TextAlign.end : TextAlign.start,),
                Text(data['senderName'],
                 style: TextStyle(fontSize: 9, fontWeight: FontWeight.w500),)
              ],
            ),
          ),
          mine ?
          Padding(
            padding: EdgeInsets.only(left: 14),
            child:
            CircleAvatar(
              backgroundImage: NetworkImage(data['senderPhotoUrl']),
            ),
          ) : Container()
        ],
      ),
    );
  }
}
