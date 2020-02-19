import 'dart:async';
import 'package:animator/animator.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:getoutfit_stylist/controllers/firebase.dart';
import 'package:getoutfit_stylist/models/look.dart';
import 'package:getoutfit_stylist/models/user.dart';
import 'package:getoutfit_stylist/pages/activity_feed.dart';
import 'package:getoutfit_stylist/pages/comments.dart';
import 'package:getoutfit_stylist/pages/home.dart';
import 'package:getoutfit_stylist/utilities/plural.dart';
import 'package:getoutfit_stylist/widgets/custom_image.dart';
import 'package:getoutfit_stylist/widgets/progress.dart';

class LookWidget extends StatefulWidget {
  final Look look;

  LookWidget(this.look);

  factory LookWidget.fromDocument(DocumentSnapshot doc) {
    return LookWidget(
      Look.fromDocument(doc),
    );
  }

  @override
  _LookWidgetState createState() => _LookWidgetState(look);
}

class _LookWidgetState extends State<LookWidget> {
  int commentCount;
  final String currentUserId = currentUser?.id;
  bool isLiked;
  Look look;
  bool showHeart = false;

  _LookWidgetState(this.look) {
    commentCount = look.commentCount;
  }

  void addLikeToActivityFeed() {
    // Don't track likes of own posts
    if (currentUserId == look.ownerId) return;
    activityFeedRef
        .document(look.ownerId)
        .collection('feedItems')
        .document(look.lookId)
        .setData({
      'lookId': look.lookId,
      'mediaUrl': look.mediaUrl,
      'timestamp': timestamp,
      'type': ActivityType.like.toString(),
      'userId': currentUserId,
      'username': currentUser.username,
      'userProfileImg': currentUser.photoUrl,
    }).catchError((error) {
      final String path = '/feed/${look.ownerId}/feedItems/${look.lookId}';
      print('ERROR adding $path: $error');
    });
  }

  @override
  Widget build(BuildContext context) {
    isLiked = look.likes[currentUserId] ?? false;
    return Column(
      children: <Widget>[
        buildLookHeader(),
        buildLookImage(),
        buildLookFooter(),
        Divider(thickness: 2),
      ],
      mainAxisSize: MainAxisSize.min,
    );
  }

  Widget buildLookFooter() {
    return Column(
      children: <Widget>[
        Row(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(left: 20, top: 40),
            ),
            Column(
              children: <Widget>[
                GestureDetector(
                  child: Icon(
                    isLiked ? Icons.favorite : Icons.favorite_border,
                    color: Colors.pink,
                    size: 28,
                  ),
                  onTap: handleLikeLook,
                ),
                Text(
                  pluralize(look.likeCount, 'like'),
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            SizedBox(width: 20),
            Column(
              children: <Widget>[
                GestureDetector(
                  child: Icon(
                    Icons.chat,
                    color: Theme.of(context).accentColor,
                    size: 28,
                  ),
                  onTap: () => showComments(
                    context,
                    lookId: look.lookId,
                    ownerId: look.ownerId,
                    mediaUrl: look.mediaUrl,
                  ),
                ),
                Text(
                  pluralize(commentCount, 'comment'),
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ],
          mainAxisAlignment: MainAxisAlignment.start,
        ),
        SizedBox(height: 4),
        Row(
          children: <Widget>[
            SizedBox(width: 20),
            Text(
              look.username,
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(width: 8),
            Expanded(
              child: Text(look.description),
            )
          ],
          crossAxisAlignment: CrossAxisAlignment.start,
        ),
      ],
    );
  }

  Widget buildLookHeader() {
    return FutureBuilder(
      builder: (context, snapshot) {
        if (!snapshot.hasData) return circularProgress(context);
        final User user = User.fromDocument(snapshot.data);
        return ListTile(
          leading: CircleAvatar(
            backgroundColor: Colors.grey,
            backgroundImage: CachedNetworkImageProvider(user.photoUrl),
          ),
          subtitle: Text(look.location),
          title: GestureDetector(
            child: Text(
              user.username,
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            onTap: () => print('Show Profile'),
          ),
          trailing: IconButton(
            icon: Icon(Icons.more_vert),
            onPressed: () => print('Delete Look'),
          ),
        );
      },
      future: usersRef.document(look.ownerId).get(),
    );
  }

  Widget buildLookImage() {
    return GestureDetector(
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          cachedNetworkImage(look.mediaUrl),
          showHeart
              ? Animator(
                  builder: (animation) => Transform.scale(
                    child: Icon(
                      Icons.favorite,
                      color: Colors.pink,
                      size: 80,
                    ),
                    scale: animation.value,
                  ),
                  curve: Curves.elasticOut,
                  cycles: 0,
                  duration: Duration(milliseconds: 300),
                  tween: Tween(begin: 0.8, end: 1.4),
                )
              : Container(),
        ],
      ),
      onDoubleTap: handleLikeLook,
    );
  }

  void handleLikeLook() {
    final bool previouslyLiked = look.likes[currentUserId] ?? false;
    looksRef
        .document(look.ownerId)
        .collection('userLooks')
        .document(look.lookId)
        .updateData({'likes.$currentUserId': !previouslyLiked});
    if (previouslyLiked)
      removeLikeFromActivityFeed();
    else
      addLikeToActivityFeed();
    setState(() {
      isLiked = !previouslyLiked;
      look.likes[currentUserId] = isLiked;
      if (isLiked) showHeart = true;
    });
    if (showHeart)
      Timer(Duration(milliseconds: 500), () {
        setState(() => showHeart = false);
      });
  }

  void removeLikeFromActivityFeed() {
    activityFeedRef
        .document(look.ownerId)
        .collection('feedItems')
        .document(look.lookId)
        .delete()
        .catchError((error) {
      final String path = '/feed/${look.ownerId}/feedItems/${look.lookId}';
      print('ERROR deleting $path: $error');
    });
  }

  void showComments(
    BuildContext context, {
    String lookId,
    String ownerId,
    String mediaUrl,
  }) async {
    final int newCommentCount = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) {
        return Comments(
          commentCount: commentCount,
          lookId: lookId,
          lookOwnerId: ownerId,
          lookMediaUrl: mediaUrl,
        );
      }),
    );
    if (commentCount != newCommentCount)
      setState(() {
        commentCount = newCommentCount;
      });
  }
}
