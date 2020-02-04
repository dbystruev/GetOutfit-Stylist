import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:getoutfit_stylist/widgets/header.dart';
import 'package:getoutfit_stylist/widgets/progress.dart';

final usersRef = Firestore.instance.collection('users');

class Timeline extends StatefulWidget {
  @override
  _TimelineState createState() => _TimelineState();
}

class _TimelineState extends State<Timeline> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: header(context, isAppTitle: true),
      body: StreamBuilder<QuerySnapshot>(
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (!snapshot.hasData) return circularProgress(context);

          // Get array of document snapshots
          final List<DocumentSnapshot> docs = snapshot.data.documents;

          // Create an array of usernames
          List<String> usernames = docs
              .map(
                (doc) => (doc['username'] ?? '').toString(),
              )
              .toList();

          // Remove entries with empty username
          usernames
              .removeWhere((username) => username.isEmpty);

          final List<Text> children =
              usernames.map((username) => Text(username)).toList();

          return Center(
            child: Container(
              child: ListView(
                children: children,
              ),
            ),
          );
        },
        stream: usersRef.snapshots(),
      ),
    );
  }
}
