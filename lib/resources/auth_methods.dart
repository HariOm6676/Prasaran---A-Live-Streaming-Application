import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:video_conferencing/models/user.dart' as model;
import 'package:video_conferencing/providers/user_provider.dart';
import 'package:video_conferencing/utils/utils.dart';

class AuthMethods {
  final _userRef = FirebaseFirestore.instance.collection('users');
  final _auth = FirebaseAuth.instance;

  Future<Map<String, dynamic>?> getCurrentUser(String? uid) async {
    if (uid != null) {
      final snap = await _userRef.doc(uid).get();
      return snap.data();
    }
  }

  Future<bool> signUpUser(String email, String username, String password,
      BuildContext context) async {
    bool res = false;
    try {
      UserCredential cred = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      if (cred.user != null) {
        model.User user = model.User(
            email: email.trim(),
            username: username.trim(),
            uid: cred.user!.uid);
        await _userRef.doc(cred.user!.uid).set(user.toMap());
        Provider.of<UserProvider>(context, listen: false).setUser(user);
        res = true;
      }
    } on FirebaseAuthException catch (e) {
      print(e.message!);
      showSnackBar(context, e.message!);
    }
    return res;
  }

  Future<bool> loginUser(
      String email, String password, BuildContext context) async {
    bool res = false;
    try {
      UserCredential cred = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      if (cred.user != null) {
        Provider.of<UserProvider>(context, listen: false).setUser(
            model.User.fromMap(await getCurrentUser(cred.user!.uid) ?? {}));
        res = true;
      }
    } on FirebaseAuthException catch (e) {
      print(e.message!);
      showSnackBar(context, e.message!);
    }
    return res;
  }
}
