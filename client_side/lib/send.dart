import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ubipay/set_send_amount.dart';

class sendPage extends StatefulWidget {
  final int amount;
  final String username;
  const sendPage({Key? key, required this.username, required this.amount})
      : super(key: key);

  @override
  _sendPageState createState() => _sendPageState();
}

class _sendPageState extends State<sendPage> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? controller;
  //final usernameKey = 'username';
  //String username = 'Null';
  late int amount;
  late String username;

  // In order to get hot reload to work we need to pause the camera if the platform
  // is android, or resume the camera if the platform is iOS.
  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller?.pauseCamera();
    }
    controller?.resumeCamera();
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  // void readDate() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   setState(() {
  //     username = prefs.getString(usernameKey)!;
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('QR読み取り'),
        centerTitle: true,
      ),
      body: _buildQrView(context),
    );
  }

  @override
  void initState() {
    super.initState();
    //readDate();
    amount = widget.amount;
    username = widget.username;
    print("uuuuuuu");
    print(amount);
    print(username);
  }

  Widget _buildQrView(BuildContext context) {
    // For this example we check how width or tall the device is and change the scanArea and overlay accordingly.
    var scanArea = (MediaQuery.of(context).size.width < 400 ||
            MediaQuery.of(context).size.height < 400)
        ? 150.0
        : 300.0;
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
      this.controller = controller;
    });
    controller.scannedDataStream.listen((scanData) async {
      print(scanData.code);
    });
  }

  void _onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
    log('${DateTime.now().toIso8601String()}_onPermissionSet $p');
    if (!p) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('no Permission')),
      );
    }
  }
}

class ApiResults {
  final String message;
  ApiResults({
    this.message = '',
  });
  factory ApiResults.fromJson(Map<String, dynamic> json) {
    return ApiResults(
      message: json['message'],
    );
  }
}

class sendRequest {
  final String from_user_id;
  final String from_user_name;
  final String to_user_id;
  sendRequest({
    this.from_user_id = '',
    this.from_user_name = '',
    this.to_user_id = '',
  });
  Map<String, dynamic> toJson() => {
        'from_user_id': from_user_id,
        'from_user_name': from_user_name,
        'to_user_id': to_user_id,
      };
}
