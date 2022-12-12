import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:log_tracker/Utilities/screen_utils.dart';
import 'package:log_tracker/main.dart';

class AdminControlScreen extends StatefulWidget {
  const AdminControlScreen({Key? key}) : super(key: key);

  @override
  _AdminControlScreenState createState() => _AdminControlScreenState();
}

class _AdminControlScreenState extends State<AdminControlScreen> {

  bool loader = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Admin Control",style: TextStyle(fontSize: 17,color: Colors.white),),
        leading: IconButton(onPressed: (){Navigator.pop(context);}, icon: const Icon(Icons.arrow_back,color: Colors.white,)),
        backgroundColor: Colors.black,
      ),
      body: loader == true ?
      const Center(child: CircularProgressIndicator(color: Colors.black,))
          :
      SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 50),
            ListView.builder(itemBuilder: (context,index)
            {
              return Padding(
                padding: const EdgeInsets.all(20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Text("UserName : ",style: TextStyle(fontWeight: FontWeight.bold),),
                            Text("${users?[index].userName}"),
                          ],
                        ),
                        Row(
                          children: [
                            const Text("Type : ",style: TextStyle(fontWeight: FontWeight.bold)),
                            Text("${users?[index].userType}"),
                          ],
                        ),
                      ],
                    ),
                    Spacer(),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        users?[index].userName == accountUserName ?
                        const Text("Active",style: TextStyle(color: Colors.grey,fontSize: 16,fontStyle: FontStyle.italic),)
                            :
                        MaterialButton(onPressed: () async {
                          loader = true;
                          setState(() {
                          });
                          // Delete a record
                          var count = await db.rawDelete('DELETE FROM LOG_USERS WHERE USERNAME = "${users[index].userName}"');
                          assert(count == 1);
                          if(count == 1)
                          {
                            loader = false;
                            Fluttertoast.showToast(msg: "User deleted",backgroundColor: Colors.green);
                            users.removeWhere((element) => element.userName==users[index].userName);
                            setState(() {
                            });
                          }
                          else
                          {
                            Fluttertoast.showToast(msg: "Unable to delete",backgroundColor: Colors.green);
                          }
                        },
                          color: Colors.black,
                          minWidth: ScreenUtils.screenWidth(context)*0.2,
                          child: const Text("Delete",style: TextStyle(color: Colors.white,fontSize: 16),),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20,)
                  ],
                ),
              );
            },
              itemCount: users!=null? users.length : 0,
              shrinkWrap: true,
            ),
          ],
        ),
      ),
    );
  }
}
