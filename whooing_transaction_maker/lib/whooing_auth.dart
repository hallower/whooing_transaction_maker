
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:math';
import 'package:crypto/crypto.dart';
import 'package:provider/provider.dart';
import 'dart:convert';

import 'package:whooing_transaction_maker/models/signin_state_model.dart';

class WhooingAuth {
  static final WhooingAuth _instance = WhooingAuth._internal();

  final _chars =
      'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
  final appID = "";
  final asozmqpMVi = "";

  final urlRequestToken = "https://whooing.com/app_auth/request_token";
  final urlAccessToken = "https://whooing.com/app_auth/access_token";

  String tempToken;
  String _pin;
  String _token;
  String _tokenSecret;
  String userID;
  Random _rnd = Random();
  Map<String, String> _headers;

  factory WhooingAuth() {
    return _instance;
  }

  WhooingAuth._internal() {
    tempToken = "";
    _pin = "";
    _token = "";
    _tokenSecret = "";
    userID = "";
    _headers = {
      "X-API-KEY": getXapiKey(),
      "Content-Type": 'application/x-www-form-urlencoded',
    };
  }

  String _getRandomString(int length) => String.fromCharCodes(Iterable.generate(
      length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));

  String getXapiKey() =>
      "app_id=$appID,token=$_token,nounce=${_getRandomString(10)},timestamp=${DateTime.now().millisecondsSinceEpoch},signiture=${sha1.convert(utf8.encode('$asozmqpMVi|$_tokenSecret'))}";

  Future<bool> prepareSignIn(BuildContext context) async {
    if (Provider.of<SigninStatusModel>(context).status == SigninStatus.SignedIn) {
      print("Already Authed!!!");
      return true;
    }

    String params = "app_id=" + appID + "&app_secret=" + asozmqpMVi;
    final response =
        await http.post(urlRequestToken, headers: _headers, body: params);
    if (response.statusCode == 200) {
      print(response.body);

      final body = jsonDecode(response.body);
      tempToken = body["token"];

      print("_tempToken = $tempToken");
      Provider.of<SigninStatusModel>(context).changeStatus(SigninStatus.NeedSignInPage);
      return true;
    } else {
      print(
          "Fetch token is failed!!!, [${response.statusCode}] ${response.body}");
      return false;
    }
  }

  void setPin(BuildContext context, String pin){
    this._pin = pin;
    print('Pin = $pin');
    Provider.of<SigninStatusModel>(context).changeStatus(SigninStatus.SignInInProgress);
  }

  Future<bool> completeSignIn(BuildContext context) async {
    if (Provider.of<SigninStatusModel>(context).status == SigninStatus.SignedIn) {
      print("Already Authed!!!");
      return true;
    }

    String params = "app_id=$appID&app_secret=$asozmqpMVi&token=$tempToken&pin=$_pin";
    final response = await http.post(urlAccessToken, headers: _headers, body: params);
    if (response.statusCode == 200) {
      print(response.body);

      //{"token":"6f38a9eba116b0d1a9c4f7fb81f9c428fac389a6","token_secret":"4b1b199744c62ab6093f7a5ff03d775e5745487c","user_id":"20169"}

      final body = jsonDecode(response.body);
      _token = body["token"];
      _tokenSecret = body["token_secret"];
      userID = body["user_id"];

      Provider.of<SigninStatusModel>(context).changeStatus(SigninStatus.SignedIn);

      // TODO : store token to secure storage

      // TODO : get user information, sections

      return true;
    } else {
      print(
          "Fetch token is failed!!!, [${response.statusCode}] ${response.body}");
      return false;
    }
  }
}
