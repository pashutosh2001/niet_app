import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

class CalendarEventServices {
  getAllEvents() async {
    try {
      return FirebaseFirestore.instance.collection('/calendarEvents').get();
    } catch (error) {
      print('${error.toString()}');
    }
  }

  newEvent(eventMap) async {
    try {
      FirebaseFirestore.instance.collection("calendarEvents").add(eventMap);
    } catch (error) {
      print('${error.toString()}');
    }
  }
}
