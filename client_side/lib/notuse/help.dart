// import 'package:flutter/material.dart';
// import 'package:ubipay/QRcode.dart';
// import 'main.dart';

// import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
// import 'package:amplify_authenticator/amplify_authenticator.dart';
// import 'package:amplify_flutter/amplify_flutter.dart';
// import 'package:qr_flutter/qr_flutter.dart';

// import 'package:settings_ui/settings_ui.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:provider/provider.dart';

// import 'set_username.dart';
// import 'help.dart';

// class HelpPage extends StatefulWidget {
//   const HelpPage({Key? key}) : super(key: key);
//   @override
//   State<HelpPage> createState() => _HelpPageState();
// }

// class _HelpPageState extends State<HelpPage> {
//   @override
//   void initState() {
//     super.initState();
//   }

//   List QuestionList = [
//     ["How to deposit?", depositHelp()],
//     ["How to pay?", paymentHelp()],
//     ["How to confirm balance?", balanceHelp()]
//   ];

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Expanded(
//           child: ListView.builder(
//         //スクロール可能な可変リストを作る
//         itemCount: QuestionList == null ? 0 : QuestionList.length, //受け取る数の定義
//         itemBuilder: (BuildContext context, int index) {
//           return ElevatedButton(
//             child: Padding(
//               padding: EdgeInsets.only(top: 5, right: 5, bottom: 5, left: 5),
//               child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                   children: <Widget>[
//                     Icon(
//                       Icons.help,
//                       color: Colors.white,
//                     ),
//                     Text(QuestionList[index][0].toString())
//                   ]),
//             ),
//             onPressed: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(builder: (context) => QuestionList[index][1]),
//               );
//             },
//           );
//           //ここに表示したい内容をindexに応じて
//         },
//       )),
//     );
//   }
// }

// class depositHelp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         appBar: AppBar(
//           title: Text('test'),
//         ),
//         body: Center(
//           child: QrImage(
//             data: 'ajdjhsdhfjdfedj-5678-jhhc',
//             size: 200,
//           ),
//         ));
//   }
// }

// class paymentHelp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         appBar: AppBar(
//           title: Text('test'),
//         ),
//         body: Center(
//           child: QrImage(
//             data: 'ajdjhsdhfjdfedj-5678-jhhc',
//             size: 200,
//           ),
//         ));
//   }
// }

// class balanceHelp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         appBar: AppBar(
//           title: Text('test'),
//         ),
//         body: Center(
//           child: QrImage(
//             data: 'ajdjhsdhfjdfedj-5678-jhhc',
//             size: 200,
//           ),
//         ));
//   }
// }
