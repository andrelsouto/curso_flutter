import 'package:flutter/material.dart';

class ShipCard extends StatefulWidget {
  @override
  _ShipCardState createState() => _ShipCardState();
}

class _ShipCardState extends State<ShipCard> {
  var isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: ExpansionTile(
        title: Text('Cálcular Frete',
            textAlign: TextAlign.start,
            style: TextStyle(fontWeight: FontWeight.w500, color: Colors.grey[700])),
        leading: Icon(Icons.location_on),
        onExpansionChanged: (value) {
          setState(() {
            isExpanded = value;
          });
        },
        trailing: Icon(isExpanded ? Icons.arrow_drop_up : Icons.arrow_drop_down),
        children: [
          Padding(
            padding: EdgeInsets.all(8),
            child: TextFormField(
              decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Digite seu CEP'),
              onFieldSubmitted: (text) { },
            ),
          )
        ],
      ),
    );
  }

}
