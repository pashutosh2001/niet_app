import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:niet_app/screens/TeachersAppFeatures/newNotice.dart';
import 'package:path_provider/path_provider.dart';
import 'package:ext_storage/ext_storage.dart';
// import 'dart:io';
import 'package:permission_handler/permission_handler.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:niet_app/Widgets/ClipPath.dart';
import 'package:niet_app/database/notice_service/notice_service.dart';

class Notice extends StatefulWidget {
  @override
  _NoticeState createState() => _NoticeState();
}

class _NoticeState extends State<Notice> {
  List<Color> colors = [
    Color(0xffd4ffea),
    Color(0xffd4f5ff),
    Color(0xffffd4d4),
    Color(0xffe8eaec),
    Color(0xffffe9d4)
  ];

  List<bool> _isDownloading = [];

  String progress;
  Stream noticeStream;

  QuerySnapshot notices;

  void initState() {
    getNotices();
    getPermission();

    super.initState();
  }

  void getPermission() async {
    var status = await Permission.storage.status;
    if (status.isUndetermined) {
      // You can request multiple permissions at once.
      Map<Permission, PermissionStatus> statuses = await [
        Permission.storage,
      ].request();
      print(statuses[
          Permission.storage]); // it should print PermissionStatus.granted
    }
  }

  //pdf download function
  Future<void> downloadFile(String pdfUrl, String noticeTitle, int index,
      BuildContext context) async {
    Dio dio = Dio();

    try {
      Directory dir = await getExternalStorageDirectory();

      await dio.download(pdfUrl, "${dir.path}/$noticeTitle.pdf",
          onReceiveProgress: (rec, total) {
        setState(() {
          _isDownloading[index] = true;
          progress = ((rec / total) * 100).toStringAsFixed(0) + "%";
        });
      }).then((value) async {
        await showDialog<String>(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              content: Text('File Downloaded at ${dir.path}'),
              actions: <Widget>[
                TextButton(
                    child: const Text('OK'),
                    onPressed: () => Navigator.pop(context)),
              ],
            );
          },
        );
        setState(() {
          _isDownloading[index] = false;
          progress = "Completed";
        });
        print("Download completed");
        print('${dir.path}');
      });
    } catch (error) {
      print(error);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('${error.toString()}')));
    }
  }

  Future<void> getNotices() async {
    await NoticeService().getAllNotices().then((stream) {
      setState(() {
        noticeStream = stream;
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
                          'Notice Board',
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
                    color: Colors.white,
                    child: StreamBuilder(
                        stream: noticeStream,
                        builder: (context, snapshot) {
                          int snapshotDocLength =
                              snapshot.hasData ? snapshot.data.docs.length : 0;
                          for (int i = 0; i < snapshotDocLength; i++) {
                            _isDownloading.add(false);
                          }
                          return snapshot.hasData
                              ? RefreshIndicator(
                                  onRefresh: () => getNotices(),
                                  child: ListView.builder(
                                    shrinkWrap: true,
                                    scrollDirection: Axis.vertical,
                                    itemCount: snapshot.data.docs.length,
                                    itemBuilder: (context, index) {
                                      return Column(
                                        children: [
                                          Container(
                                            height: 120,
                                            width: double.maxFinite,
                                            padding: EdgeInsets.all(10),
                                            decoration: BoxDecoration(
                                              color: colors[index % 5],
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            child: Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                GestureDetector(
                                                  onTap: () => downloadFile(
                                                      snapshot.data.docs[index]
                                                          .data()['pdfUrl'],
                                                      snapshot.data.docs[index]
                                                          .data()['title'],
                                                      index,
                                                      context),
                                                  child: Container(
                                                    height: 105,
                                                    width: 105,
                                                    child: _isDownloading[index]
                                                        ? Center(
                                                            child: Text(
                                                                '$progress'),
                                                          )
                                                        : Image.asset(
                                                            'assets/pdf.png',
                                                            fit: BoxFit.contain,
                                                          ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 5,
                                                ),
                                                Expanded(
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceEvenly,
                                                    children: [
                                                      Text(
                                                        snapshot
                                                            .data.docs[index]
                                                            .data()['title'],
                                                        style: TextStyle(
                                                          fontSize: 18,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                        ),
                                                        maxLines: 1,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        softWrap: true,
                                                      ),
                                                      // SizedBox(height: 5),
                                                      Text(
                                                        snapshot.data
                                                                .docs[index]
                                                                .data()[
                                                            'description'],
                                                        style: TextStyle(
                                                          fontSize: 14,
                                                          fontWeight:
                                                              FontWeight.w400,
                                                        ),
                                                        maxLines: 2,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        // softWrap: true,
                                                      ),
                                                      // SizedBox(height: 5),
                                                      Align(
                                                        alignment: Alignment
                                                            .centerRight,
                                                        child: Text(
                                                          snapshot
                                                              .data.docs[index]
                                                              .data()['date'],
                                                          style: TextStyle(
                                                            fontSize: 12,
                                                            fontWeight:
                                                                FontWeight.w400,
                                                            color: Color(
                                                                0xff473f97),
                                                          ),
                                                          // maxLines: 2,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          // softWrap: true,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          SizedBox(height: 20),
                                        ],
                                      );
                                    },
                                  ),
                                )
                              : Center(child: CircularProgressIndicator());
                        })),
              ),
            ],
          ),
        ),
      ),
      // floatingActionButton: FloatingActionButton(
      //   child: Icon(Icons.add), backgroundColor: Color(0xff473f97),
      //   // focusColor: Color(0xff473f97),
      //   onPressed: () => Navigator.push(
      //       context, MaterialPageRoute(builder: (context) => NewNotice())),
      // ),
    );
  }
}
