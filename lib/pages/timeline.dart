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

  void getAllUsers() {
    usersRef.getDocuments().then((QuerySnapshot snapshot) {
      printQuery(snapshot, 'getAllUsers():');
    }).catchError((error) {
      print('ERROR getting users: $error');
    });
  }

  void getUserById(String id) {
    usersRef.document(id).get().then((DocumentSnapshot doc) {
      printDoc(doc, 'getUserById($id):');
    }).catchError((error) {
      print('ERROR: Can\'t get user with id $id: $error');
    });
  }

  void getUserByIdAsync(String id) async {
    final DocumentSnapshot doc = await usersRef.document(id).get();
    printDoc(doc, 'getUserByIdAsync($id):');
  }

  void getUsersByAdminStatus(bool isAdmin) async {
    final QuerySnapshot snapshot =
        await usersRef.where("isAdmin", isEqualTo: isAdmin).getDocuments();
    printQuery(snapshot, 'getUsersByAdminStatus($isAdmin):');
  }

  void getUsersLimit(int length) async {
    final QuerySnapshot snapshot = await usersRef.limit(length).getDocuments();
    printQuery(snapshot, 'getUsersLimit($length)');
  }

  void getUsersOrderedBy(String field, {bool descending}) async {
    final QuerySnapshot snapshot =
        await usersRef.orderBy(field, descending: descending).getDocuments();
    printQuery(snapshot, 'getUsersOrderedBy($field, descending: $descending)');
  }

  void getUsersStartAfter(int index) async {
    final QuerySnapshot prevSnapshot =
        await usersRef.orderBy('username').limit(index).getDocuments();
    printQuery(prevSnapshot, 'getUsersStartAfter($index) — prevSnapshot');

    final DocumentSnapshot lastDoc = prevSnapshot.documents.last;
    printDoc(lastDoc, 'getUsersStartAfter($index) — lastDoc');

    final QuerySnapshot snapshot = await usersRef
        .startAfterDocument(prevSnapshot.documents.last)
        .orderBy('username')
        .getDocuments();
    printQuery(snapshot, 'getUsersStartAfter($index)');
  }

  void getUsersWithPostsGreaterThan(postsCount) async {
    final QuerySnapshot snapshot = await usersRef
        .where('postsCount', isGreaterThan: postsCount)
        .getDocuments();
    printQuery(snapshot, 'getUsersWithPostsGreaterThan($postsCount)');
  }

  void getUsersWithPostsLessThan(postsCount, {String username}) async {
    final QuerySnapshot snapshot = username == null
        ? await usersRef
            .where('postsCount', isLessThan: postsCount)
            .getDocuments()
        : await usersRef
            .where('postsCount', isLessThan: postsCount)
            .where('username', isEqualTo: username)
            .getDocuments();
    printQuery(snapshot,
        'getUsersWithPostsLessThan($postsCount${username == null ? '' : ', $username'})');
  }

  void printDoc(DocumentSnapshot doc, [String func]) {
    if (func != null) print(func);
    print('\t${doc.documentID}, exists: ${doc.exists}, ${doc.data}');
  }

  void printQuery(QuerySnapshot snapshot, [String func]) {
    if (func != null) print(func);
    snapshot.documents.forEach((DocumentSnapshot doc) {
      printDoc(doc);
    });
  }

  @override
  void initState() {
    super.initState();
    print('');
    print(
      DateTime.now(),
    );
    getAllUsers();
    getUserById('DAT6JFWRAtZyWcDqwXVZ');
    getUserById('fake');
    getUserByIdAsync('HfVGZ3bsrKxuzXrSbI1h');
    getUsersByAdminStatus(true);
    getUsersByAdminStatus(false);
    getUsersOrderedBy('postsCount', descending: true);
    getUsersOrderedBy('postsCount', descending: false);
    // getUsersLimit(0); // Unhandled Exception: PlatformException(invalid_query, FIRInvalidArgumentException, Invalid Query. Query limit (0) is invalid. Limit must be positive.)
    getUsersLimit(1);
    getUsersLimit(2);
    getUsersStartAfter(1);
    getUsersWithPostsGreaterThan(2);
    getUsersWithPostsLessThan(10);
    getUsersWithPostsLessThan(10, username: 'admin');
  }
}
