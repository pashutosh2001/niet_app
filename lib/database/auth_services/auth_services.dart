import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:niet_app/model/users.dart';

class AuthServices {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  user _userFromFirebaseUser(User firebaseUser) {
    return firebaseUser != null ? user(userId: firebaseUser.uid) : null;
  }

  Future signInWithEmail(
      String email, String password, BuildContext context) async {
    try {
      UserCredential credential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      User firebaseUser = credential.user;
      return _userFromFirebaseUser(firebaseUser);
    } catch (error) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('${error.toString()}')));

      print(error.toString());
    }
  }

  // Future resetPassword(String email) async {
  //   try {
  //     return await _auth.sendPasswordResetEmail(email: email);
  //   } catch (error) {
  //     print(error.toString());
  //   }
  // }

  Future sendPasswordResetMail(String resetEmail, BuildContext context) async {
    try {
      await _auth.sendPasswordResetEmail(email: resetEmail).then((value) async {
        return await showDialog<String>(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              content: const Text(
                  'A password reset link has been sent to your registered mail'),
              actions: <Widget>[
                TextButton(
                    child: const Text('OK'),
                    onPressed: () => Navigator.pop(context)),
              ],
            );
          },
        );
      });
    } catch (error) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('${error.toString()}')));

      print(error.toString());
    }
  }

  Future sign_Out() async {
    try {
      return await _auth.signOut();
    } catch (error) {
      print(error.toString());
    }
  }

  Future changePassword(String newPassword, BuildContext context) async {
    try {
      await _auth.currentUser.updatePassword(newPassword);
      // .then((value) async {
      //   return await showDialog<String>(
      //     context: context,
      //     builder: (BuildContext context) {
      //       return AlertDialog(
      //         content: const Text('Password Changed'),
      //         actions: <Widget>[
      //           TextButton(
      //               child: const Text('OK'),
      //               onPressed: () {
      //                 Navigator.pop(context);
      //               }),
      //         ],
      //       );
      //     },
      //   );
      // });
    } catch (error) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('${error.toString()}')));

      print(error.toString());
    }
  }

  // Stream<User> get handleAuth{
  //   return _auth.authStateChanges().map(_userFromFirebaseUser);
  // }
}
