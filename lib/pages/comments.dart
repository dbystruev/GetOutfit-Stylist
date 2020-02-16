import 'package:flutter/material.dart';
import 'package:getoutfit_stylist/widgets/header.dart';

class Comments extends StatefulWidget {
  final String lookId;
  final String lookOwnerId;
  final String lookMediaUrl;

  Comments({
    this.lookId,
    this.lookOwnerId,
    this.lookMediaUrl,
  });

  @override
  _CommentsState createState() => _CommentsState(
        lookId: lookId,
        lookOwnerId: lookOwnerId,
        lookMediaUrl: lookMediaUrl,
      );
}

class _CommentsState extends State<Comments> {
  final TextEditingController commentController = TextEditingController();
  final String lookId;
  final String lookOwnerId;
  final String lookMediaUrl;

  _CommentsState({
    this.lookId,
    this.lookOwnerId,
    this.lookMediaUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        appBar: header(context, titleText: 'Comments'),
        body: SafeArea(
          child: Column(
            children: <Widget>[
              Expanded(
                child: buildComments(),
              ),
              Divider(),
              ListTile(
                title: TextFormField(
                  controller: commentController,
                  decoration: InputDecoration(labelText: 'Write a comment...'),
                ),
                trailing: OutlineButton(
                  borderSide: BorderSide.none,
                  child: Icon(
                    Icons.send,
                    color: Theme.of(context).accentColor,
                    size: 28,
                  ),
                  onPressed: () => print('Add a comment'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildComments() {
    return Text('Comment');
  }
}

class Comment extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text('Comment'),
    );
  }
}
