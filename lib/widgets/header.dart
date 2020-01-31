import 'package:flutter/material.dart';

AppBar header(BuildContext context,
    {bool isAppTitle = false, String titleText}) {
  return AppBar(
    backgroundColor: isAppTitle ? Colors.white : Theme.of(context).accentColor,
    centerTitle: true,
    title: isAppTitle
        ? Image.asset('assets/images/get_outfit_logo.png')
        : Text(titleText),
  );
}
