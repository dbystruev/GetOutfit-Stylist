import 'dart:math';
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
  final Random random = Random();

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
          usernames.removeWhere((username) => username.isEmpty);

          final List<Text> children =
              usernames.map((username) => Text(username)).toList();

          return Center(
            child: Container(
              child: ListView(
                children: children,
              ),
              padding: EdgeInsets.symmetric(
                horizontal: 50,
                vertical: 10,
              ),
            ),
          );
        },
        stream: usersRef.snapshots(),
      ),
    );
  }

  createUser(String username) async {
    return await usersRef.add({
      'username': username,
      'postsCount': 0,
      'isAdmin': false,
    }).catchError((error) {
      print('ERROR creating user $username: $error');
      return null;
    });
  }

  deleteLastUser(String username) async {
    final QuerySnapshot snapshot =
        await usersRef.where('username', isEqualTo: username).getDocuments();
    return snapshot.documents.isEmpty
        ? null
        : deleteUser(snapshot.documents.last.documentID);
  }

  deleteUser(String id) async {
    final doc = await usersRef.document(id).get().catchError((error) {
      print('ERROR deleting user $id: $error');
      return null;
    });
    return doc.exists ? await doc.reference.delete() : null;
  }

  String randomUsername() {
    const String consonants = 'bcdfghjklmnpqrstvwxz';
    const String vowels = 'aeiouy';
    final int length = random.nextInt(6) + 3;
    String username = '';
    for (int count = 0; count < length; count++) {
      int index = random.nextInt(consonants.length * vowels.length);
      username += count.isEven
          ? consonants[index % consonants.length]
          : vowels[index % vowels.length];
    }
    return username;
  }

  updateFirstUser(String username,
      {String newUsername, bool isAdmin, int postsCount}) async {
    final QuerySnapshot snapshot =
        await usersRef.where('username', isEqualTo: username).getDocuments();
    return snapshot.documents.isEmpty
        ? null
        : updateUser(
            snapshot.documents.last.documentID,
            newUsername: newUsername,
            isAdmin: isAdmin,
            postsCount: postsCount,
          );
  }

  updateUser(String id,
      {String newUsername, bool isAdmin, int postsCount}) async {
    final doc = await usersRef.document(id).get().catchError((error) {
      print('ERROR updating user $id: $error');
      return null;
    });
    return doc.exists
        ? await doc.reference.updateData({
            'username': newUsername ?? doc['username'],
            'isAdmin': isAdmin ?? doc['isAdmin'],
            'postsCount': postsCount ?? doc['postsCount'],
          })
        : null;
  }

  @override
  void initState() {
    final String username = randomUsername();
    super.initState();
    createUser(username);
    if (random.nextBool()) {
      updateFirstUser(username, newUsername: randomUsername());
    } else {
      deleteLastUser(username);
    }
  }
}
