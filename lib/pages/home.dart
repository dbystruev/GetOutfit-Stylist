import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

final googleSignIn = GoogleSignIn();

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool isAuth = false;
  bool isButtonPressed = false;

  final buttonDownImage = 'assets/images/google_signin_dark_pressed.png';
  final buttonUpImage = 'assets/images/google_signin_dark_normal.png';

  Widget buildAuthScreen() {
    return RaisedButton(
      child: Text('Logout'),
      onPressed: logout,
    );
  }

  Scaffold buildUnAuthScreen() {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        child: Padding(
          child: Column(
            children: <Widget>[
              Expanded(
                child: Container(),
                flex: 2,
              ),
              Expanded(
                child: GestureDetector(
                  child: Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        fit: BoxFit.scaleDown,
                        image: AssetImage(
                            isButtonPressed ? buttonDownImage : buttonUpImage),
                      ),
                    ),
                  ),
                  onTapCancel: buttonUp,
                  onTapDown: buttonDown,
                  onTapUp: buttonUp,
                ),
              ),
            ],
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
          ),
          padding: const EdgeInsets.all(20),
        ),
        decoration: BoxDecoration(
          image: DecorationImage(
            fit: BoxFit.cover,
            image: AssetImage('assets/images/background.jpg'),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return isAuth ? buildAuthScreen() : buildUnAuthScreen();
  }

  void buttonDown(_) {
    setState(() {
      isButtonPressed = true;
    });
  }

  void buttonUp([tapUpDetails]) {
    setState(() {
      isButtonPressed = false;
      if (tapUpDetails != null) login();
    });
  }

  void handleSignIn(GoogleSignInAccount account) {
    setState(() {
      isAuth = account != null;
    });
    if (isAuth) print('User Signed In: $account');
  }

  @override
  void initState() {
    super.initState();

    // Detects when user signed in or out
    googleSignIn.onCurrentUserChanged.listen(
      (account) {
        handleSignIn(account);
      },
      onError: (error) {
        print('ERROR Signing In: $error');
      },
    );

    // Reauthenticate user when app is opened
    googleSignIn.signInSilently(suppressErrors: false).then((account) {
      handleSignIn(account);
    }).catchError((error) {
      print('ERROR Signing In Silently: $error');
    });
  }

  void login() {
    googleSignIn.signIn();
  }

  void logout() {
    googleSignIn.signOut();
  }
}
