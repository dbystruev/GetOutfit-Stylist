import 'package:flutter/material.dart';
import 'package:getoutfit_stylist/controllers/firebase.dart';
import 'package:getoutfit_stylist/widgets/progress.dart';

enum ActivityType {
  comment,
  follow,
  like,
}

class ActivityFeed extends StatefulWidget {
  @override
  _ActivityFeedState createState() => _ActivityFeedState();
}

class _ActivityFeedState extends State<ActivityFeed> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        linearProgress(context),
        RaisedButton(
          child: Text('LOG OUT'),
          onPressed: logout,
        ),
        SizedBox(),
      ],
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
    );
  }
}

class ActivityFeedItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Text('Activity Feed Item');
  }
}
