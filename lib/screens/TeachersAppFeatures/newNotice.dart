import 'dart:io';
import 'dart:math';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:niet_app/Widgets/ClipPath.dart';
import 'package:niet_app/database/notice_service/newNoticeService.dart';

class NewNotice extends StatefulWidget {
  @override
  _NewNoticeState createState() => _NewNoticeState();
}

class _NewNoticeState extends State<NewNotice> {
  File file;
  String url;

  TextEditingController titleTextEditingController =
      new TextEditingController();

  TextEditingController descriptionTextEditingController =
      new TextEditingController();

  bool _isUploading = false;
  bool _isUploaded = false;

  final formKey = GlobalKey<FormState>();

  void _submit(BuildContext context) async {
    final isValid = formKey.currentState.validate();
    FocusScope.of(context).unfocus();

    if (isValid) {
      saveNotice();
    }
  }

  Future getPdf() async {
    String randomName = "";
    for (var i = 0; i < 20; i++) {
      randomName = randomName + Random().nextInt(10).toString();
    }
    FilePickerResult result =
        await FilePicker.platform.pickFiles(allowMultiple: false);
    if (result != null) {
      file = File(result.files.single.path);
      setState(() {
        _isUploading = true;
      });
    }

    String fileName = 'Notice_${randomName}.pdf';
    savePdf(fileName);
    //function call
  }

  savePdf(String name) async {
    Reference storageReference =
        FirebaseStorage.instance.ref().child('notices/$name');
    UploadTask uploadTask = storageReference.putFile(file);
    url = await (await uploadTask).ref.getDownloadURL();
    setState(() {
      _isUploading = false;
      _isUploaded = true;
    });
    print('The download url of pdf is---  $url');
    //function call
  }

  saveNotice() async {
    if (titleTextEditingController.text.isNotEmpty) {
      Map<String, dynamic> noticeMap = {
        "title": titleTextEditingController.text.trim(),
        "description": descriptionTextEditingController.text.trim(),
        "date": DateFormat.yMMMMd().format(DateTime.now()).toString(),
        "pdfUrl": url,
        "orderTime": DateTime.now().millisecondsSinceEpoch,
      };
      NewNoticeService().addNotice(noticeMap);
      await showDialog<String>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Text('New Notice Added'),
            actions: <Widget>[
              TextButton(
                  child: const Text('OK'),
                  onPressed: () => Navigator.pop(context)),
            ],
          );
        },
      );
      titleTextEditingController.text = "";
      descriptionTextEditingController.text = "";
    }
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
                          'New Notice',
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
                  child: SingleChildScrollView(
                    child: Form(
                      key: formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 20),
                          TextFormField(
                            controller: titleTextEditingController,
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Enter a Title';
                              }

                              return null;
                            },
                            decoration: InputDecoration(
                              labelText: 'Title',
                              labelStyle: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w500,
                                color: Colors.grey[400],
                              ),
                              focusedBorder: InputBorder.none,
                              border: InputBorder.none,
                              contentPadding:
                                  EdgeInsets.symmetric(horizontal: 5),
                            ),
                            cursorColor: Color(0xff473f97),
                            keyboardType: TextInputType.emailAddress,
                            cursorHeight: 25,
                            textAlignVertical: TextAlignVertical.center,
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey[800],
                            ),
                          ),
                          SizedBox(height: 20),
                          TextFormField(
                            maxLines: 10,
                            minLines: 1,
                            controller: descriptionTextEditingController,
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Enter description';
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              labelText: 'Description',
                              labelStyle: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w500,
                                color: Colors.grey[400],
                              ),
                              focusedBorder: InputBorder.none,
                              border: InputBorder.none,
                              contentPadding:
                                  EdgeInsets.symmetric(horizontal: 5),
                            ),
                            cursorColor: Color(0xff473f97),
                            keyboardType: TextInputType.emailAddress,
                            cursorHeight: 25,
                            textAlignVertical: TextAlignVertical.center,
                            // showCursor: false,
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey[700],
                            ),
                          ),
                          SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Text(_isUploading
                                  ? 'Uploading...'
                                  : _isUploaded
                                      ? 'File Uploaded'
                                      : 'Select Pdf'),
                              FlatButton(
                                child: Row(
                                  children: [
                                    Icon(Icons.upload_file),
                                    Text('Choose pdf'),
                                  ],
                                ),
                                onPressed: () => getPdf(),
                              )
                            ],
                          ),
                          SizedBox(height: 50),
                          GestureDetector(
                            child: Container(
                              alignment: Alignment.center,
                              margin: EdgeInsets.symmetric(
                                  horizontal:
                                      MediaQuery.of(context).size.width * 0.05),
                              height: 50,
                              width: double.maxFinite,
                              decoration: BoxDecoration(
                                color: Color(0xfffd3667),
                                borderRadius: BorderRadius.circular(30),
                              ),
                              child: Text(
                                'Add',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500),
                              ),
                            ),
                            onTap: () {
                              _submit(context);
                            },
                          ),
                          SizedBox(height: 40),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
