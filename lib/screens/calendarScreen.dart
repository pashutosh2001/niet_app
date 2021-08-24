import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:intl/intl.dart';
import 'package:niet_app/Widgets/ClipPath.dart';
import 'package:niet_app/database/CalenderEventServices/eventService.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:syncfusion_flutter_calendar/calendar.dart';

class CalendarScreen extends StatefulWidget {
  @override
  _CalendarScreenState createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  TextEditingController titleController = new TextEditingController();
  DateTime _selectedDate;
  String colorName;

  int value;

  Color pickedColor = Color(0xffd4ffea);

  final formKey = GlobalKey<FormState>();

  List<Meeting> meetings;

  CalendarController controller;

  Stream eventsStream;

  QuerySnapshot eventSnapshots;

  bool _gettingEvents = false;

  void initState() {
    getEvents();
    super.initState();
    controller = new CalendarController();
  }

  void _datePicker() {
    showDatePicker(
      builder: (BuildContext context, Widget child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: ColorScheme.fromSwatch(
              primarySwatch: Colors.teal,
              primaryColorDark: Colors.teal,
              accentColor: Colors.teal,
            ),
            dialogBackgroundColor: Colors.white,
          ),
          child: child,
        );
      },
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2021),
      lastDate: DateTime(2022),
    ).then((pickedDate) {
      if (pickedDate == null) {
        return;
      }
      setState(() {
        _selectedDate = pickedDate;
      });
    });
  }

  void _submit(BuildContext context) async {
    final isValid = formKey.currentState.validate();
    FocusScope.of(context).unfocus();

    if (isValid) {
      saveEvent();
      getEvents();
      await showDialog<String>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Text('New Event Added'),
            actions: <Widget>[
              TextButton(
                  child: const Text('OK'),
                  onPressed: () => Navigator.pop(context)),
            ],
          );
        },
      );

      // print('$title \n\n $_selectedDate');
      Navigator.pop(context);
    }
  }

  saveEvent() async {
    if (titleController.text.isNotEmpty) {
      String stringColor = pickedColor.toString();
      String valueString =
          stringColor.split('(0x')[1].split(')')[0]; // kind of hacky..

      Map<String, dynamic> eventMap = {
        "title": titleController.text.trim(),
        "eventDate": DateFormat("yyyy-MM-dd").format(_selectedDate),
        "color": valueString,
      };
      print(valueString);

      CalendarEventServices().newEvent(eventMap);

      titleController.text = "";
    }
  }

  Future<void> getEvents() async {
    meetings = <Meeting>[];
    await CalendarEventServices().getAllEvents().then((snapshots) {
      setState(() {
        eventSnapshots = snapshots;
      });
      if (snapshots != null) {
        for (int i = 0; i < snapshots.docs.length; i++) {
          String title = snapshots.docs[i].data()['title'].toString();
          DateTime startTime =
              DateTime.parse(snapshots.docs[i].data()['eventDate'].toString());
          String colorValueString =
              snapshots.docs[i].data()['color'].toString();
          print('\n\n$startTime\n');
          print(colorValueString);
          DateTime endTime = startTime.add(const Duration(days: 0));

          // get color from database...................

          int colorValue = int.parse(colorValueString, radix: 16);
          print(colorValue);

          meetings
              .add(Meeting(title, startTime, endTime, Color(colorValue), true));
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff473f97),
      body: SafeArea(
        child: Container(
          // padding: EdgeInsets.only(top: 20),
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
                          'Calendar',
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              eventSnapshots != null
                  ? Expanded(
                      child: SfCalendar(
                        view: CalendarView.month,
                        firstDayOfWeek: 1,
                        initialSelectedDate: DateTime.now(),
                        initialDisplayDate: DateTime.now(),
                        controller: controller,
                        dataSource: MeetingDataSource(meetings),
                        showDatePickerButton: true,
                        selectionDecoration: BoxDecoration(
                          color: Colors.transparent,
                          border: Border.all(
                              color: const Color.fromARGB(255, 68, 140, 255),
                              width: 2),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(4)),
                          shape: BoxShape.rectangle,
                        ),
                        monthViewSettings: MonthViewSettings(
                            showAgenda: true,
                            // agendaViewHeight: 900,
                            agendaItemHeight: 80,
                            showTrailingAndLeadingDates: false,
                            appointmentDisplayMode:
                                MonthAppointmentDisplayMode.indicator),
                      ),
                    )
                  : Center(
                      child: CircularProgressIndicator(),
                    ),
            ],
          ),
        ),
      ),
      // floatingActionButton: FloatingActionButton(
      //   child: Icon(Icons.add), backgroundColor: Color(0xff473f97),
      //   // focusColor: Color(0xff473f97),
      //   onPressed: () {
      //     print(controller.selectedDate);
      //     showModalBottomSheet(
      //       shape: RoundedRectangleBorder(
      //         borderRadius: BorderRadius.only(
      //           topLeft: Radius.circular(16),
      //           topRight: Radius.circular(16),
      //         ),
      //       ),
      //       context: context,
      //       builder: (_) {
      //         return StatefulBuilder(
      //           builder: (BuildContext context, setState) =>
      //               SingleChildScrollView(
      //             child: GestureDetector(
      //               onTap: () {},
      //               child: Card(
      //                 shape: RoundedRectangleBorder(
      //                   borderRadius: BorderRadius.only(
      //                     topLeft: Radius.circular(16),
      //                     topRight: Radius.circular(16),
      //                   ),
      //                 ),
      //                 child: Container(
      //                   // height: 400,
      //                   padding: EdgeInsets.only(
      //                     top: 30,
      //                     left: 10,
      //                     right: 10,
      //                     bottom: MediaQuery.of(context).viewInsets.bottom + 10,
      //                   ),
      //                   child: Column(
      //                     crossAxisAlignment: CrossAxisAlignment.end,
      //                     children: <Widget>[
      //                       Form(
      //                         key: formKey,
      //                         child: TextFormField(
      //                           controller: titleController,
      //                           validator: (value) {
      //                             if (value.isEmpty) {
      //                               return 'Enter a title';
      //                             }

      //                             return null;
      //                           },
      //                           decoration: InputDecoration(
      //                             labelText: 'Title',
      //                             labelStyle: TextStyle(
      //                               fontSize: 20,
      //                               fontWeight: FontWeight.w500,
      //                               color: Colors.grey[400],
      //                             ),
      //                             focusedBorder: InputBorder.none,
      //                             border: InputBorder.none,
      //                             contentPadding:
      //                                 EdgeInsets.symmetric(horizontal: 5),
      //                           ),
      //                           cursorColor: Color(0xff473f97),
      //                           keyboardType: TextInputType.emailAddress,
      //                           cursorHeight: 25,
      //                           textAlignVertical: TextAlignVertical.center,
      //                           // showCursor: false,
      //                           style: TextStyle(
      //                             fontSize: 20,
      //                             fontWeight: FontWeight.w600,
      //                             color: Colors.grey[700],
      //                           ),
      //                         ),
      //                       ),
      //                       SizedBox(height: 20),
      //                       Row(
      //                         children: [
      //                           Text(
      //                             _selectedDate != null
      //                                 ? DateFormat("yyyy, MM, dd")
      //                                     .format(_selectedDate)
      //                                 : 'No Date Choosen',
      //                           ),
      //                           SizedBox(width: 20),
      //                           FlatButton(
      //                             child: Text(
      //                               'Choose Date',
      //                               style:
      //                                   TextStyle(fontWeight: FontWeight.bold),
      //                             ),
      //                             textColor: Color(0xff473f97),
      //                             onPressed: _datePicker,
      //                           )
      //                         ],
      //                       ),
      //                       SizedBox(height: 20),

      //                       // for color Picker
      //                       RaisedButton(
      //                         elevation: 3.0,
      //                         onPressed: () {
      //                           showDialog(
      //                             context: context,
      //                             builder: (BuildContext context) {
      //                               return AlertDialog(
      //                                 titlePadding: const EdgeInsets.all(0.0),
      //                                 contentPadding: const EdgeInsets.all(0.0),
      //                                 content: SingleChildScrollView(
      //                                   child: ColorPicker(
      //                                     pickerColor: pickedColor,
      //                                     onColorChanged: (Color color) {
      //                                       setState(() {
      //                                         pickedColor = color;
      //                                       });
      //                                       print(pickedColor.toString());

      //                                       String stringColor =
      //                                           pickedColor.toString();
      //                                       String valueString = stringColor
      //                                           .split('(0x')[1]
      //                                           .split(
      //                                               ')')[0]; // kind of hacky..
      //                                       print(valueString);
      //                                       value = int.parse(valueString,
      //                                           radix: 16);
      //                                       print(value);

      //                                       print(pickedColor);
      //                                       // print('$colorName.............');
      //                                     },
      //                                     colorPickerWidth:
      //                                         MediaQuery.of(context)
      //                                                 .size
      //                                                 .width *
      //                                             0.8,
      //                                     pickerAreaHeightPercent: 0.7,
      //                                     enableAlpha: true,
      //                                     displayThumbColor: true,
      //                                     showLabel: true,
      //                                     paletteType: PaletteType.hsv,
      //                                     pickerAreaBorderRadius:
      //                                         const BorderRadius.only(
      //                                       topLeft: const Radius.circular(2.0),
      //                                       topRight:
      //                                           const Radius.circular(2.0),
      //                                     ),
      //                                   ),
      //                                 ),
      //                                 actions: [
      //                                   TextButton(
      //                                     child: Text('OK'),
      //                                     onPressed: () =>
      //                                         Navigator.pop(context),
      //                                   )
      //                                 ],
      //                               );
      //                             },
      //                           );
      //                         },
      //                         child: const Text('Change me'),
      //                         color: pickedColor,
      //                         textColor: Colors.black,
      //                       ),
      //                       SizedBox(height: 20),
      //                       Container(
      //                         color: value != null ? Color(value) : Colors.red,
      //                         height: 30,
      //                         width: 30,
      //                       ),
      //                       SizedBox(height: 20),
      //                       RaisedButton(
      //                         child: Text('Add Event'),
      //                         color: Color(0xffffd4d4),
      //                         onPressed: () => _submit(context),
      //                       )
      //                     ],
      //                   ),
      //                 ),
      //               ),
      //               behavior: HitTestBehavior.opaque,
      //             ),
      //           ),
      //         );
      //       },
      //     );
      //   },
      // ),
    );

    //   Scaffold(
    //     body:
    //   );
  }

  // DateTime eventDate = DateTime.parse('2021-01-16');
  // String title = 'Special Event';
  // List<Meeting> _getDataSource(
  //     String title, String selectedDate, String color) {
  //   final DateTime startTime = DateTime.parse(selectedDate);
  //   String valueString = color.split('(0x')[1].split(')')[0]; // kind of hacky..
  //   int value = int.parse(valueString, radix: 16);
  //   print(value);
  //   print(valueString);
  //   print(color);
  //   print(startTime);
  //   final DateTime endTime = startTime.add(const Duration(days: 0));
  //   meetings.add(Meeting(title, startTime, endTime, Color(0xffddd4ff), true));

  //   return meetings;
  // }
}

class MeetingDataSource extends CalendarDataSource {
  MeetingDataSource(List<Meeting> source) {
    appointments = source;
  }

  @override
  DateTime getStartTime(int index) {
    return appointments[index].from;
  }

  @override
  DateTime getEndTime(int index) {
    return appointments[index].to;
  }

  @override
  String getSubject(int index) {
    return appointments[index].eventName;
  }

  @override
  Color getColor(int index) {
    return appointments[index].background;
  }

  @override
  bool isAllDay(int index) {
    return appointments[index].isAllDay;
  }
}

class Meeting {
  Meeting(this.eventName, this.from, this.to, this.background, this.isAllDay);

  String eventName;
  DateTime from;
  DateTime to;
  Color background;
  bool isAllDay;
}
