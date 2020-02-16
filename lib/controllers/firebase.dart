import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';

final CollectionReference commentsRef =
    Firestore.instance.collection('comments');
final GoogleSignIn googleSignIn = GoogleSignIn();
final CollectionReference looksRef = Firestore.instance.collection('looks');
final StorageReference storageRef = FirebaseStorage.instance.ref();
final CollectionReference usersRef = Firestore.instance.collection('users');

void login() {
  googleSignIn.signIn();
}

void logout() {
  googleSignIn.signOut();
}
