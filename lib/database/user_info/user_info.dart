import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class User_Info {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User currentUser = FirebaseAuth.instance.currentUser;

  getUserInfo(String currentUserEmail) async {
    return await FirebaseFirestore.instance
        .collection(
            '/users/WHwrjNY5Jd7fz6yAvkwP/students/$currentUserEmail/details')
        .get();
  }

  // getCollegeId() {
  //   String email = FirebaseAuth.instance.currentUser.email;
  //   String collegeId;
  //   FirebaseFirestore.instance
  //       .collection('/users/WHwrjNY5Jd7fz6yAvkwP/students')
  //       .where(('email'), isEqualTo: email)
  //       .get()
  //       .then((documents) {
  //     collegeId = documents.docs[0].data()['collegeId'];
  //   });
  //   return collegeId;
  // }

  // Future validateCurrentPassword(String password) async {
  //   return await currentUser.reauthenticateWithCredential(credential);
  // }

  Future updateUserPassword(String password, BuildContext context) async {
    try {
      await currentUser.updatePassword(password).then((value) async {
        return await showDialog<String>(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              content: const Text('Password Changed Successfully'),
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
}
