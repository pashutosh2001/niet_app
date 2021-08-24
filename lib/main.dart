import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:niet_app/database/user_info/user_info.dart';
import 'package:niet_app/model/user_model.dart';
import 'package:niet_app/screens/Loading_Screen.dart';
import 'package:niet_app/screens/authScreen.dart';
import 'screens/DashBoard.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'NIET App',
      theme: ThemeData(
          // scaffoldBackgroundColor: Color(0xff473f97),
          // primarySwatch: ,
          ),
      home: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (ctx, userSnapshot) {
            if (userSnapshot.connectionState == ConnectionState.waiting) {
              return LoadingScreen();
            }
            if (userSnapshot.hasData) {
              return DashBoard();
            }
            return AuthScreen();
          }),
    );
  }
}
