import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:niet_app/screens/Attendance.dart';
import 'package:niet_app/screens/Mark.dart';

class Grid extends StatefulWidget {
  QuerySnapshot subjects;
  String pageName;
  Grid(this.subjects, this.pageName);
  @override
  _GridState createState() => _GridState();
}

class _GridState extends State<Grid> {
  List<Color> col = [
    Color(0xffd4ffea),
    Color(0xffd4f5ff),
    Color(0xffffd4d4),
    Color(0xffe8eaec),
    Color(0xffffe9d4)
  ];

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      scrollDirection: Axis.vertical,
      itemCount: widget.subjects.docs.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 20,
        mainAxisSpacing: 20,
      ),
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {
            widget.pageName == 'Attendance'
                ? Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => Attendance(
                            widget.subjects.docs[index].data()['subjectName'])))
                : Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => Mark(widget.subjects.docs[index]
                            .data()['subjectName'])));
          },
          child: Container(
            alignment: Alignment.center,
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: col[index % 5],
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              widget.subjects.docs[index].data()['subjectName'],
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.grey[800],
              ),
              textAlign: TextAlign.center,
            ),
          ),
        );
      },
    );
  }
}
// for marks

// for attendance

// class AttendanceGrid extends StatefulWidget {
//   @override
//   _AttendanceGridState createState() => _AttendanceGridState();
// }

// class _AttendanceGridState extends State<AttendanceGrid> {
//   List<Color> col = [
//     Color(0xffd4ffeb),
//     Color(0xffd4f4ff),
//     Color(0xfffed4d5),
//     Color(0xffe9eaec),
//     Color(0xffffe7d6)
//   ];

//   @override
//   Widget build(BuildContext context) {
//     return GridView.builder(
//       scrollDirection: Axis.vertical,
//       itemCount: 5,
//       gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//         crossAxisCount: 2,
//         crossAxisSpacing: 20,
//         mainAxisSpacing: 20,
//       ),
//       itemBuilder: (context, index) {
//         return Container(
//           // height: 400,
//           // width: 400,
//           decoration: BoxDecoration(
//             boxShadow: [
//               BoxShadow(
//                   offset: Offset(2, 3), color: col[index], spreadRadius: 1),
//             ],
//             color: col[index],
//             borderRadius: BorderRadius.only(
//               topLeft: Radius.circular(10),
//               bottomLeft: Radius.circular(10),
//               bottomRight: Radius.circular(10),
//               topRight: Radius.circular(10),
//             ),
//           ),
//         );
//       },
//     );
//   }
// }
