import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:log_tracker/Models/tracks.dart';
import 'package:log_tracker/Utilities/screen_utils.dart';
import 'package:log_tracker/main.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';

class CheckedTracksScreen extends StatefulWidget {
  const CheckedTracksScreen({Key? key}) : super(key: key);

  @override
  State<CheckedTracksScreen> createState() => _CheckedTracksScreenState();
}

class _CheckedTracksScreenState extends State<CheckedTracksScreen> {

  final pdfDoc = pw.Document();
  final ScrollController _scrollController = ScrollController();
  List x = [];

  @override
  void initState() {
    getDbData();
    // TODO: implement initState
    super.initState();
  }

  void getDbData() async
  {
    List<Map> trackTemp = [];
    if(accountType == "admin")
      {
        x = await db.rawQuery('SELECT name FROM sqlite_master WHERE type="table" AND name="LOGS"');
        print("LOGS TABLE ${x.length}");
        if(x.length!=0)
          {
            trackTemp = await db.rawQuery('SELECT * FROM LOGS');
          }
        }
    else
      {
        trackTemp = await db.rawQuery('SELECT * FROM LOGS WHERE user_id="${accountUserName}"');
      }
    tracks = [];
    for (int i = 0; i < trackTemp.length; i++) {
      tracks.add(Tracks(
          userName: trackTemp[i]["user_id"].toString()??"",
          machineImage: trackTemp[i]["machine_image"].toString()??"",
          selfieImage: trackTemp[i]["selfie_image"].toString()??"",
          logData: trackTemp[i]["log_data"].toString()??"",
          captureDate: trackTemp[i]["date"].toString()??""
      ));
    }
    setState(() {
    });
  }

  @override
  Widget build(BuildContext context) {
    if(x.isEmpty && tracks.isEmpty)
      {
        //Fluttertoast.showToast(msg: "No checked tracks!");
      }
    return Scaffold(
      appBar: AppBar(
        title: const Text("Checked Tracks"),
        centerTitle: true,
        leading: IconButton(onPressed: (){Navigator.pop(context);}, icon: const Icon(Icons.arrow_back,color: Colors.white,)),
      ),
      body: tracks.isEmpty ?
       const Center(child: CircularProgressIndicator(color: Colors.black,))
          :
      SingleChildScrollView(
        physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
        child: Column(
          children: [
            ListView.builder(
              controller: _scrollController ,
              itemBuilder: (context,index){
                return tracks.isNotEmpty ?
                checkedDataWidget(
                    tracks[index].userName.toString(),
                    base64Decode(tracks[index].machineImage),
                    base64Decode(tracks[index].selfieImage),
                    tracks[index].logData,
                    tracks[index].captureDate)
                    :
                Container();
              },
              itemCount: tracks!=null && tracks.isNotEmpty ? tracks.length : 0 ,
              shrinkWrap: true,
            ),
            const SizedBox(height: 50,),
          ],
        ),
      ),
    );
  }

  Widget checkedDataWidget(String userName ,Uint8List machine_image, Uint8List selfie_image, String logData, String date)
  {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: ScreenUtils.screenWidth(context)*0.4,
                child: const Center(child: Text("Machine Image",style: TextStyle(fontSize: 17,fontWeight: FontWeight.bold),)),),
              const SizedBox(width: 20,),
              accountType=="admin" ?
              SizedBox(
                width: ScreenUtils.screenWidth(context)*0.4,
                child: const Center(child: Text("Selfie Image",style: TextStyle(fontSize: 17,fontWeight: FontWeight.bold))),) : Container(),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.memory(machine_image,height:ScreenUtils.screenHeight(context)*0.4 ,width: ScreenUtils.screenWidth(context)*0.4,),
              const SizedBox(width: 20,),
              accountType=="admin" ? Image.memory(selfie_image,height:ScreenUtils.screenHeight(context)*0.4 ,width: ScreenUtils.screenWidth(context)*0.4,) : Container(),
            ],
          ),
          Text("${logData+" \nDate : "+date + "\nUsername : "+userName}",style: TextStyle(fontSize: 15),),
          const SizedBox(height: 15,),
          accountType=="admin"?
          MaterialButton(onPressed: () async {
            createPdf(context, machine_image, selfie_image, logData, date, userName);
            String timeStamp = DateTime.now().millisecondsSinceEpoch.toString();
            //final file = File('logs_$timeStamp.pdf');
            print("created");
            String directory = (await getApplicationDocumentsDirectory()).path;
            final file = File('$directory/logs_$timeStamp.pdf');
            await file.writeAsBytes(await pdfDoc.save()).then((value){
              print("done");
              OpenFile.open('$directory/logs_$timeStamp.pdf');
            });

          },
            color: Colors.black,
            minWidth: ScreenUtils.screenWidth(context)*0.6,
            child: const Text("Download Report",style: TextStyle(color: Colors.white),),)
              :
          Container(),
          Container(height: 1,width: ScreenUtils.screenWidth(context)*0.95,color: Colors.black,)
        ],
      ),
    );
  }

  Future<void> createPdf(BuildContext buildContext, Uint8List machine_image, Uint8List selfie_image, String logData, String date, String username) async {
    final machineImage = pw.MemoryImage(machine_image,);
    final selfieImage = pw.MemoryImage(selfie_image,);
    print("IN ADD PAGE");
    pdfDoc.addPage(
        pw.Page(
        build: (pw.Context context) => pw.Center(
          child: pw.Container(
            child: pw.Column(
              mainAxisAlignment: pw.MainAxisAlignment.start,
              children: [
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.center,
                  children: [
                    pw.SizedBox(
                      width: ScreenUtils.screenWidth(buildContext)*0.4,
                      child:  pw.Center(child: pw.Text("Machine Image",style: const pw.TextStyle(fontSize: 17,),)),),
                    pw.SizedBox(width: 20,),
                    pw.SizedBox(
                      width: ScreenUtils.screenWidth(buildContext)*0.4,
                      child: pw.Center(child: pw.Text("Selfie Image",style: const pw.TextStyle(fontSize: 17,))),),
                  ],
                ),
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.center,
                  children: [
                    pw.Image(machineImage,fit: pw.BoxFit.contain),
                    pw.SizedBox(width: 20,),
                    pw.Image(selfieImage,fit: pw.BoxFit.contain),
                  ],
                ),
                pw.SizedBox(height: 50),
                pw.Text("${logData+" \nDate : "+date+"\nUserName : "+username}",style: const pw.TextStyle(fontSize: 18),),
              ],
            ),
          )
        ),
      )
    );
  }
}
