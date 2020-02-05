import 'package:flutter/material.dart';

AppBar header(BuildContext context,
    {bool isAppTitle = false,
    String titleText,
    bool removeBackButton = false}) {
  final Orientation orientation = MediaQuery.of(context).orientation;

  return AppBar(
    automaticallyImplyLeading: !removeBackButton,
    backgroundColor: isAppTitle ? Colors.white : Theme.of(context).accentColor,
    centerTitle: true,
    title: isAppTitle
        ? Image.asset(
            'assets/images/get_outfit_logo.png',
            height: orientation == Orientation.portrait ? null : 100,
          )
        : Text(titleText),
  );
}
