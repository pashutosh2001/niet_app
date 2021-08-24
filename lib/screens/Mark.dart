import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:niet_app/Widgets/ClipPath.dart';
import 'package:niet_app/Widgets/GridView.dart';
import 'package:niet_app/database/marks%20&%20attendance/marks_attendance.dart';

class Mark extends StatefulWidget {
  String subjectName;
  Mark(this.subjectName);
  @override
  _MarkState createState() => _MarkState();
}

class _MarkState extends State<Mark> {
  QuerySnapshot marks;

  void initState() {
    getMarks();
    super.initState();
  }

  getMarks() async {
    await MarksAttendanceService()
        .getAllMarks(widget.subjectName)
        .then((snapshots) {
      setState(() {
        marks = snapshots;
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
                child: marks != null
                    ? Container(
                        width: MediaQuery.of(context).size.width,
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: marks.docs.length,
                          itemBuilder: (context, index) =>
                              MarksTile(marks, index),
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

class MarksTile extends StatefulWidget {
  QuerySnapshot marks;
  int index;
  MarksTile(this.marks, this.index);

  @override
  _MarksTileState createState() => _MarksTileState();
}

class _MarksTileState extends State<MarksTile> {
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
    return Column(
      children: [
        Container(
          alignment: Alignment.centerLeft,
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Text(
            widget.marks.docs[widget.index].data()['exam'],
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: Colors.grey[700],
            ),
          ),
        ),
        Container(
          height: 100,
          width: MediaQuery.of(context).size.width,
          padding: EdgeInsets.all(10),
          color: Color(0xfff7ffff),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              //obtained Marks
              _infoContainer(
                  'Obtained Marks',
                  widget.marks.docs[widget.index].data()['obtained'].toString(),
                  Color(0xffd4ffea),
                  Color(0xff3bc07e)),

              SizedBox(
                width: 10,
              ),
              //Present
              _infoContainer(
                  'Maximum Marks',
                  widget.marks.docs[widget.index].data()['maximum'].toString(),
                  Color(0xfffff1ec),
                  Color(0xfffd2158)),
            ],
          ),
        ),
        SizedBox(
          height: 10,
        ),
        Divider(
          color: Colors.grey[500],
          thickness: 2.0,
          indent: 20,
          endIndent: 20,
        ),
      ],
    );
  }
}
