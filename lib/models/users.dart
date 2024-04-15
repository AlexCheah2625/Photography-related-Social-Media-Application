import 'package:cloud_firestore/cloud_firestore.dart';

class Users {
  final String username;
  final String uid;
  final String email;
  final String age;
  final String gender;
  final List followers;
  final List following;
  final String profilepic;
  final String bio;
  //constructer
  const Users({
    required this.username,
    required this.uid,
    required this.email,
    required this.age,
    required this.gender,
    required this.followers,
    required this.following,
    required this.bio,
    required this.profilepic,
  });
  //object
  Map<String, dynamic> toJson() => {
        "username": username,
        "uid": uid,
        "email": email,
        "age": age,
        "gender": gender,
        "follower": followers,
        "following": following,
        "bio": bio,
        "profilepic": profilepic,
      };

  //return user model
  static Users fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return Users(
        username: snapshot["username"],
        uid: snapshot["uid"],
        email: snapshot["email"],
        age: snapshot["age"],
        gender: snapshot["gender"],
        followers: snapshot["follower"],
        following: snapshot["following"],
        bio: snapshot["bio"],
        profilepic: snapshot["profilepic"]);
  }
}
