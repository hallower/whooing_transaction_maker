import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:whooing_transaction_maker/models/signin_state_model.dart';
import 'package:whooing_transaction_maker/whooing_auth.dart';

bool testValue = true;

Widget getSettingsPage(BuildContext context) {
  return SettingsList(
    sections: [
      SettingsSection(
        title: 'General',
        tiles: [
          SettingsTile(
            title: 'Sign out',
            subtitle: 'Sign out this application',
            leading: Icon(Icons.exit_to_app),
            onPressed: (BuildContext context) async {

              WhooingAuth().clearAuthInfo();
              Provider.of<SigninStatusModel>(context).signOut();

              final cookieManager = CookieManager();
              cookieManager.clearCookies();

              Navigator.pushNamedAndRemoveUntil(context, '/', (Route<dynamic> route) => false);
            },
          ),
          SettingsTile.switchTile(
            title: 'Use fingerprint',
            leading: Icon(Icons.fingerprint),
            switchValue: testValue,
            onToggle: (bool value) {
              testValue = value;
              print("value=$value");
            },
          ),
        ],
      ),
    ],
  );
}
