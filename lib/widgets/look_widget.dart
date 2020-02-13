import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:getoutfit_stylist/controllers/firebase.dart';
import 'package:getoutfit_stylist/models/look.dart';
import 'package:getoutfit_stylist/models/user.dart';
import 'package:getoutfit_stylist/pages/home.dart';
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
  final String currentUserId = currentUser?.id;
  bool isLiked;
  Look look;

  _LookWidgetState(this.look);

  @override
  Widget build(BuildContext context) {
    isLiked = look.likes[currentUserId] ?? false;
    return Column(
      children: <Widget>[
        buildLookHeader(),
        buildLookImage(),
        buildLookFooter(),
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
            GestureDetector(
              child: Icon(
                isLiked ? Icons.favorite : Icons.favorite_border,
                color: Colors.pink,
                size: 28,
              ),
              onTap: handleLikeLook,
            ),
            SizedBox(width: 20),
            GestureDetector(
              child: Icon(
                Icons.chat,
                color: Theme.of(context).accentColor,
                size: 28,
              ),
              onTap: () => print('Show comments'),
            ),
          ],
          mainAxisAlignment: MainAxisAlignment.start,
        ),
        Row(
          children: <Widget>[
            SizedBox(width: 20),
            Text(
              '${look.likeCount} like${look.likeCount == 1 ? '' : 's'}',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
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
        setState(() {
          isLiked = !previouslyLiked;
          look.likes[currentUserId] = isLiked;
        });
  }
}
