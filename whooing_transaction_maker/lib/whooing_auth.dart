import 'package:http/http.dart' as http;
import 'dart:math';
import 'package:crypto/crypto.dart';
import 'dart:convert';

enum SigninStatus { not, gotTempToken, signined, gotAccessToken }

class WhooingAuth {
  static final WhooingAuth _instance = WhooingAuth._internal();

  final _chars =
      'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
  final appID = "";
  final asozmqpMVi = "";

  final urlRequestToken = "https://whooing.com/app_auth/request_token";
  final urlAccessToken = "https://whooing.com/app_auth/access_token";

  bool isAuthed;
  String tempToken;
  String _pin;
  String _token;
  String _tokenSecret;
  String userID;
  Random _rnd = Random();
  SigninStatus status;

  factory WhooingAuth() {
    return _instance;
  }

  WhooingAuth._internal() {
    // TODO : check access token and set as isAuthed=true
    isAuthed = false;
    tempToken = "";
    _pin = "";
    _token = "";
    _tokenSecret = "";
    userID = "";
    status = SigninStatus.not;
  }

  String _getRandomString(int length) => String.fromCharCodes(Iterable.generate(
      length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));

  String _xapiKey() =>
      "app_id=$appID,token=$_token,nounce=${_getRandomString(10)},timestamp=${DateTime.now().millisecondsSinceEpoch},signiture=${sha1.convert(utf8.encode('$asozmqpMVi|$_tokenSecret'))}";

  Future<bool> fetchToken() async {
    if (isAuthed) {
      print("Already Authed!!!");
      return true;
    }

    String params = "app_id=" + appID + "&app_secret=" + asozmqpMVi;
    Map<String, String> headers = {
      "X-API-KEY": _xapiKey(),
      "Content-Type": 'application/x-www-form-urlencoded',
    };
    final response =
        await http.post(urlRequestToken, headers: headers, body: params);
    if (response.statusCode == 200) {
      print(response.body);

      final body = jsonDecode(response.body);
      tempToken = body["token"];

      print("_tempToken = $tempToken");
      status = SigninStatus.gotTempToken;
      return true;
    } else {
      print(
          "Fetch token is failed!!!, [${response.statusCode}] ${response.body}");
      return false;
    }
  }

  void setPin(String pin){
    this._pin = pin;
    status = SigninStatus.signined;
    print('Pin = $pin');
  }

  Future<bool> fetchAccessToken() async {
    if (isAuthed) {
      print("Already Authed!!!");
      return true;
    }

    String params = "app_id=$appID&app_secret=$asozmqpMVi&token=$tempToken&pin=$_pin";
    Map<String, String> headers = {
      "X-API-KEY": _xapiKey(),
      "Content-Type": 'application/x-www-form-urlencoded',
    };
    final response =
    await http.post(urlAccessToken, headers: headers, body: params);
    if (response.statusCode == 200) {
      print(response.body);

      //{"token":"6f38a9eba116b0d1a9c4f7fb81f9c428fac389a6","token_secret":"4b1b199744c62ab6093f7a5ff03d775e5745487c","user_id":"20169"}

      final body = jsonDecode(response.body);
      _token = body["token"];
      _tokenSecret = body["token_secret"];
      userID = body["user_id"];

      status = SigninStatus.gotAccessToken;

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
