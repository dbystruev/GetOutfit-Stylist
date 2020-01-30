import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool isAuth = false;
  bool isButtonPressed = false;

  final buttonDownImage = 'assets/images/google_signin_dark_pressed.png';
  final buttonUpImage = 'assets/images/google_signin_dark_normal.png';

  void buttonDown(_) {
    setState(() {
      isButtonPressed = true;
      print('Button Down');
    });
  }

  void buttonUp([_]) {
    setState(() {
      isButtonPressed = false;
      print('Button Up');
    });
  }

  Widget buildAuthScreen() {
    return Text('Authorized');
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
}
