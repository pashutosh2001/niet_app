import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:niet_app/Widgets/ClipPath.dart';
import 'package:niet_app/database/user_info/user_info.dart';
import 'package:niet_app/model/user_model.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  bool _isChangePassword = false;
  TextEditingController newPasswordTextEditingController =
      new TextEditingController();

  TextEditingController confirmPasswordTextEditingController =
      new TextEditingController();

  final formKey = GlobalKey<FormState>();

  String name,
      imageUrl,
      course,
      batch,
      collegeId,
      dob,
      bloodGroup,
      contact,
      fatherName,
      motherName;

  QuerySnapshot snapshots;

//  accessing user info
  @override
  void initState() {
    getUserInfo();
    super.initState();
  }

  void _submit(BuildContext context) async {
    final isValid = formKey.currentState.validate();
    FocusScope.of(context).unfocus();

    if (isValid) {
      await User_Info()
          .updateUserPassword(
              confirmPasswordTextEditingController.text, context)
          .then((value) => setState(() {
                _isChangePassword = false;
                newPasswordTextEditingController.text = '';
                confirmPasswordTextEditingController.text = '';
              }));
    }
  }

  getUserInfo() async {
    String email = FirebaseAuth.instance.currentUser.email;
    await User_Info().getUserInfo(email).then((userSnapshot) {
      name = userSnapshot.docs[0].data()['name'].toString();
      imageUrl = userSnapshot.docs[0].data()['imageUrl'].toString();
      course = userSnapshot.docs[0].data()['course'].toString();
      batch = userSnapshot.docs[0].data()['batch'].toString();
      collegeId = userSnapshot.docs[0].data()['collegeId'].toString();
      dob = userSnapshot.docs[0].data()['dob'].toString();
      bloodGroup = userSnapshot.docs[0].data()['bloodGroup'].toString();
      contact = userSnapshot.docs[0].data()['contact'].toString();
      fatherName = userSnapshot.docs[0].data()['father\'sName'].toString();
      motherName = userSnapshot.docs[0].data()['mother\'sName'].toString();
      // print(userSnapshot.docs[0].data()['imageUrl'].toString());
      setState(() {
        snapshots = userSnapshot;
      });
      print('\n\n$snapshots\n\n');
    });
  }

  Widget detailRow(String rightText, String leftText, BuildContext context) {
    return Container(
      height: 40,
      child: Row(
        children: [
          Container(
            width: MediaQuery.of(context).size.width * 0.4,
            child: Text(
              rightText,
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
          Expanded(
            child: Text(
              leftText,
              style: TextStyle(
                color: Color(0xff473f97),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget changePasswordContainer() {
    return Expanded(
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.only(bottom: 30, left: 20, right: 20),
        color: Colors.white,
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20),
              TextFormField(
                controller: newPasswordTextEditingController,
                validator: (value) {
                  if (value.isEmpty || value.length < 8) {
                    return 'Enter atleast 8 characters';
                  }
                  return null;
                },
                decoration: InputDecoration(
                  labelText: 'New Password',
                  labelStyle: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey[400],
                  ),
                  focusedBorder: InputBorder.none,
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(horizontal: 5),
                ),
                cursorColor: Color(0xff473f97),
                cursorHeight: 25,
                textAlignVertical: TextAlignVertical.center,
                obscureText: true,
                // showCursor: false,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[700],
                ),
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: confirmPasswordTextEditingController,
                validator: (value) {
                  if (value.isEmpty ||
                      value != newPasswordTextEditingController.text) {
                    return 'Passwords doesn\'t match';
                  }
                  return null;
                },
                decoration: InputDecoration(
                  labelText: 'Confirm Password',
                  labelStyle: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey[400],
                  ),
                  focusedBorder: InputBorder.none,
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(horizontal: 5),
                ),
                cursorColor: Color(0xff473f97),
                cursorHeight: 25,
                textAlignVertical: TextAlignVertical.center,
                obscureText: true,
                // showCursor: false,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w400,
                  color: Colors.grey[700],
                ),
              ),
              SizedBox(height: 50),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: snapshots != null
          ? SingleChildScrollView(
              child: Container(
                // padding: EdgeInsets.only(top: 20),
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: Column(
                  children: [
                    ClipPath(
                      clipper: MyClipper(),
                      child: Container(
                        color: Color(0xff473f97),
                        height: MediaQuery.of(context).size.height * 0.45,
                        width: MediaQuery.of(context).size.width,
                        child: Column(
                          children: [
                            Container(
                              child: Expanded(
                                child: Stack(
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                        // color: const Color(0xff7c94b6),
                                        image: DecorationImage(
                                          fit: BoxFit.cover,
                                          colorFilter: ColorFilter.mode(
                                              Colors.black.withOpacity(0.2),
                                              BlendMode.dstATop),
                                          image: AssetImage(
                                            'assets/calendar.png',
                                          ),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      width: MediaQuery.of(context).size.width,
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.45,
                                      // alignment: Alignment.center,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Container(
                                            padding: EdgeInsets.all(10),
                                            height: 90,
                                            width: 90,
                                            child: Image.network(imageUrl,
                                                fit: BoxFit.contain),
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: Colors.white,
                                              // backgroundBlendMode: BlendMode.color,
                                            ),
                                          ),
                                          SizedBox(height: 15),
                                          Text(
                                            name,
                                            style: TextStyle(
                                              fontSize: 18,
                                              color: Colors.white,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          SizedBox(height: 5),
                                          Text(
                                            course,
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.white,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          SizedBox(height: 5),
                                          Text(
                                            '<${batch}>',
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.white,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SafeArea(
                                      child: Container(
                                        height: 60,
                                        width:
                                            MediaQuery.of(context).size.width,
                                        child: ListTile(
                                          // tileColor: Colors.transparent,
                                          leading: IconButton(
                                            icon: Icon(Icons.arrow_back_ios),
                                            color: Colors.white,
                                            highlightColor: Colors.white10,
                                            splashColor: Colors.white10,
                                            onPressed: () =>
                                                Navigator.pop(context),
                                          ),
                                          title: Text(
                                            'Profile',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 18),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                // ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    _isChangePassword
                        ? changePasswordContainer()
                        : Expanded(
                            child: SingleChildScrollView(
                              child: Container(
                                width: MediaQuery.of(context).size.width,
                                padding: EdgeInsets.only(
                                    bottom: 30, left: 20, right: 20),
                                color: Colors.white,
                                child: SingleChildScrollView(
                                  child: Column(
                                    // shrinkWrap: true,
                                    // mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      detailRow(
                                          'College ID', collegeId, context),
                                      Divider(
                                        thickness: 2,
                                      ),
                                      detailRow('Date of Birth', dob, context),
                                      Divider(
                                        thickness: 2,
                                      ),
                                      detailRow(
                                          'Blood Group', bloodGroup, context),
                                      Divider(
                                        thickness: 2,
                                      ),
                                      detailRow('Emergency Contact', contact,
                                          context),
                                      Divider(
                                        thickness: 2,
                                      ),
                                      detailRow('Father\'s Name', fatherName,
                                          context),
                                      Divider(
                                        thickness: 2,
                                      ),
                                      detailRow('Mother\'s Name', motherName,
                                          context),
                                      // Divider(
                                      //   thickness: 2,
                                      // ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                    SizedBox(height: 30),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 30),
                      height: 50,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _isChangePassword
                              ? Expanded(
                                  child: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        _isChangePassword = false;
                                        newPasswordTextEditingController.text =
                                            '';
                                        confirmPasswordTextEditingController
                                            .text = '';
                                      });
                                    },
                                    child: Container(
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                        color: Color(0xfffd3667),
                                        borderRadius: BorderRadius.circular(30),
                                      ),
                                      child: Text(
                                        'Cancel',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ),
                                  ),
                                )
                              : Container(),
                          _isChangePassword ? SizedBox(width: 20) : Container(),
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                _isChangePassword
                                    ? _submit(context)
                                    : setState(() {
                                        _isChangePassword = true;
                                      });
                              },
                              child: Container(
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: Color(0xfffd3667),
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                child: Text(
                                  _isChangePassword
                                      ? 'Save'
                                      : 'Change Password',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 30),
                  ],
                ),
              ),
            )
          : Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              color: Color(0xff473f97),
              child: Center(
                child: CircularProgressIndicator(),
              ),
            ),
    );
  }
}
