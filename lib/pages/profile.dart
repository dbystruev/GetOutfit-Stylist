import 'package:flutter/material.dart';
import 'package:getoutfit_stylist/pages/home.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Text('Profile'),
        RaisedButton(
          child: Text('LOG OUT'),
          onPressed: logout,
        ),
      ],
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
    );
  }
}
