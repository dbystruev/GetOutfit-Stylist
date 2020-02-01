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
      body: circularProgress(context),
    );
  }

  void getUserById(String id) {
    usersRef.document(id).get().then((DocumentSnapshot doc) {
      printDocumentSnapshot(doc);
    }).catchError((error) {
      print('ERROR: Can\'t get user with id $id: $error');
    });
  }

  void getUserByIdAsync(String id) async {
    final DocumentSnapshot doc = await usersRef.document(id).get();
    printDocumentSnapshot(doc);
  }

  void getUsers() {
    usersRef.getDocuments().then((QuerySnapshot snapshot) {
      snapshot.documents.forEach((DocumentSnapshot doc) {
        printDocumentSnapshot(doc);
      });
    }).catchError((error) {
      print('ERROR getting users: $error');
    });
  }

  void printDocumentSnapshot(DocumentSnapshot doc) {
    print('ID: ${doc.documentID}, exists: ${doc.exists}, ${doc.data}');
  }

  @override
  void initState() {
    super.initState();
    getUsers();
    getUserById('DAT6JFWRAtZyWcDqwXVZ');
    getUserByIdAsync('HfVGZ3bsrKxuzXrSbI1h');
    getUserById('FakeID');
  }
}
