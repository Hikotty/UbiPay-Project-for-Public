import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_authenticator/amplify_authenticator.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:ubipay/send.dart';
import 'amplifyconfiguration.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'QRcode.dart';
import 'setting.dart';
import 'withdraw.dart';
import 'set_send_amount.dart';

import 'package:amazon_cognito_identity_dart_2/cognito.dart';
import 'package:jwt_decode/jwt_decode.dart';
import 'package:qr_flutter/qr_flutter.dart';

import 'notuse/test.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

class home extends StatefulWidget {
  const home({Key? key}) : super(key: key);

  @override
  State<home> createState() => _MyAppState();
}

class _MyAppState extends State<home> {
  late Future<ApiResults> res;
  late Future<String> _user_id;

  var _pages = <Widget>[
    SettingPage(),
    QRcode(),
    Container(
      child: Text('Share'),
      alignment: Alignment.center,
      color: Colors.pink.withOpacity(0.5),
    ),
  ];

  List history = [];

  Future<void> getData() async {
    final user = await Amplify.Auth.getCurrentUser();
    //print(user.userId);
    String tmp = user.userId;
    tmp = tmp.toString();

    var url =
        "http://ec2-35-78-201-89.ap-northeast-1.compute.amazonaws.com:8080/history";
    var request = new BalanceRequest(id: tmp);
    final response = await http.post(Uri.parse(url),
        body: json.encode(request.toJson()),
        headers: {"Content-Type": "application/json"});

    var jsonResponse = jsonDecode(response.body);
    setState(() {
      history = jsonResponse['message'];
    });
  }

  @override
  void initState() {
    super.initState();
    try {
      _configureAmplify();
      print("rrrrrr");
    } on Exception catch (e) {
      print('Logined while login');
    }
    //_user_id = _get_user_id();
    res = fetchApiResults();
    getData();
  }

  void _configureAmplify() async {
    try {
      await Amplify.addPlugin(AmplifyAuthCognito());
      await Amplify.configure(amplifyconfig);
      print('Successfully configured');
    } on Exception catch (e) {
      print('Error configuring Amplify: $e');
    }
  }

