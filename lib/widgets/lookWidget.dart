import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:getoutfit_stylist/models/look.dart';

class LookWidget extends StatefulWidget {
  final Look look;

  LookWidget(this.look);

  factory LookWidget.fromDocument(DocumentSnapshot doc) {
    return LookWidget(
      Look.fromDocument(doc),
    );
  }

  @override
  _LookWidgetState createState() => _LookWidgetState(look);
}

class _LookWidgetState extends State<LookWidget> {
  Look look;

  _LookWidgetState(this.look);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text('Look'),
    );
  }
}
