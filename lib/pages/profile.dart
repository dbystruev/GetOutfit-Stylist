import 'package:flutter/material.dart';
import 'package:getoutfit_stylist/controllers/login_logout.dart';
import 'package:getoutfit_stylist/widgets/header.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: header(context, titleText: "Profile"),
      body: Center(
        child: RaisedButton(
          child: Text('LOG OUT'),
          onPressed: logout,
        ),
      ),
    );
  }
}
