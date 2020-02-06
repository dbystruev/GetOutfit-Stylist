import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';

final GoogleSignIn googleSignIn = GoogleSignIn();
final CollectionReference usersRef = Firestore.instance.collection('users');

void login() {
  googleSignIn.signIn();
}

void logout() {
  googleSignIn.signOut();
}