  Future<String> _get_user_id() async {
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

  Widget? txContents(
      String tx, String date, String time, String amount, String txid) {
    if (tx == "deposit") {
      return Builder(builder: (context) {
        return Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
          Column(children: [
            Icon(
              Icons.add_circle,
              color: Colors.white,
            ),
            Text(AppLocalizations.of(context)!.deposit)
          ]),
          Text(date),
          Text("¥" + amount),
          IconButton(
            icon: Icon(Icons.info),
            onPressed: () {
              txInfoPopup(tx, date, time, amount, txid);
            },
          ),
        ]);
      });
    } else if (tx == "send") {
      return Builder(builder: (context) {
        return Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
          Column(children: [
            Icon(
              Icons.call_received,
              color: Colors.white,
            ),
            Text("send")
          ]),
          Text(date + " "),
          Text("¥" + amount),
          IconButton(
            icon: Icon(Icons.info),
            onPressed: () {
              txInfoPopup(tx, date, time, amount, txid);
            },
          ),
        ]);
      });
    } else if (tx == "purchase") {
      return Builder(builder: (context) {
        return Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
          Column(children: [
            Icon(
              Icons.shopping_bag,
              color: Colors.white,
            ),
            Text(AppLocalizations.of(context)!.payed)
          ]),
          Text(date + " "),
          Text("¥" + amount),
          IconButton(
            icon: Icon(Icons.info),
            onPressed: () {
              txInfoPopup(tx, date, time, amount, txid);
            },
          ),
        ]);
      });
    } else if (tx == "recieved") {
      return Builder(builder: (context) {
        return Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
          Column(children: [
            Icon(
              Icons.shopping_bag,
              color: Colors.white,
            ),
            Text("payed")
          ]),
          Text(date + " "),
          Text("¥" + amount),
          IconButton(
            icon: Icon(Icons.info),
            onPressed: () {
              txInfoPopup(tx, date, time, amount, txid);
            },
          ),
        ]);
      });
    }
  }

  txInfoPopup(String tx, String date, String time, String amount, String txid) {
    String txText = "";

    if (tx == "deposit") {
      txText = AppLocalizations.of(context)!.deposit;
    } else if (tx == "send") {
      txText = AppLocalizations.of(context)!.send;
    } else if (tx == "purchase") {
      txText = AppLocalizations.of(context)!.payed;
    } else if (tx == "recieved") {
      txText = AppLocalizations.of(context)!.recieved;
    }

    showDialog(
      context: context,
      builder: (context) =>
          // MaterialApp(
          //       builder: Authenticator.builder(),
          //       localizationsDelegates: AppLocalizations.localizationsDelegates,
          //       supportedLocales: AppLocalizations.supportedLocales,
          //       home:
          Builder(builder: (context) {
        return AlertDialog(
          title: Text(AppLocalizations.of(context)!.tx_info),
          content: Container(
              width: 400,
              height: 200,
              child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                  //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(AppLocalizations.of(context)!.tx_class),
                          Text(txText)
                        ]),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          // Icon(
                          //   Icons.calendar_month,
                          //   color: Colors.white,
                          // ),
                          Text(AppLocalizations.of(context)!.date + " : "),
                          Text(date)
                        ]),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          // Icon(
                          //   Icons.schedule,
                          //   color: Colors.white,
                          // ),
                          Text(AppLocalizations.of(context)!.time + " : "),
                          Text(time)
                        ]),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          // Icon(
                          //   Icons.attach_money,
                          //   color: Colors.white,
                          // ),
                          Text(AppLocalizations.of(context)!.amount + " : "),
                          Text("¥ " + amount)
                        ]),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          // Icon(
                          //   Icons.attach_money,
                          //   color: Colors.white,
                          // ),
                          Text(AppLocalizations.of(context)!.txid + " : ")
                        ]),
                    Text(txid,
                        style: TextStyle(
                            fontWeight: FontWeight.normal, fontSize: 15))
                  ])),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(AppLocalizations.of(context)!.close),
            )
          ],
        );
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Authenticator(
        child: MaterialApp(
            builder: Authenticator.builder(),
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            home: Builder(builder: (context) {
              return Scaffold(
                  body: Padding(
                      padding: EdgeInsets.only(
                          top: 30, right: 15, bottom: 15, left: 15),
                      child: Center(
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              Text(
                                AppLocalizations.of(context)!.balance,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 20),
                              ),
                              FutureBuilder<ApiResults>(
                                future: res,
                                builder: (context, snapshot) {
                                  if (snapshot.hasData) {
                                    return Container(
                                      child: Text(
                                        '￥' + snapshot.data!.message.toString(),
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 30),
                                      ),
                                    );
                                  } else if (snapshot.hasError) {
                                    return Container(
                                      decoration: BoxDecoration(
                                        border: Border.all(),
                                      ),
                                      child: Text("￥${snapshot.error}",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold)),
                                    );
                                  }
                                  return CircularProgressIndicator();
                                },
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  // 引き出しボタン
                                  Column(children: [
                                    IconButton(
                                      icon: Icon(Icons.paid),
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  withdrawPage()),
                                        );
                                      },
                                      color: Colors.black,
                                    ),
                                    Text(AppLocalizations.of(context)!.withdraw)
                                  ]),
                                  // 入金ボタン
                                  Column(children: [
                                    IconButton(
                                      icon: Icon(Icons.add_circle_outline),
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => QRcode()),
                                        );
                                      },
                                      color: Colors.black,
                                    ),
                                    Text(AppLocalizations.of(context)!.charge)
                                  ]),
                                  // 送金ボタン
                                  Column(children: [
                                    IconButton(
                                      icon: Icon(Icons.send),
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  setSendAmountPage()),
                                        );
                                      },
                                      color: Colors.black,
                                    ),
                                    Text(AppLocalizations.of(context)!.send)
                                  ]),
                                  // 画面更新ボタン
                                  Column(children: [
                                    IconButton(
                                      icon: Icon(Icons.autorenew_sharp),
                                      onPressed: () {
                                        Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(
                                                builder:
                                                    (BuildContext context) =>
                                                        super.widget));
                                      },
                                      color: Colors.black,
                                    ),
                                    Text(AppLocalizations.of(context)!.update)
                                  ]),
                                ],
                              ),
                              Text(
                                AppLocalizations.of(context)!.history,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 20),
                              ),
                              Expanded(
                                  child: ListView.builder(
                                //スクロール可能な可変リストを作る
                                itemCount: history == null
                                    ? 0
                                    : history.length, //受け取る数の定義
                                itemBuilder: (BuildContext context, int index) {
                                  return Card(
                                      child: Padding(
                                        padding: EdgeInsets.only(
                                            top: 5,
                                            right: 5,
                                            bottom: 5,
                                            left: 5),
                                        child: txContents(
                                          history[index]["tx"],
                                          history[index]['date'].toString(),
                                          history[index]['time'].toString(),
                                          history[index]['amount'].toString(),
                                          history[index]['txid'].toString(),
                                        ),
                                        //Text(history[index]['tx'])
                                      ),
                                      color: Color.fromARGB(
                                          255, 71, 214, 211), // Card自体の色
                                      margin: const EdgeInsets.all(5),
                                      elevation: 8, // 影の離れ具合
                                      shadowColor: Colors.black, // 影の色
                                      shape: RoundedRectangleBorder(
                                          // 枠線を変更できる
                                          borderRadius:
                                              BorderRadius.circular(10)));
                                  //ここに表示したい内容をindexに応じて
                                },
                              )),
                            ]),
                      )));
            })));
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

Future<ApiResults> fetchApiResults() async {
  final user = await Amplify.Auth.getCurrentUser();
  //print(user.userId);
  String tmp = user.userId;
  tmp = tmp.toString();
  //print(tmp.runtimeType);

  var url =
      "http://ec2-35-78-201-89.ap-northeast-1.compute.amazonaws.com:8080/balance";
  var request = new BalanceRequest(id: tmp);
  final response = await http.post(Uri.parse(url),
      body: json.encode(request.toJson()),
      headers: {"Content-Type": "application/json"});
  if (response.statusCode == 200) {
    return ApiResults.fromJson(json.decode(response.body));
  } else {
    throw Exception('Failed');
  }
}

class BalanceRequest {
  final String id;
  BalanceRequest({
    this.id = '',
  });
  Map<String, dynamic> toJson() => {
        'content': id,
      };
}

//////////////////////////////////////////////////////

class ApiResults2 {
  final String message;
  ApiResults2({
    this.message = '',
  });
  factory ApiResults2.fromJson(Map<List, dynamic> json) {
    return ApiResults2(
      message: json['message'],
    );
  }
}

Future<ApiResults2> fetchApiResults2() async {
  final user = await Amplify.Auth.getCurrentUser();
  //print(user.userId);
  String tmp = user.userId;
  tmp = tmp.toString();
  //print(tmp.runtimeType);

  var url =
      "http://ec2-35-78-201-89.ap-northeast-1.compute.amazonaws.com:8080/history";
  var request = new BalanceRequest(id: tmp);
  final response = await http.post(Uri.parse(url),
      body: json.encode(request.toJson()),
      headers: {"Content-Type": "application/json"});
  if (response.statusCode == 200) {
    print(json.decode(response.body));
    return json.decode(response.body);
  } else {
    throw Exception('Failed');
  }
}
