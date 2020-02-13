import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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
  bool isLoading = false;
  User user;

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
            onPressed: () => Navigator.pop(context),
          )
        ],
        backgroundColor: Colors.white,
        title: Text(
          'Edit Profile',
          style: TextStyle(
            color: Theme.of(context).primaryColor,
          ),
        ),
      ),
      body: isLoading
          ? circularProgress(context)
          : ListView(
              children: <Widget>[
                Container(
                  child: Column(
                    children: <Widget>[
                      Padding(
                        child: CircleAvatar(
                          backgroundImage:
                              CachedNetworkImageProvider(user.photoUrl),
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
                            ),
                            buildField(
                              'Bio',
                              controller: bioController,
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
                        onPressed: () => print('Update profile data'),
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
    );
  }

  Column buildField(String text, {TextEditingController controller}) {
    return Column(
      children: <Widget>[
        Padding(
          child: Text(
            text,
            style: TextStyle(color: Colors.grey),
          ),
          padding: EdgeInsets.only(top: 12),
        ),
        TextField(
          controller: controller,
          decoration: InputDecoration(hintText: 'Update $text'),
        ),
      ],
      crossAxisAlignment: CrossAxisAlignment.start,
    );
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
}
