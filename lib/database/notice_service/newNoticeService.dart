import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class NewNoticeService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User currentUser = FirebaseAuth.instance.currentUser;

  addNotice(noticeMap) async {
    
    try {
      FirebaseFirestore.instance
        .collection("notices")
        .add(noticeMap);
    } catch (error) {
      print('${error.toString()}');
    }
  }
}
