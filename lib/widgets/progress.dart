import 'package:flutter/material.dart';

Container circularProgress(BuildContext context) {
  return Container(
    alignment: Alignment.center,
    child: CircularProgressIndicator(
      valueColor: AlwaysStoppedAnimation(
        Theme.of(context).accentColor,
      ),
    ),
    padding: EdgeInsets.only(top: 10),
  );
}

Container linearProgress(BuildContext context) {
  return Container(
    child: LinearProgressIndicator(
      valueColor: AlwaysStoppedAnimation(
        Theme.of(context).accentColor,
      ),
    ),
  );
}
