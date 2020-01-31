import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:getoutfit_stylist/controllers/login_logout.dart';
import 'package:getoutfit_stylist/pages/activity_feed.dart';
import 'package:getoutfit_stylist/pages/profile.dart';
import 'package:getoutfit_stylist/pages/search.dart';
import 'package:getoutfit_stylist/pages/timeline.dart';
import 'package:getoutfit_stylist/pages/upload.dart';
import 'package:google_sign_in/google_sign_in.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool isAuth = false;
  bool isButtonPressed = false;
  PageController pageController;
  int pageIndex = 0;

  final buttonDownImage = 'assets/images/google_signin_dark_pressed.png';
  final buttonUpImage = 'assets/images/google_signin_dark_normal.png';

  Widget buildAuthScreen() {
    return Scaffold(
      body: PageView(
        children: <Widget>[
          Timeline(),
          ActivityFeed(),
          Upload(),
          Search(),
          Profile(),
        ],
        controller: pageController,
        onPageChanged: onPageChanged,
        physics: NeverScrollableScrollPhysics(),
      ),
      bottomNavigationBar: CupertinoTabBar(
        activeColor: Theme.of(context).primaryColor,
        currentIndex: pageIndex,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.whatshot), // Timeline
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications_active), // Activity Feed
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.photo_camera, // Upload
              size: 35,
            ),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search), // Search
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle), // Profile
          ),
        ],
        onTap: onTap,
      ),
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

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
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
    pageController = PageController();

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

  void onPageChanged(int pageIndex) {
    setState(() {
      this.pageIndex = pageIndex;
    });
  }

  void onTap(int pageIndex) {
    pageController.jumpToPage(pageIndex);
  }
}
