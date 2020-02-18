import 'package:flutter/material.dart';

AppBar header(BuildContext context,
    {bool isAppTitle = false,
    Widget leading,
    String titleText,
    bool removeBackButton = false}) {
  return AppBar(
    automaticallyImplyLeading: !removeBackButton,
    backgroundColor: isAppTitle ? Colors.white : Theme.of(context).accentColor,
    centerTitle: true,
    leading: leading,
    title: isAppTitle
        ? Image.asset(
            'assets/images/get_outfit_logo.png',
            height: 120,
          )
        : Text(titleText),
  );
}
