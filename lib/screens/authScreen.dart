import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:niet_app/Widgets/ClipPath.dart';
import 'package:niet_app/database/auth_services/auth_services.dart';
import 'package:niet_app/model/user_model.dart';
import 'package:niet_app/model/users.dart';
import 'package:niet_app/screens/DashBoard.dart';

class AuthScreen extends StatefulWidget {
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  TextEditingController universityRollNoTextEditingController =
      new TextEditingController();

  TextEditingController passwordTextEditingController =
      new TextEditingController();

  // bool _isForgotPassword = false;

  final formKey = GlobalKey<FormState>();

  AuthServices _authServices = new AuthServices();

  void _submit(BuildContext context) async {
    final isValid = formKey.currentState.validate();
    FocusScope.of(context).unfocus();

    if (isValid) {
      // if (_isForgotPassword) {
      //   await _authServices.sendPasswordResetMail(
      //       universityRollNoTextEditingController.text + '@niet.co.in',
      //       context);
      // } else {
      await _authServices
          .signInWithEmail(
              universityRollNoTextEditingController.text + '@niet.co.in',
              passwordTextEditingController.text,
              context)
          .then((result) async {
        UserModel.universityRollNo = universityRollNoTextEditingController.text;
        if (result != null) {
          // QuerySnapshot userInfoSnapshot =
          //     await DatabaseServices().getUsersByUserEmail(universityRollNoTextEditingController.text);

          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => DashBoard()));

          print('\n\n$result\n\n\n');
          // print('${user.}');
          print('\n\n${UserModel.universityRollNo}\n\n');
          print('\n\n${universityRollNoTextEditingController.text}\n\n');
          print('\n\n${FirebaseAuth.instance.currentUser.displayName}\n\n');
        }
      });
      // }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
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
                  height: MediaQuery.of(context).size.height * 0.5,
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
                                    MediaQuery.of(context).size.height * 0.5,
                                // alignment: Alignment.center,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Container(
                                      // padding: EdgeInsets.all(10),
                                      height: 90,
                                      width: 90,
                                      child: Image.asset('assets/niet_logo.png',
                                          fit: BoxFit.contain),
                                    ),
                                  ],
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
              Expanded(
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
                        Text(
                          'University Roll no',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.black,
                          ),
                        ),
                        TextFormField(
                          controller: universityRollNoTextEditingController,
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Enter a valid University Roll no';
                            }

                            return null;
                          },
                          decoration: InputDecoration(
                            hintText: '1901330100071',
                            hintStyle: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                              color: Colors.grey[400],
                            ),
                            focusedBorder: InputBorder.none,
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(horizontal: 5),
                          ),
                          cursorColor: Color(0xff473f97),
                          keyboardType: TextInputType.emailAddress,
                          cursorHeight: 25,
                          textAlignVertical: TextAlignVertical.center,
                          // showCursor: false,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey[700],
                          ),
                        ),
                        SizedBox(height: 20),
                        // _isForgotPassword
                        // ? Container()
                        // :
                        Text(
                          'Password',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.black,
                          ),
                        ),
                        // _isForgotPassword
                        // ? Container()
                        // :
                        TextFormField(
                          controller: passwordTextEditingController,
                          validator: (value) {
                            if (value.isEmpty || value.length < 8) {
                              return 'Enter atleast 8 characters';
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            hintText: 'Enter Password',
                            hintStyle: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                              color: Colors.grey[400],
                            ),
                            focusedBorder: InputBorder.none,
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(horizontal: 5),
                          ),
                          cursorColor: Color(0xff473f97),
                          keyboardType: TextInputType.emailAddress,
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
                              // _isForgotPassword ? 'Reset Password' :
                              'Sign In',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500),
                            ),
                          ),
                          onTap: () {
                            _submit(context);

                            // setState(() {
                            //   UserModel().universityRollNo =
                            //       universityRollNoTextEditingController.text;
                            // });
                          },
                        ),
                        SizedBox(height: 40),
                        // Align(
                        //   alignment: Alignment.centerRight,
                        //   child: TextButton(
                        //     child: Text(
                        //       _isForgotPassword ? 'Sign In' : 'Forgot Password',
                        //       textAlign: TextAlign.right,
                        //       style: TextStyle(
                        //         color: Color(0xff473f97),
                        //       ),
                        //     ),
                        //     onPressed: () => setState(() {
                        //       universityRollNoTextEditingController.text = '';
                        //       passwordTextEditingController.text = '';
                        //       _isForgotPassword = !_isForgotPassword;
                        //     }),
                        //   ),
                        // ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}
