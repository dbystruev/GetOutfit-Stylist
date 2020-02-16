import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:getoutfit_stylist/controllers/firebase.dart';
import 'package:getoutfit_stylist/pages/home.dart';
import 'package:getoutfit_stylist/widgets/header.dart';
import 'package:getoutfit_stylist/widgets/progress.dart';
import 'package:timeago/timeago.dart' as timeago;

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
  bool noComment = true;

  _CommentsState({
    this.lookId,
    this.lookOwnerId,
    this.lookMediaUrl,
  });

  void addComment() {
    commentsRef.document(lookId).collection('comments').add({
      'avatarUrl': currentUser.photoUrl,
      'comment': commentController.text.trim(),
      'timestamp': timestamp,
      'userId': currentUser.id,
      'username': currentUser.username,
    });
    commentController.clear();
  }

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
                trailing: noComment
                    ? Text('')
                    : OutlineButton(
                        borderSide: BorderSide.none,
                        child: Icon(
                          Icons.send,
                          color: Theme.of(context).accentColor,
                          size: 28,
                        ),
                        onPressed: () {
                          if (commentController.text.trim().isNotEmpty)
                            addComment();
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildComments() {
    return StreamBuilder(
      builder: (context, snapshot) {
        if (!snapshot.hasData) return circularProgress(context);
        List<Comment> comments = [];
        snapshot.data.documents.forEach((doc) {
          comments.add(
            Comment.fromDocument(doc),
          );
        });
        return ListView(children: comments);
      },
      stream: commentsRef
          .document(lookId)
          .collection('comments')
          .orderBy('timestamp', descending: true)
          .snapshots(),
    );
  }

  @override
  void initState() {
    super.initState();
    commentController.addListener(() {
      setState(() {
        noComment = commentController.text.trim().isEmpty;
      });
    });
  }
}

class Comment extends StatelessWidget {
  final String avatarUrl;
  final String comment;
  final Timestamp timestamp;
  final String userId;
  final String username;

  Comment({
    this.avatarUrl,
    this.comment,
    this.timestamp,
    this.userId,
    this.username,
  });

  factory Comment.fromDocument(DocumentSnapshot doc) {
    return Comment(
      avatarUrl: doc['avatarUrl'],
      comment: doc['comment'],
      timestamp: doc['timestamp'],
      userId: doc['userId'],
      username: doc['username'],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(children: <Widget>[
        ListTile(
          leading: CircleAvatar(
            backgroundImage: CachedNetworkImageProvider(avatarUrl),
          ),
          subtitle: Text(
            timeago.format(
              timestamp.toDate(),
            ),
          ),
          title: Text(comment),
        ),
        Divider(),
      ]),
    );
  }
}
