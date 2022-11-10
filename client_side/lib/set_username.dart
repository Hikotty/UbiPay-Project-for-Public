import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

// keyを用意
const titleKey = 'name';
const commentKey = 'comment';
const iconKey = 'icon';
const usernameKey = 'username';

class SetNamePage extends StatefulWidget {
  const SetNamePage({Key? key}) : super(key: key);
  @override
  State<SetNamePage> createState() => _SetNamePageState();
}

class _SetNamePageState extends State<SetNamePage> {
  final titleController = TextEditingController();
  final commentController = TextEditingController();
  final usernameController = TextEditingController();
  String title = '';
  String comment = '';
  bool icon = false;
  String username = '';

  @override
  void initState() {
    super.initState();
    readData();
  }

  // アプリ起動時に保存したデータを読み込む
  void readData() async {
    final prefs = await SharedPreferences.getInstance();
    //username = prefs.getString(usernameKey)!;
    var tmp = prefs.getString(usernameKey)!;
    setState() {
      // title = prefs.getString(titleKey)!;
      // comment = prefs.getString(commentKey)!;
      icon = prefs.getBool(iconKey)!;
      //username = prefs.getString(usernameKey)!;
      username = tmp;
    }

    ;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
            body: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Scaffold(
            body: Padding(
              padding: const EdgeInsets.all(30.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    AppLocalizations.of(context)!.change_user_name,
                    style:
                        TextStyle(fontSize: 38.0, fontWeight: FontWeight.w100),
                  ),
                  TextField(
                    controller: usernameController,
                    decoration: InputDecoration(
                        hintText: AppLocalizations.of(context)!
                            .please_enter_username),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      ElevatedButton(
                        onPressed: () async {
                          final prefs = await SharedPreferences.getInstance();
                          // データを保存する
                          prefs.setString(usernameKey, usernameController.text);
                          setState(() {
                            // データを読み込む
                            username = prefs.getString(usernameKey)!;
                            if (username != '') {
                              icon = true;
                            }
                          });
                        },
                        child: Text(AppLocalizations.of(context)!.save),
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          final prefs = await SharedPreferences.getInstance();
                          setState(() {
                            // データを削除する
                            icon = false;
                            username = '';
                            usernameController.text = '';
                            prefs.remove(usernameKey);
                          });
                        },
                        child: Text(AppLocalizations.of(context)!.clear),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        )));
  }
}
