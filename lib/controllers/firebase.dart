import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';

final CollectionReference looksRef = Firestore.instance.collection('looks');
final CollectionReference usersRef = Firestore.instance.collection('users');
final GoogleSignIn googleSignIn = GoogleSignIn();
final StorageReference storageRef = FirebaseStorage.instance.ref();

void login() {
  googleSignIn.signIn();
}

void logout() {
  googleSignIn.signOut();
}
