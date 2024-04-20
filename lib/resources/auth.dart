import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:practice/models/users.dart' as model;
import 'storage.dart';

class AuthMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<model.Users> getUserDetails() async {
    User currentUser = _auth.currentUser!;

    DocumentSnapshot snap =
        await _firestore.collection('users').doc(currentUser.uid).get();

    return model.Users.fromSnap(snap);
  }

  //sign up user
  Future<String> signUpUser(
      {required String email,
      required String username,
      required String password,
      required String age,
      required String gender,
      required String bio,
      required Uint8List file}) async {
    String res = "Some error occured";
    try {
      if (email.isNotEmpty ||
          username.isNotEmpty ||
          password.isNotEmpty ||
          age.isNotEmpty ||
          gender.isNotEmpty ||
          bio.isNotEmpty ||
          file != null) {
        //register user
        UserCredential cred = await _auth.createUserWithEmailAndPassword(
            email: email, password: password);

        print(cred.user!.uid);

        String photoURL =
            await Storage().uploadPictoStorage('profilepictures', file, false);

        
        model.Users user = model.Users(
          username: username,
          uid: cred.user!.uid,
          email: email,
          age: age,
          gender: gender,
          followers: [],
          following: [],
          profilepic: photoURL,
          bio: bio,
        );

        await _firestore
            .collection('users')
            .doc(cred.user!.uid)
            .set(user.toJson());

        res = "success";
      }
    } on FirebaseAuthException catch (err) {
      if (err.code == 'invalid-email') {
        res = 'The email is not formated correctly.';
      } else if (err.code == 'weak-password') {
        res = 'The password must be more than 6 characters.';
      }
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  //LOGGING IN USER
  Future<String> loginUser(
      {required String email, required String password}) async {
    String res = "Some error occured";

    try {
      if (email.isNotEmpty || password.isNotEmpty) {
        await _auth.signInWithEmailAndPassword(
            email: email, password: password);
        res = "Success";
      } else {
        res = "Please enter all the fields";
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        res = "User not found. Please register an account";
      } else if (e.code == 'wrong-passsword') {
        res = "Invalid Password";
      }
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  Future<void> Logout() async {
    await _auth.signOut();
  }

  Future resetPassword(String email) async {
    await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
  }
}
