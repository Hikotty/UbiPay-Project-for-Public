import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_authenticator/amplify_authenticator.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'amplifyconfiguration.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'QRcode.dart';
import 'setting.dart';
import 'home.dart';

import 'package:amazon_cognito_identity_dart_2/cognito.dart';
import 'package:jwt_decode/jwt_decode.dart';
import 'package:http/http.dart' as http;
import 'package:qr_flutter/qr_flutter.dart';

import 'package:provider/provider.dart';
import 'dart:async';
import 'dart:convert';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late Future<ApiResults> res;
  late String? homeText = AppLocalizations.of(context)?.home;

  var _pages = <Widget>[home(), QRcode(), SettingPage()];

  @override
  void initState() {
    super.initState();
    _configureAmplify();
    res = fetchApiResults();
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

  @override
  Widget build(BuildContext context) {
    return Authenticator(
        child: MaterialApp(
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            builder: Authenticator.builder(),
            home: Scaffold(
              appBar: AppBar(title: const Text('UbiPay')),
              body: Builder(builder: (context) {
                return PersistentTabView(
                  context,
                  screens: _pages,
                  items: [
                    PersistentBottomNavBarItem(
                        icon: Icon(Icons.home),
                        activeColorPrimary: Colors.pink,
                        inactiveColorPrimary: Colors.blue,
                        title: AppLocalizations.of(context)!.home),
                    PersistentBottomNavBarItem(
                        icon: Icon(Icons.shopping_cart),
                        activeColorPrimary: Colors.pink,
                        inactiveColorPrimary: Colors.blue,
                        title: AppLocalizations.of(context)!.payment),
                    PersistentBottomNavBarItem(
                        icon: Icon(Icons.settings),
                        activeColorPrimary: Colors.pink,
                        inactiveColorPrimary: Colors.blue,
                        title: AppLocalizations.of(context)!.setting),
                  ],
                  navBarStyle: NavBarStyle.style6, //表示スタイル
                  backgroundColor: Colors.white, //背景色
                  decoration: NavBarDecoration(
                    //枠線
                    border: Border.all(
                      width: 1,
                      color: Colors.grey,
                    ),
                  ),
                );
              }),
            )));
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
  var url =
      "http://ec2-35-78-201-89.ap-northeast-1.compute.amazonaws.com:8080/balance";
  var request = new SampleRequest(id: '6a391cfc-c6b3-4182-9275-81a64bcd56c1');
  final response = await http.post(Uri.parse(url),
      body: json.encode(request.toJson()),
      headers: {"Content-Type": "application/json"});
  if (response.statusCode == 200) {
    return ApiResults.fromJson(json.decode(response.body));
  } else {
    throw Exception('Failed');
  }
}

class SampleRequest {
  final String id;
  SampleRequest({
    this.id = '',
  });
  Map<String, dynamic> toJson() => {
        'content': id,
      };
}
