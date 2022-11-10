import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_authenticator/amplify_authenticator.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'dart:async';
import 'dart:convert';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class inquiryPage extends StatefulWidget {
  const inquiryPage({Key? key}) : super(key: key);
  @override
  State<inquiryPage> createState() => _inquiryPageState();
}

class _inquiryPageState extends State<inquiryPage> {
  late String username;
  late String email;
  late String inquiry;
  late var inquiryRequestResult;

  final usernameController = TextEditingController();
  final emailController = TextEditingController();
  final inquiryController = TextEditingController();

  sendInquiry() async {
    final user = await Amplify.Auth.getCurrentUser();
    //print(user.userId);
    String tmp = user.userId;
    tmp = tmp.toString();

    var url =
        "http://ec2-35-78-201-89.ap-northeast-1.compute.amazonaws.com:8080/inquiry";
    var request = new inquiryRequest(
        userid: tmp, username: username, email: email, inquiry: inquiry);
    final response = await http.post(Uri.parse(url),
        body: json.encode(request.toJson()),
        headers: {"Content-Type": "application/json"});
    if (response.statusCode == 200) {
      setState(() {
        inquiryRequestResult = ApiResults.fromJson(json.decode(response.body));
      });
    } else {
      throw Exception('Failed');
    }
  }

  showPopup() async {
    setUsername(usernameController.text);
    setEmail(emailController.text);
    setInquiry(inquiryController.text);
    await sendInquiry();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Attention"),
        content: Text("Accepted your request"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text("close"),
          )
        ],
      ),
    );
  }

  void setUsername(String s) {
    setState(() {
      username = s;
    });
  }

  void setEmail(String s) {
    setState(() {
      email = s;
    });
  }

  void setInquiry(String s) {
    setState(() {
      inquiry = s;
    });
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
                Text(AppLocalizations.of(context)!.inquiry_form,
                    style: TextStyle(fontSize: 25.0)),
                TextField(
                  decoration: InputDecoration(
                    hintText: AppLocalizations.of(context)!.your_name,
                  ),
                  controller: usernameController,
                ),
                TextField(
                  decoration: InputDecoration(
                    hintText: AppLocalizations.of(context)!.your_email_address,
                  ),
                  controller: emailController,
                ),
                TextField(
                  decoration: InputDecoration(
                    hintText: AppLocalizations.of(context)!.input_your_inquiry,
                  ),
                  controller: inquiryController,
                ),
                ElevatedButton(
                  child: Text(AppLocalizations.of(context)!.submit),
                  onPressed: () {
                    showPopup();
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
