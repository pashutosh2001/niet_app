import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MarksAttendanceService {
  String currentUserEmail = FirebaseAuth.instance.currentUser.email;
  getSubjectsName() async {
    try {
      return FirebaseFirestore.instance
          .collection(
              '/users/WHwrjNY5Jd7fz6yAvkwP/students/$currentUserEmail/marks & attendance/')
          .get();
    } catch (error) {
      print('${error.toString()}');
    }
  }

  getAllAttendance(String subjectName) async {
    try {
      return FirebaseFirestore.instance
          .collection(
              '/users/WHwrjNY5Jd7fz6yAvkwP/students/$currentUserEmail/marks & attendance/$subjectName/attendance')
          .get();
    } catch (error) {
      print('${error.toString()}');
    }
  }

  getAllMarks(String subjectName) async {
    try {
      return FirebaseFirestore.instance
          .collection(
              '/users/WHwrjNY5Jd7fz6yAvkwP/students/$currentUserEmail/marks & attendance/$subjectName/marks')
          .get();
    } catch (error) {
      print('${error.toString()}');
    }
  }

  // getMarks() async {
  //   try{

  //   }catch(error){}
  // }
}
