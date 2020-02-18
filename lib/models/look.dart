import 'package:cloud_firestore/cloud_firestore.dart';

class Look {
  final int commentCount;
  final String description;
  final dynamic likes;
  final String location;
  final String lookId;
  final String mediaUrl;
  final String ownerId;
  final String username;

  Look({
    this.commentCount,
    this.description,
    this.likes,
    this.location,
    this.lookId,
    this.mediaUrl,
    this.ownerId,
    this.username,
  });

  factory Look.fromDocument(DocumentSnapshot doc) {
    return Look(
      commentCount: doc['commentCount'] ?? 0,
      description: doc['description'],
      likes: doc['likes'],
      location: doc['location'],
      lookId: doc['lookId'],
      mediaUrl: doc['mediaUrl'],
      ownerId: doc['ownerId'],
      username: doc['username'],
    );
  }

  // Count likes
  int get likeCount => likes?.values == null || likes.values.isEmpty
      ? 0
      : likes.values
          .map((like) => like ? 1 : 0) // true is 1 and false is 0
          .reduce((total, element) => total + element); // calculating sum of 1s
}