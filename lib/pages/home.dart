import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:getoutfit_stylist/controllers/firebase.dart';
import 'package:getoutfit_stylist/models/user.dart';
import 'package:getoutfit_stylist/pages/activity_feed.dart';
import 'package:getoutfit_stylist/pages/create_account.dart';
import 'package:getoutfit_stylist/pages/profile.dart';
import 'package:getoutfit_stylist/pages/search.dart';
import 'package:getoutfit_stylist/pages/timeline.dart';
import 'package:getoutfit_stylist/pages/upload.dart';
import 'package:google_sign_in/google_sign_in.dart';

final DateTime timestamp = DateTime.now();
User currentUser;

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
          Upload(currentUser: currentUser),
          Search(),
          Profile(profileId: currentUser?.id),
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
              Icons.file_upload, // Upload
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

  void createUserInFirestore() async {
    // 1) Check if user exists in Firestore's users collection
    final GoogleSignInAccount user = googleSignIn.currentUser;

    if (user == null) {
      print('ERROR: Current user is null in createUserInFirestore()');
      return;
    }

    DocumentSnapshot doc =
        await usersRef.document(user.id).get().catchError((error) {
      print('ERROR: Can\'t get user\'s document in createUserInFirestore()');
      return;
    });

    if (!doc.exists) {
      // 2) If the user doesn't exist, show the create account page
      final String username = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CreateAccount(),
        ),
      );

      // 3) Get username from create account page and create new user in collection
      usersRef.document(user.id).setData({
        'bio': '',
        'displayName': user.displayName,
        'displayNameLowercase': user.displayName.toLowerCase(),
        'email': user.email,
        'id': user.id,
        'photoUrl': user.photoUrl,
        'timestamp': timestamp,
        'username': username,
      }).catchError((error) {
        print('ERROR: Can\'t add user to Firestore in createUserInFirestore()');
        return;
      });

      doc = await usersRef.document(user.id).get().catchError((error) {
        print(
            'ERROR: Can\'t get user back from Firestore in createUserInFirestore()');
        return;
      });
    }

    currentUser = User.fromDocument(doc);
    print(
        'Current User: ${currentUser.username} (${currentUser.displayName}) ${currentUser.email}');
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  void handleSignIn(GoogleSignInAccount account) {
    if (account != null) {
      createUserInFirestore();
      setState(() => isAuth = true);
    } else {
      setState(() => isAuth = false);
    }
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
    pageController.animateToPage(
      pageIndex,
      curve: Curves.easeInOut,
      duration: Duration(milliseconds: 300),
    );
  }
}
