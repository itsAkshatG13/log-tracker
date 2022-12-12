import 'package:flutter/material.dart';
import 'package:log_tracker/Constants/preferences.dart';
import 'package:log_tracker/Screens/admin_control.dart';
import 'package:log_tracker/Screens/checked_tracks.dart';
import 'package:log_tracker/Screens/register_user.dart';
import 'package:log_tracker/Screens/scan_qr.dart';
import 'package:log_tracker/Screens/sign_in.dart';
import 'package:log_tracker/Utilities/screen_utils.dart';
import 'package:log_tracker/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Dashboard extends StatelessWidget {
  Dashboard({Key? key}) : super(key: key);
  late SharedPreferences prefs;

  void getPrefValues() async
  {
    prefs = await SharedPreferences.getInstance();
    accountType = prefs.getString(ACCOUNT_TYPE).toString();
    accountUserName=prefs.getString(USERNAME).toString();

  }

  @override
  Widget build(BuildContext context) {
    if(accountType==null || accountType=="")
      {
        getPrefValues();
      }
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: AppBar(
          title: const Center(child: Text("Home",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16),)),
          actions: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  children: [
                    const SizedBox(width:20,),
                    InkWell(
                      onTap: () async{
                        accountType="";
                        accountUserName="";
                        prefs = await SharedPreferences.getInstance();
                        prefs.setString(USERNAME,"");
                        prefs.setString(PASSWORD,"");
                        prefs.setString(ACCOUNT_TYPE,"");
                        prefs.setBool(LOGGED_IN, false);
                        loggedIn = false;
                        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>const SignInScreen()), (route) => false);
                      },
                      child: const Text("Logout",style: TextStyle(fontSize: 15),),
                    ),
                  ],
                ),
              ],
            )
          ],
          leading: Container(),
        ),
        body: SingleChildScrollView(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children : [
                const SizedBox(height: 120,),
                accountType!="" && accountType!="admin"?
                Column(
                  children: [
                    Ink(
                      height: ScreenUtils.screenHeight(context)*0.2,
                      width: ScreenUtils.screenWidth(context)*0.5,
                      child: InkWell(
                        child: Image.asset("assets/icons/scanqr.png",),
                      onTap: () {
                        Navigator.push(context,MaterialPageRoute(builder: (context)=> const ScanQrScreen()));
                        // await showDialog(context: context, builder: (_) => cameraDialogBox(context),);
                      },),
                    ),
                    const SizedBox(height: 12),
                    const Text("Scan Track",style: TextStyle(fontSize: 17,color: Colors.black),)
                  ],
                )
                    :
                Container(),
                const SizedBox(height: 80,),
                Column(
                  children: [
                    Ink(
                      height: ScreenUtils.screenHeight(context)*0.2,
                      width: ScreenUtils.screenWidth(context)*0.5,
                      child: InkWell(
                        child: Image.asset("assets/icons/checked_tracks.png"),
                        onTap: (){
                          Navigator.push(context,MaterialPageRoute(builder: (context)=>const CheckedTracksScreen()));
                        },
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text("Checked Tracks",style: TextStyle(fontSize: 17,color: Colors.black),)
                  ],
                ),
                const SizedBox(height: 100,),
                accountType!="" && accountType=="admin"?
                Column(
                  children: [
                    MaterialButton(
                      minWidth: ScreenUtils.screenWidth(context)*0.7,
                      onPressed: (){
                        Navigator.push(context,MaterialPageRoute(builder: (context)=>const RegisterUserScreen()));
                      },
                      color: Colors.black,
                      child: const Text("Add New User",style: TextStyle(fontSize: 18,color: Colors.white),)
                    ),
                    const SizedBox(height: 50,),
                    MaterialButton(
                        minWidth: ScreenUtils.screenWidth(context)*0.7,
                        onPressed: (){
                          Navigator.push(context,MaterialPageRoute(builder: (context)=>const AdminControlScreen()));
                        },
                        color: Colors.black,
                        child: const Text("Admin Control",style: TextStyle(fontSize: 18,color: Colors.white),)
                    ),
                  ],
                )
                    :
                Container(),
              ]
            ),
          ),
        ),
      ),
    );
  }


}
