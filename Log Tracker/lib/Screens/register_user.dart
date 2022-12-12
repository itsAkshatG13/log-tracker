import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:log_tracker/Utilities/screen_utils.dart';
import 'package:log_tracker/main.dart';

class RegisterUserScreen extends StatefulWidget {
  const RegisterUserScreen({Key? key}) : super(key: key);

  @override
  _RegisterUserScreenState createState() => _RegisterUserScreenState();
}

class _RegisterUserScreenState extends State<RegisterUserScreen> {
  TextEditingController userNameCont = TextEditingController();
  TextEditingController designationCont = TextEditingController();
  TextEditingController departmentCont = TextEditingController();
  TextEditingController emailIdCont = TextEditingController();
  TextEditingController passCont = TextEditingController();
  TextEditingController confirmPassCont = TextEditingController();
  String radioGroup = 'user';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: (){
              Navigator.pop(context);
            },
            icon:const Icon(Icons.arrow_back_ios)),
        backgroundColor: Colors.black,
        title: const Text("Log Tracker"),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Image.asset("assets/icons/company.png"),
              const SizedBox(height: 10,),
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
              const SizedBox(height: 10,),
              TextField(
                decoration: const InputDecoration(
                    border: UnderlineInputBorder(
                        borderSide:BorderSide(
                            color: Colors.black
                        )
                    ),
                    hintText: "Designation"
                ),
                controller: designationCont,
              ),
              const SizedBox(height: 10,),
              TextField(
                decoration: const InputDecoration(
                    border: UnderlineInputBorder(
                        borderSide:BorderSide(
                            color: Colors.black
                        )
                    ),
                    hintText: "Department"
                ),
                controller: departmentCont,

              ),
              const SizedBox(height: 10,),
              TextField(
                decoration: const InputDecoration(
                    border: UnderlineInputBorder(
                        borderSide:BorderSide(
                            color: Colors.black
                        )
                    ),
                    hintText: "Email"
                ),
                controller: emailIdCont,
              ),
              const SizedBox(height: 10,),
              const Center(
                child: Text("User type",style: TextStyle(fontSize: 16),
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        const Text("Admin"),
                        Radio(
                          value: 'admin',
                          groupValue: radioGroup,
                          onChanged: (value){
                            radioGroup = value.toString();
                            setState(() {
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const Text("User"),
                        Radio(
                          value: 'user',
                          groupValue: radioGroup,
                          onChanged: (value){
                            radioGroup = value.toString();
                            setState(() {
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                ],
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
              const SizedBox(height: 10,),
              TextField(
                obscureText: true,
                decoration: const InputDecoration(
                    border: UnderlineInputBorder(
                        borderSide:BorderSide(
                            color: Colors.black
                        )
                    ),
                    hintText: "Confirm Password"
                ),
                controller: confirmPassCont,
              ),
              const SizedBox(height: 30,),
              Container(
                width: ScreenUtils.screenWidth(context)*0.8,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20)
                ),
                child: MaterialButton(onPressed: (){
                  if(userNameCont.text=="" || designationCont.text=="" ||
                      departmentCont.text=="" || radioGroup=="" || radioGroup=="" || passCont.text==""
                   || confirmPassCont.text=="")
                    {
                      Fluttertoast.showToast(msg: "Required fields empty",backgroundColor: Colors.red);
                      return;
                    }
                  if(passCont.text.trim()!=confirmPassCont.text.trim())
                    {
                      Fluttertoast.showToast(msg: "Password does not match",backgroundColor: Colors.red);
                      return;
                    }
                  else{
                    insertData(userNameCont.text.trim(),emailIdCont.text.trim(),passCont.text.trim(),radioGroup);
                    Future.delayed(const Duration(milliseconds: 100));
                    Navigator.pop(context);
                  }
                  //Navigator.pushReplacement(context,MaterialPageRoute(builder: (context)=> const Dashboard()));
                },
                    elevation: 0,
                    color: Colors.black,
                    child: const Text("Add New User",style: TextStyle(color: Colors.white,fontSize: 18),)),
              )
            ],
          ),
        ),
      ),
    );
  }

  void insertData(String userName, String email, String password, String type) async
  {
    await db.rawInsert("INSERT INTO LOG_USERS VALUES('${userName}','${email}','${password}','${type}')");
    print("added_new_user");
    Fluttertoast.showToast(msg: "New user added",backgroundColor: Colors.green);
  }

}
