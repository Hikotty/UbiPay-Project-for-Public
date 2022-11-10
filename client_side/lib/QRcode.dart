import 'package:flutter/material.dart';
import 'main.dart';

import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_authenticator/amplify_authenticator.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:qr_flutter/qr_flutter.dart';

import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

class QRcode extends StatefulWidget {
  const QRcode({Key? key}) : super(key: key);

  @override
  State<QRcode> createState() => _QRcode();
}

class _QRcode extends State<QRcode> {
  //late DateTime now;
  //late DateTime expireTime;

  final DateTime now = DateTime.now();
  late DateTime expireTime = now.add(Duration(minutes: 5));

  void initTime() async {
    setState(() {
      final now = DateTime.now();
      final DateTime expireTime = now.add(Duration(minutes: 5));
    });
  }

  @override
  void initState() {
    super.initState();
    initTime();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: FutureBuilder(
          future: getUserId(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    QrImage(
                      data: snapshot.data +
                          ',' +
                          DateFormat('yyyy-MM-dd hh:mm:ss').format(now),
                      size: 250,
                    ),
                    Column(children: [
                      IconButton(
                        icon: Icon(Icons.autorenew_sharp),
                        onPressed: () {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      super.widget));
                        },
                        color: Colors.black,
                      ),
                      Text("This QR code expires in"),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(DateFormat('yyyy-MM-dd hh:mm:ss')
                              .format(expireTime)),
                        ],
                      )
                    ])
                  ]);
            } else {
              return CircularProgressIndicator();
            }
          },
        ),
      ),
    );
  }

  Future<String> getUserId() async {
    try {
      final user = await Amplify.Auth.getCurrentUser();
      print(user.userId);
      String tmp = user.userId;
      tmp = tmp.toString();
      print(tmp.runtimeType);

      return tmp;
    } on Exception catch (e) {
      return "Error";
    }
  }
}
