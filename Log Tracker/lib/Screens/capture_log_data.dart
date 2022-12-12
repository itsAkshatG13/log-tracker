
import 'dart:convert';
import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:log_tracker/Utilities/screen_utils.dart';
import 'package:log_tracker/main.dart';
import 'package:sqflite/sqflite.dart';
class CameraPage extends StatefulWidget {
  const CameraPage({Key? key}) : super(key: key);

  @override
  _CameraPageState createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
   CameraController controller = CameraController(cameras[0], ResolutionPreset.low);
   XFile? imageFile;

  @override
  void initState() {
    super.initState();
    controller?.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
    });
  }

  @override
  void dispose() {
    if(controller!=null) {
      controller.dispose();
    }
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:
      imageFile == null ?
      Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
              height: ScreenUtils.screenHeight(context)*0.9,
              child: CameraPreview(controller,)),
          Container(
            height: 70,
            width: 70,
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(100)
            ),
            child: InkWell(
              onTap: (){
                print("Camera clicked");
                controller != null && controller.value.isInitialized ?
                onTakePictureButtonPressed()
                    : null;
              },
              child: const Icon(Icons.camera_alt,size: 40,color: Colors.white,),
            ),
          )
        ],
      )
      :
      Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          SizedBox(
            height: ScreenUtils.screenHeight(context)*0.9,
            child: Image.file(File(imageFile!.path)),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              MaterialButton(
                minWidth: ScreenUtils.screenWidth(context)*0.4,
                onPressed: (){
                  print("IN_TAP=>imagefile==null");
                  //controller.stopImageStream();
                  controller.dispose();
                  Navigator.pop(context,null);
              },
                color: Colors.black,
                child: const Text("Retry",style: TextStyle(color: Colors.white),),
              ),
              MaterialButton(
                minWidth: ScreenUtils.screenWidth(context)*0.4,
                onPressed: (){
                Navigator.pop(context,imageFile);
                //Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>QrDataScreen()));
              },
                color: Colors.black,
                child: const Text("Ok",style: TextStyle(color: Colors.white),),
              ),
            ],
          )
        ],
      ),
    );
  }


   void onTakePictureButtonPressed() {
     takePicture().then((XFile? file) {
       if (mounted) {
         setState(() {
           imageFile = file;
         });
         if (file != null) {
           //Future.delayed(Duration(milliseconds: 200));
           //controller.stopImageStream();
           print("CAPTURED");
         }
       }
     });
   }

   Future<XFile?> takePicture() async {
     final CameraController? cameraController = controller;
     if (cameraController == null || !cameraController.value.isInitialized) {
       Fluttertoast.showToast(msg: "Error Camera",backgroundColor: Colors.red);
       return null;
     }

     if (cameraController.value.isTakingPicture) {
       return null;
     }

     try {
       XFile file = await cameraController.takePicture();
       return file;
     } on CameraException catch (e) {
       _showCameraException(e);
       return null;
     }
}

   void _showCameraException(CameraException e) {
     print("${e.code}, ${e.description}");
     Fluttertoast.showToast(msg:'Error: ${e.code}\n${e.description}',backgroundColor: Colors.red);
   }
}

