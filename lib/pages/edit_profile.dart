import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:getoutfit_stylist/controllers/firebase.dart';
import 'package:getoutfit_stylist/models/user.dart';
import 'package:getoutfit_stylist/widgets/progress.dart';

class EditProfile extends StatefulWidget {
  final String currentUserId;

  EditProfile({this.currentUserId});

  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final TextEditingController bioController = TextEditingController();
  final TextEditingController displayNameController = TextEditingController();
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  bool isLoading = false;
  User user;

  String bioValidator(String text) {
    return 100 < text.trim().length ? 'Bio is too long' : null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.done,
              color: Theme.of(context).accentColor,
              size: 30,
            ),
            onPressed: updateProfileData,
          ),
        ],
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(
            Icons.close,
            color: Colors.grey,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Edit Profile',
          style: TextStyle(
            color: Theme.of(context).primaryColor,
          ),
        ),
      ),
      body: isLoading
          ? circularProgress(context)
          : SafeArea(
              child: ListView(
                children: <Widget>[
                  Container(
                    child: Column(
                      children: <Widget>[
                        Padding(
                          child: CircleAvatar(
                            backgroundImage: kIsWeb
                                ? NetworkImage(
                                    user.photoUrl,
                                    scale: 1,
                                  )
                                : CachedNetworkImageProvider(user.photoUrl),
                            radius: 50,
                          ),
                          padding: EdgeInsets.only(
                            bottom: 8,
                            top: 16,
                          ),
                        ),
                        Padding(
                          child: Column(
                            children: <Widget>[
                              buildField(
                                'Display Name',
                                controller: displayNameController,
                                validator: displayNameValidator,
                              ),
                              buildField(
                                'Bio',
                                controller: bioController,
                                validator: bioValidator,
                              )
                            ],
                          ),
                          padding: EdgeInsets.all(16),
                        ),
                        RaisedButton(
                          color: Theme.of(context).primaryColor,
                          child: Text(
                            'Update Profile',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          onPressed: updateProfileData,
                        ),
                        Padding(
                          child: FlatButton.icon(
                            onPressed: () {
                              Navigator.pop(context);
                              logout();
                            },
                            icon: Icon(
                              Icons.cancel,
                              color: Colors.red,
                            ),
                            label: Text(
                              'Log Out',
                              style: TextStyle(
                                color: Colors.red,
                                fontSize: 20,
                              ),
                            ),
                          ),
                          padding: EdgeInsets.all(16),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
      key: scaffoldKey,
    );
  }

  Column buildField(
    String text, {
    TextEditingController controller,
    String Function(String) validator,
  }) {
    return Column(
      children: <Widget>[
        Padding(
          child: Text(
            text,
            style: TextStyle(color: Colors.grey),
          ),
          padding: EdgeInsets.only(top: 12),
        ),
        TextFormField(
          autovalidate: true,
          controller: controller,
          decoration: InputDecoration(hintText: 'Update $text'),
          validator: validator,
        ),
      ],
      crossAxisAlignment: CrossAxisAlignment.start,
    );
  }

  String displayNameValidator(String text) {
    return text.trim().length < 3 ? 'Display name is too short' : null;
  }

  void getUser() async {
    setState(() => isLoading = true);
    final DocumentSnapshot doc =
        await usersRef.document(widget.currentUserId).get();
    if (doc == null) {
      print('ERROR: user id ${widget.currentUserId} not found');
      setState(() => isLoading = false);
      return;
    }
    user = User.fromDocument(doc);
    bioController.text = user.bio;
    displayNameController.text = user.displayName;
    setState(() => isLoading = false);
  }

  @override
  void initState() {
    super.initState();
    getUser();
  }

  void updateProfileData() async {
    final bool bioValid = bioValidator(bioController.text) == null;
    final bool displayNameValid =
        displayNameValidator(displayNameController.text) == null;
    Color snackBarBackgroundColor = Theme.of(context).accentColor;
    Color snackBarTextColor = Colors.white;
    String snackBarText = 'Profile updated';
    if (bioValid && displayNameValid) {
      usersRef.document(widget.currentUserId).updateData({
        'displayName': displayNameController.text.trim(),
        'bio': bioController.text.trim(),
      }).catchError((error) {
        snackBarBackgroundColor = Colors.red;
        snackBarTextColor = Colors.yellow;
        snackBarText = 'ERROR updating user profile';
        print('$snackBarText $error');
      });
      final SnackBar snackBar = SnackBar(
        backgroundColor: snackBarBackgroundColor,
        content: Text(
          snackBarText,
          style: TextStyle(color: snackBarTextColor),
        ),
        duration: Duration(milliseconds: 1500),
      );
      final ScaffoldFeatureController<SnackBar, SnackBarClosedReason>
          controller = scaffoldKey.currentState.showSnackBar(snackBar);
      await controller.closed;
      Navigator.pop(context);
    }
  }
}
