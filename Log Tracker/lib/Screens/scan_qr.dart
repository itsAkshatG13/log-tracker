import 'dart:developer';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:log_tracker/Constants/preferences.dart';
import 'package:log_tracker/Screens/qr_data.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ScanQrScreen extends StatefulWidget {
  const ScanQrScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ScanQrScreenState();
}

class _ScanQrScreenState extends State<ScanQrScreen> {
  Barcode? result;
  QRViewController? qrController;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  late SharedPreferences prefs ;


  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid && qrController!=null) {
      qrController!.pauseCamera();
    }
    if(qrController!=null) {
      qrController!.resumeCamera();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Expanded(flex: 4, child: _buildQrView(context)),
          Expanded(
            flex: 1,
            child: FittedBox(
              fit: BoxFit.contain,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  const Text('Scan a code',style: TextStyle(fontSize: 7),),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        margin: const EdgeInsets.all(8),
                        height: 18,
                        width: 60,
                        child: MaterialButton(
                            color: Colors.black,
                            onPressed: () async {
                              await qrController?.toggleFlash();
                              setState(() {});
                            },
                            child: FutureBuilder(
                              future: qrController?.getFlashStatus(),
                              builder: (context, snapshot) {
                                return snapshot.data=="true"? const Text('Flash:On',style: TextStyle(color: Colors.white,fontSize: 6),):
                                const Text('Flash:Off',style: TextStyle(color: Colors.white,fontSize: 6),);
                              },
                            )),
                      ),
                      Container(
                        height: 18,
                        width: 60,
                        margin: const EdgeInsets.all(8),
                        child: MaterialButton(
                            color: Colors.black,
                            onPressed: () async {
                              await qrController?.flipCamera();
                              setState(() {});
                            },
                            child: FutureBuilder(
                              future: qrController?.getCameraInfo(),
                              builder: (context, snapshot) {
                                if (snapshot.data != null) {
                                  return const Text("Rotate",style: TextStyle(color: Colors.white,fontSize: 6),);
                                } else {
                                  return const Text('loading',style: TextStyle(color: Colors.white,fontSize: 6));
                                }
                              },
                            )),
                      )
                    ],
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildQrView(BuildContext context) {
    // For this example we check how width or tall the device is and change the scanArea and overlay accordingly.
    var scanArea = (MediaQuery.of(context).size.width < 400 ||
        MediaQuery.of(context).size.height < 400)
        ? 250.0
        : 600.0;
    // To ensure the Scanner view is properly sizes after rotation
    // we need to listen for Flutter SizeChanged notification and update controller
    return QRView(
      key: qrKey,
      onQRViewCreated: _onQRViewCreated,
      overlay: QrScannerOverlayShape(
          borderColor: Colors.red,
          borderRadius: 10,
          borderLength: 30,
          borderWidth: 10,
          cutOutSize: scanArea),
      onPermissionSet: (ctrl, p) => _onPermissionSet(context, ctrl, p),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    setState(() {
      qrController = controller;
    });
    controller.scannedDataStream.listen((scanData) async {
      setState(() {
        setPrefValues(scanData!.code.toString());
        result = scanData;
        print("NAVIGATE");
      });
      await qrController!.pauseCamera();
      qrController!.dispose();
      Navigator.push(context,MaterialPageRoute(builder: (context)=>QrDataScreen(qrData: result!.code)));
    });
  }

  void _onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
    log('${DateTime.now().toIso8601String()}_onPermissionSet $p');
    if (!p) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('no Permission')),
      );
    }
  }

  void setPrefValues(String data) async
  {
    prefs= await SharedPreferences.getInstance();
    prefs.setString("$QRDATA", data);
  }

  @override
  void dispose() {
    //controller?.stopCamera();
    qrController?.dispose();
    super.dispose();
  }
}