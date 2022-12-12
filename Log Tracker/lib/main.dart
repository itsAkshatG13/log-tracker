import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:log_tracker/Constants/preferences.dart';
import 'package:log_tracker/Models/tracks.dart';
import 'package:log_tracker/Models/user.dart';
import 'package:log_tracker/Screens/dashboard.dart';
import 'package:log_tracker/Screens/sign_in.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

List<CameraDescription> cameras = [];
var db;
bool loggedIn = false;
String accountType="";
String accountUserName="";
List<Map> userList =[];
List<Map> trackList =[];
List<User> users = [];
List<Tracks> tracks = [];


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);
  late SharedPreferences prefs;
  @override
  Widget build(BuildContext context) {
    getPrefValues();
    return MaterialApp(
      title: 'Log Tracker',
      theme: ThemeData(
        appBarTheme: const AppBarTheme(backgroundColor: Colors.black,
            titleTextStyle: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 18)),
        primarySwatch: Colors.blue,
      ),
      home: const SignInScreen(),
      debugShowCheckedModeBanner: false,
    );
  }

  void getPrefValues() async{
    try
    {
      prefs = await SharedPreferences.getInstance();
      loggedIn = prefs.getBool(LOGGED_IN)?? false;
    }
    catch(e)
    {
      SharedPreferences.setMockInitialValues({});
    }
  }
}
