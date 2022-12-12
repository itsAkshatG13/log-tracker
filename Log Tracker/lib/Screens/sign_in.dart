import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:log_tracker/Constants/preferences.dart';
import 'package:log_tracker/Models/user.dart';
import 'package:log_tracker/Screens/dashboard.dart';
import 'package:log_tracker/Screens/register_user.dart';
import 'package:log_tracker/Utilities/screen_utils.dart';
import 'package:log_tracker/main.dart';
import 'package:path/path.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({Key? key}) : super(key: key);

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  TextEditingController userNameCont = TextEditingController();
  TextEditingController passCont = TextEditingController();
  late SharedPreferences prefs;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCameras();
    dbConnection();
  }

  void getCameras() async
  {
    if(cameras.isEmpty)
      {
        await [Permission.camera, Permission.microphone,Permission.storage,Permission.manageExternalStorage].request();
        cameras = await availableCameras();
      }
  }

  void dbConnection() async
  {
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, "my_db.db");
    try {
      db = await openDatabase(path);
      print("DB OPENED ${db}");
      await db.execute("CREATE TABLE IF NOT EXISTS LOG_USERS(USERNAME TEXT PRIMARY KEY, EMAIL TEXT, PASSWORD TEXT, USER_TYPE TEXT)");
      print("table create -> LOG_USERS");
      var length = Sqflite
          .firstIntValue(await db.rawQuery('SELECT COUNT(*) FROM LOG_USERS'));
      if(length!<=0)
        {
          await db.rawInsert("INSERT INTO LOG_USERS VALUES('logtrackeradmin','1234@','Tr@cker@Log2021','admin')");
          await db.rawInsert("INSERT INTO LOG_USERS VALUES('singhadminchandan','1234@','Singh@dmin2021','admin')");
          await db.rawInsert("INSERT INTO LOG_USERS VALUES('user1','1234@','1234','admin')");
          await db.rawInsert("INSERT INTO LOG_USERS VALUES('user2','1234@','1234','user')");
          print("ADMIN_USERS_INSERTED");
          if(users.isEmpty)
            {
              List<Map> userList = await db.rawQuery('SELECT * FROM LOG_USERS');
              users = [];
              for (int i = 0; i < userList.length; i++) {
                users.add(User(
                    userName: userList[i]["USERNAME"].toString(),
                    email: userList[i]["EMAIL"].toString(),
                    password: userList[i]["PASSWORD"].toString(),
                    userType: userList[i]["USER_TYPE"].toString()
                ));
              }
            }
        }
      else
        {
          print("ADMIN_USERS_FOUND");
          List<Map> userList = await db.rawQuery('SELECT * FROM LOG_USERS');
          users = [];
          for (int i = 0; i < userList.length; i++) {
            users.add(User(
                userName: userList[i]["USERNAME"].toString(),
                email: userList[i]["EMAIL"].toString(),
                password: userList[i]["PASSWORD"].toString(),
                userType: userList[i]["USER_TYPE"].toString()
            ));
          }
        }
    } catch (e) {
      print("Error $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Log Tracker"),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Image.asset("assets/icons/company.png"),
              TextField(
                decoration: const InputDecoration(
                    border: UnderlineInputBorder(
                        borderSide:BorderSide(
                            color: Colors.black
                        )
                    ),
                    hintText: "User Name"
                ),
                controller: userNameCont,
              ),
              TextField(
                obscureText: true,
                decoration: const InputDecoration(
                    border: UnderlineInputBorder(
                        borderSide:BorderSide(
                            color: Colors.black
                        )
                    ),
                  hintText: "Password"
                ),
                controller: passCont,
              ),
              const SizedBox(height : 20),
              Container(
                width: ScreenUtils.screenWidth(context)*0.8,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20)
                ),
                child: MaterialButton(
                    onPressed: (){
                  String id = userNameCont.text.trim();
                  String pass = passCont.text.trim();
                  if(userNameCont.text=="" || passCont.text=="")
                    {
                      print("Empty");
                      Fluttertoast.showToast(msg: "Fields cannot be empty",backgroundColor: Colors.red);
                      return;
                    }
                  print("LEN ${users.length}");
                  for(int i = 0; i< users.length;i++)
                    {
                      if(users[i].userName == id)
                        {
                          if(users[i].password==pass)
                            {
                              accountType = users[i].userType;
                              accountUserName = users[i].userName;
                              setPrefValue(users[i].userType);
                              loggedIn = true;
                              Navigator.push(context, MaterialPageRoute(builder: (context)=> Dashboard()));
                              break;
                            }
                          else
                            {
                              Fluttertoast.showToast(msg: "Password invalid");
                              print("Invalid password entered");
                              return;
                            }
                        }
                      else
                        {
                          print("USERS $users");
                        }
                    }
                  },
                    elevation: 0,
                    color: Colors.black,
                    child: const Text("Sign In",style: TextStyle(color: Colors.white,fontSize: 18),)),
              )
            ],
          ),
        ),
      ),
    );
  }
  
  void setPrefValue(String? type) async
  {
    prefs = await SharedPreferences.getInstance();
    prefs.setString(USERNAME,userNameCont.text.trim());
    prefs.setString(PASSWORD,passCont.text.trim());
    prefs.setString(ACCOUNT_TYPE,type!);
    prefs.setBool(LOGGED_IN, true);
  }
}
