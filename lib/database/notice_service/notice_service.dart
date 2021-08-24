import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class NoticeService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User currentUser = FirebaseAuth.instance.currentUser;

  getAllNotices() async {
    try {
      return FirebaseFirestore.instance.collection('/notices').snapshots();
    } catch (error) {
      print('${error.toString()}');
    }
  }
}
