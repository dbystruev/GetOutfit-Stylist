import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String bio;
  final String displayName;
  final String email;
  final String id;
  final String photoUrl;
  final String username;

  User({
    this.bio,
    this.displayName,
    this.email,
    this.id,
    this.photoUrl,
    this.username,
  });

  factory User.fromDocument(DocumentSnapshot doc) {
    return User(
      bio: doc['bio'],
      displayName: doc['displayName'],
      email: doc['email'],
      id: doc['id'],
      photoUrl: doc['photoUrl'],
      username: doc['username'],
    );
  }
}
