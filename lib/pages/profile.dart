import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:getoutfit_stylist/controllers/firebase.dart';
import 'package:getoutfit_stylist/models/user.dart';
import 'package:getoutfit_stylist/pages/edit_profile.dart';
import 'package:getoutfit_stylist/pages/home.dart';
import 'package:getoutfit_stylist/widgets/header.dart';
import 'package:getoutfit_stylist/widgets/lookWidget.dart';
import 'package:getoutfit_stylist/widgets/progress.dart';

class Profile extends StatefulWidget {
  final String profileId;

  Profile({this.profileId});

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final String currentUserId = currentUser?.id;
  bool isLoading = false;
  int lookCount = 0;
  List<LookWidget> looks = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: header(context, titleText: "Profile"),
      body: SafeArea(
        child: ListView(
          children: <Widget>[
            buildProfileHeader(),
            Divider(height: 0),
            buildProfileLooks(),
          ],
        ),
      ),
    );
  }

  Container buildButton({String text, Function onPressed}) {
    return Container(
      child: FlatButton(
        child: Container(
          alignment: Alignment.center,
          child: Text(
            text,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          decoration: BoxDecoration(
            border: Border.all(
              color: Theme.of(context).primaryColor,
            ),
            borderRadius: BorderRadius.circular(5),
            color: Theme.of(context).primaryColor,
          ),
          height: 27,
          width: 250,
        ),
        onPressed: onPressed,
      ),
      padding: EdgeInsets.only(top: 2),
    );
  }

  Column buildCountColumn(String label, int count) {
    return Column(
      children: <Widget>[
        Text(
          count.toString(),
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        Container(
          child: Text(
            label,
            style: TextStyle(
              color: Colors.grey,
              fontSize: 15,
              fontWeight: FontWeight.w400,
            ),
          ),
          margin: EdgeInsets.only(top: 4),
        ),
      ],
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
    );
  }

  Widget buildProfileButton() {
    // if own profile — show edit profile button
    final bool isProfileOwner = currentUserId == widget.profileId;
    if (isProfileOwner)
      return buildButton(
        onPressed: editProfile,
        text: "Edit Profile",
      );
    return Text('Profile Button');
  }

  FutureBuilder buildProfileHeader() {
    return FutureBuilder(
      builder: (context, snapshot) {
        if (!snapshot.hasData) return circularProgress(context);
        final user = User.fromDocument(snapshot.data);
        return Padding(
          child: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  CircleAvatar(
                    backgroundColor: Colors.grey,
                    backgroundImage: CachedNetworkImageProvider(user.photoUrl),
                    radius: 40,
                  ),
                  Expanded(
                    child: Column(
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            buildCountColumn('looks', lookCount),
                            buildCountColumn('followers', 0),
                            buildCountColumn('following', 0),
                          ],
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          mainAxisSize: MainAxisSize.max,
                        ),
                        Row(
                          children: <Widget>[
                            buildProfileButton(),
                          ],
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        ),
                      ],
                    ),
                    flex: 1,
                  ),
                ],
              ),
              Container(
                alignment: Alignment.centerLeft,
                child: Text(
                  user.username,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                padding: EdgeInsets.only(top: 12),
              ),
              Container(
                alignment: Alignment.centerLeft,
                child: Text(
                  user.displayName,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                padding: EdgeInsets.only(top: 4),
              ),
              Container(
                alignment: Alignment.centerLeft,
                child: Text(user.bio),
                padding: EdgeInsets.only(top: 2),
              ),
            ],
          ),
          padding: EdgeInsets.all(16),
        );
      },
      future: usersRef.document(widget.profileId).get(),
    );
  }

  Widget buildProfileLooks() {
    if (isLoading) return circularProgress(context);
    return Column(children: looks);
  }

  @override
  void initState() {
    super.initState();
    getProfileLooks();
  }

  void editProfile() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditProfile(currentUserId: currentUserId),
      ),
    );
  }

  void getProfileLooks() async {
    setState(() => isLoading = true);
    final QuerySnapshot snapshot = await looksRef
        .document(widget.profileId)
        .collection('userLooks')
        .orderBy('timestamp', descending: true)
        .getDocuments();
    setState(() {
      isLoading = false;
      lookCount = snapshot.documents.length;
      looks = snapshot.documents
          .map(
            (doc) => LookWidget.fromDocument(doc),
          )
          .toList();
    });
  }
}
