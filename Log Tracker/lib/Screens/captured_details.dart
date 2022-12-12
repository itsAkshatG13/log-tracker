import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:log_tracker/Screens/dashboard.dart';

class CapturedDetailsScreen extends StatelessWidget {
  XFile file;
  XFile selfie;
  String data;
  CapturedDetailsScreen({Key? key,required this.file,required this.selfie,required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async=> false,
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: (){
              Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>Dashboard()),(route) => false);
            },
              icon:const Icon(Icons.arrow_back_ios)),
          backgroundColor: Colors.black,
          title: const Text("Details",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold ),),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(height: 50,),
            Center(child: Image.file(File(file!.path),)),
            const SizedBox(height: 40,),
            Center(
              child: Container(
                  padding: const EdgeInsets.all(30),
                  child: Text("$data",style:const TextStyle(fontSize: 18))),
            )
          ],
        ),
      ),
    );
  }
}
