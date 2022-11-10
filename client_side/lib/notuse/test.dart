// import 'package:flutter/material.dart';
// import '../main.dart';

// import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
// import 'package:amplify_authenticator/amplify_authenticator.dart';
// import 'package:amplify_flutter/amplify_flutter.dart';
// import 'package:qr_flutter/qr_flutter.dart';

// class test extends StatelessWidget {
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

//   Future<String> _get_user_id() async {
//     try {
//       final user = await Amplify.Auth.getCurrentUser();
//       print(user.userId);
//       String tmp = user.userId;
//       tmp = tmp.toString();
//       print(tmp.runtimeType);

//       return tmp;
//     } on Exception catch (e) {
//       return "Error";
//     }
//   }
// }
