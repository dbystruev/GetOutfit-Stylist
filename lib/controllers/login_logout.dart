import 'package:google_sign_in/google_sign_in.dart';

final googleSignIn = GoogleSignIn();

void login() {
  googleSignIn.signIn();
}

void logout() {
  googleSignIn.signOut();
}