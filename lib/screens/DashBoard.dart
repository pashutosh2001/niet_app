//firebase
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';

//database services
import 'package:niet_app/database/auth_services/auth_services.dart';
import 'package:niet_app/database/user_info/user_info.dart';

//screens
import 'package:niet_app/screens/Notice.dart';
import 'package:niet_app/screens/ProfileScreen.dart';
import 'package:niet_app/screens/authScreen.dart';
import 'package:niet_app/screens/calendarScreen.dart';
import 'package:niet_app/screens/marks_&_attendance_main_page.dart';

class DashBoard extends StatefulWidget {
  @override
  _DashBoardState createState() => _DashBoardState();
}

class _DashBoardState extends State<DashBoard> {
  String name, course, batch, imageUrl;
  var snapshots;

// accessing info for appBar
  @override
  void initState() {
    getUserInfo();
    super.initState();
  }

  getUserInfo() async {
    String email = FirebaseAuth.instance.currentUser.email;
    await User_Info().getUserInfo(email).then((userSnapshot) {
      name = userSnapshot.docs[0].data()['name'].toString();
      imageUrl = userSnapshot.docs[0].data()['imageUrl'].toString();
      course = userSnapshot.docs[0].data()['course'].toString();
      batch = userSnapshot.docs[0].data()['batch'].toString();
      // print(userSnapshot.docs[0].data()['imageUrl'].toString());
      setState(() {
        snapshots = userSnapshot;
      });
      print(snapshots);
    });
  }

  Widget menuIcons(String label, String image, int selectedIndex) {
    return GestureDetector(
      onTap: () {
        switch (selectedIndex) {
          case 1:
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        MarksAndAttendanceMainPage('Attendance')));
            break;

          case 2:
            // Navigator.push(
            //     context, MaterialPageRoute(builder: (context) => Profile()));
            break;

          case 3:
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => MarksAndAttendanceMainPage('Marks')));
            break;

          case 4:
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => CalendarScreen()));
            break;

          case 5:
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => Notice()));
            break;

          case 6:
            // Navigator.push(
            //     context, MaterialPageRoute(builder: (context) => Profile()));
            break;

          case 7:
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => Profile()));
            break;
        }
      },
      child: Container(
        height: MediaQuery.of(context).size.height * 0.16,
        width: MediaQuery.of(context).size.width * 0.25,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(10),
              height: MediaQuery.of(context).size.height * 0.08,
              width: MediaQuery.of(context).size.height * 0.08,
              child: Image.asset(image, fit: BoxFit.contain),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
                // backgroundBlendMode: BlendMode.color,
              ),
            ),
            SizedBox(height: 15),
            Text(
              label,
              style: TextStyle(fontSize: 14, color: Colors.white),
              softWrap: true,
              overflow: TextOverflow.fade,
              maxLines: 1,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff473f97),
      body: snapshots != null
          ? SafeArea(
              child: Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: Column(
                  children: [
                    Container(
                      height: 80,
                      width: double.maxFinite,
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundImage: NetworkImage(imageUrl),
                          radius: 25,
                        ),
                        title: Text(
                          name,
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                        subtitle: Text(
                          '<$batch>',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.white,
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.08),
                    Container(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              menuIcons(
                                  'Attendance', 'assets/attendant-list.png', 1),
                              menuIcons(
                                  'Examination', 'assets/examination.png', 2),
                              menuIcons('Marks', 'assets/report_card.png', 3),
                            ],
                          ),
                          SizedBox(
                              height:
                                  MediaQuery.of(context).size.height * 0.05),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              menuIcons('Calendar', 'assets/calendar.png', 4),
                              menuIcons('Notice', 'assets/notice.png', 5),
                              menuIcons('Messenger', 'assets/chat.png', 6),
                            ],
                          ),
                          SizedBox(
                              height:
                                  MediaQuery.of(context).size.height * 0.05),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              menuIcons('Profile', 'assets/profile.png', 7),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.05),
                    TextButton(
                        child: Text(
                          'Logout',
                          style: TextStyle(
                            color: Color(0xffff3564),
                          ),
                        ),
                        onPressed: () {
                          AuthServices().sign_Out();
                          Navigator.pushReplacement(context,
                              MaterialPageRoute(builder: (_) => AuthScreen()));
                        }),
                  ],
                ),
              ),
            )
          : Center(
              child: CircularProgressIndicator(),
            ),
    );
  }
}
