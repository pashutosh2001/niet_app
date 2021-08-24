import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:niet_app/Widgets/ClipPath.dart';
import 'package:niet_app/Widgets/GridView.dart';
import 'package:niet_app/database/marks%20&%20attendance/marks_attendance.dart';

class Attendance extends StatefulWidget {
  String subjectName;
  Attendance(this.subjectName);
  @override
  _AttendanceState createState() => _AttendanceState();
}

class _AttendanceState extends State<Attendance> {
  QuerySnapshot attendance;

  void initState() {
    getAttendance();
    super.initState();
  }

  getAttendance() async {
    await MarksAttendanceService()
        .getAllAttendance(widget.subjectName)
        .then((snapshots) {
      setState(() {
        attendance = snapshots;
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
                        Flexible(
                          child: Text(
                            widget.subjectName,
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Expanded(
                child: attendance != null
                    ? Container(
                        width: MediaQuery.of(context).size.width,
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: attendance.docs.length,
                          itemBuilder: (context, index) =>
                              AttendanceTile(attendance, index),
                        ),
                      )
                    : Center(
                        child: CircularProgressIndicator(),
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

class AttendanceTile extends StatefulWidget {
  QuerySnapshot attendance;
  int index;
  AttendanceTile(this.attendance, this.index);

  @override
  _AttendanceTileState createState() => _AttendanceTileState();
}

class _AttendanceTileState extends State<AttendanceTile> {
  Widget _infoContainer(
      String type, String value, Color containerColor, Color textColor) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 5),
        decoration: BoxDecoration(
          color: containerColor,
          borderRadius: BorderRadius.all(
            Radius.circular(20),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              child: Text(
                value,
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 20,
                  color: textColor,
                ),
              ),
            ),
            //numbers
            Container(
              child: Text(
                type,
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 20,
                  color: textColor,
                ),
                maxLines: 1,
                overflow: TextOverflow.fade,
              ),
            ),
            //Present
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.all(10),
      color: Color(0xfff7ffff),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            alignment: Alignment.center,
            height: 70,
            width: 70,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Color(0xfffd3667),
            ),
            child: Text(
              widget.attendance.docs[widget.index]
                  .data()['month']
                  .toString()
                  .substring(0, 3),
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 20,
                color: Color(0xffffffff),
              ),
            ),
          ),
          SizedBox(
            width: 10,
          ),
          //Present
          _infoContainer(
              'Present',
              widget.attendance.docs[widget.index].data()['present'].toString(),
              Color(0xffd4ffea),
              Color(0xff3bc07e)),

          SizedBox(
            width: 10,
          ),
          //Present
          _infoContainer(
              'Absent',
              widget.attendance.docs[widget.index].data()['absent'].toString(),
              Color(0xfffff1ec),
              Color(0xfffd2158)),

          SizedBox(
            width: 10,
          ),
          //Absent
          _infoContainer(
              'Total',
              widget.attendance.docs[widget.index].data()['total'].toString(),
              Color(0xffd4f5ff),
              Color(0xff382c8c)),
        ],
      ),
    );
  }
}
