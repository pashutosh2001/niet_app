import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:niet_app/Widgets/ClipPath.dart';
import 'package:niet_app/Widgets/GridView.dart';
import 'package:niet_app/database/marks%20&%20attendance/marks_attendance.dart';

class MarksAndAttendanceMainPage extends StatefulWidget {
  String pageName;
  MarksAndAttendanceMainPage(this.pageName);
  @override
  _MarksAndAttendanceMainPageState createState() =>
      _MarksAndAttendanceMainPageState();
}

class _MarksAndAttendanceMainPageState
    extends State<MarksAndAttendanceMainPage> {
  QuerySnapshot subjects;

  void initState() {
    getSubjects();
    super.initState();
  }

  getSubjects() async {
    await MarksAttendanceService().getSubjectsName().then((snapshots) {
      setState(() {
        subjects = snapshots;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff473f97),
      body: SafeArea(
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          color: Colors.white,
          child: Column(
            children: [
              Container(
                color: Colors.white,
                child: ClipPath(
                  clipper: MyClipper(),
                  child: Container(
                    color: Color(0xff473f97),
                    height: 90,
                    width: MediaQuery.of(context).size.width,
                    padding: EdgeInsets.only(left: 10, right: 10, bottom: 25),
                    alignment: Alignment.center,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        IconButton(
                          icon: Icon(Icons.arrow_back_ios),
                          color: Colors.white,
                          highlightColor: Colors.white10,
                          splashColor: Colors.white10,
                          iconSize: 20,
                          onPressed: () => Navigator.pop(context),
                        ),
                        Text(
                          widget.pageName,
                          style: TextStyle(color: Colors.white, fontSize: 19),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.only(bottom: 30, left: 10, right: 10),
                  child: subjects != null
                      ? Grid(subjects, widget.pageName)
                      : Center(
                          child: CircularProgressIndicator(),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
      //
    );
  }
}
