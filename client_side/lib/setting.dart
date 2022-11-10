import 'package:flutter/material.dart';
import 'package:ubipay/QRcode.dart';
import 'main.dart';

import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_authenticator/amplify_authenticator.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:qr_flutter/qr_flutter.dart';

import 'package:settings_ui/settings_ui.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'set_username.dart';
import 'inquiry.dart';
import 'set_password.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({Key? key}) : super(key: key);
  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  final usernameKey = 'username';
  String username = '';

  void readDate() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      username = prefs.getString(usernameKey)!;
    });
  }

  @override
  void initState() {
    super.initState();
    readDate();
  }

  void showHelpPage() async {
    Uri url = Uri.parse(
        "http://ec2-35-78-201-89.ap-northeast-1.compute.amazonaws.com:8080/help");
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      throw 'Could not Launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
            body: SettingsList(
          sections: [
            SettingsSection(
              title: Text(AppLocalizations.of(context)!.common),
              tiles: <SettingsTile>[
                SettingsTile.navigation(
                  leading: Icon(Icons.start),
                  title: Text(AppLocalizations.of(context)!.how_to_use),
                  onPressed: (context) {
                    showHelpPage();
                  },
                ),
                SettingsTile.navigation(
                  leading: Icon(Icons.help),
                  title: Text(AppLocalizations.of(context)!.send_inquiry),
                  onPressed: (context) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => inquiryPage()),
                    );
                  },
                ),
              ],
            ),
            SettingsSection(
              title: Text(AppLocalizations.of(context)!.account),
              tiles: <SettingsTile>[
                SettingsTile.navigation(
                  leading: Icon(Icons.drive_file_rename_outline),
                  title: Text(AppLocalizations.of(context)!.user_name),
                  value: Text(username),
                  onPressed: (context) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SetNamePage()),
                    );
                  },
                ),
                SettingsTile.navigation(
                  leading: Icon(Icons.key),
                  title: Text(AppLocalizations.of(context)!.setting_key),
                  value: Text(username),
                  onPressed: (context) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => SetPasswordPage()),
                    );
                  },
                ),
              ],
            ),
          ],
        )));
  }
}
