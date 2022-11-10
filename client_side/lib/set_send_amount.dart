import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_authenticator/amplify_authenticator.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:ubipay/home.dart';
import 'dart:async';
import 'dart:convert';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'send.dart';

class setSendAmountPage extends StatefulWidget {
  const setSendAmountPage({Key? key}) : super(key: key);
  @override
  State<setSendAmountPage> createState() => _setSendAmountPageState();
}

class _setSendAmountPageState extends State<setSendAmountPage> {
  late String username;
  late var amount;
  late var balance;
  late var inquiryRequestResult;
  late List sendArgs;

  final usernameController = TextEditingController();
  final amountController = TextEditingController();

  void setUsername(String s) {
    setState(() {
      username = s;
    });
  }

  void setAmount(int s) {
    setState(() {
      amount = s;
    });
  }

  void getBalance() async {
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

    setState(() {
      balance = ApiResults.fromJson(json.decode(response.body)).message;
    });
  }

  @override
  void initState() {
    super.initState();
    getBalance();
  }

  void sendPageRouter() {
    setUsername(usernameController.text);
    setAmount(int.parse(amountController.text));
    balance = int.parse(balance);

    sendArgs = [amount, username];

    if (amount > balance) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(AppLocalizations.of(context)!.notice),
          content:
              Text(AppLocalizations.of(context)!.remittance_form_pupup_exceed),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => home()),
                );
              },
              child: Text(AppLocalizations.of(context)!.close),
            )
          ],
        ),
      );
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => sendPage(username: username, amount: amount)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: Container(
            width: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(AppLocalizations.of(context)!.remittance_form_title,
                    style: TextStyle(fontSize: 25.0)),
                TextField(
                  decoration: InputDecoration(
                    hintText: AppLocalizations.of(context)!.your_name,
                  ),
                  controller: usernameController,
                ),
                TextField(
                  decoration: InputDecoration(
                    hintText:
                        AppLocalizations.of(context)!.remittance_from_input,
                  ),
                  controller: amountController,
                ),
                ElevatedButton(
                  child: Text(AppLocalizations.of(context)!.submit),
                  onPressed: () {
                    sendPageRouter();
                  },
                ),
              ],
            ),
          ),
        ));
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

class inquiryRequest {
  final String username;
  final String email;
  final String inquiry;
  final String userid;
  inquiryRequest({
    this.userid = '',
    this.username = '',
    this.email = '',
    this.inquiry = '',
  });
  Map<String, dynamic> toJson() => {
        'userid': userid,
        'username': username,
        'email': email,
        'inquiry': inquiry
      };
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

class sendArgs {
  final int amount;
  final String username;

  sendArgs(this.amount, this.username);
}
