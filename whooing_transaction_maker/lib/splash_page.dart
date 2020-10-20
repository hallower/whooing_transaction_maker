import 'package:flutter/material.dart';
import 'package:whooing_transaction_maker/whooing_auth.dart';
import 'package:whooing_transaction_maker/whooing_signin_page.dart';

class SplashPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  _showMainPage(BuildContext context) =>
      Navigator.pushNamed(context, '/insert');

  _showSignInPage(BuildContext context) {
    // if(!isAuthed)
    print('tempToken = ${WhooingAuth().tempToken}');
    if (WhooingAuth().tempToken.isNotEmpty) {
      Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      WhooingSigninPage(WhooingAuth().tempToken)))
          .then((value) => _checkStatus(value));
    } else {
      print('not yet');
    }
  }

  void _checkStatus(bool isNeedRefresh) {
    if(!isNeedRefresh)
      return;

    // TODO : move this in the view model
    if (!WhooingAuth().isAuthed) {
      print('WhooingAuth status ${WhooingAuth().status.toString()}');
      switch (WhooingAuth().status) {
        case SigninStatus.not:
          WhooingAuth().fetchToken();
          break;
        case SigninStatus.gotTempToken:
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      WhooingSigninPage(WhooingAuth().tempToken)));
          break;
        case SigninStatus.signined:
          WhooingAuth().fetchAccessToken();
          break;
        case SigninStatus.gotAccessToken:
          break;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    _checkStatus(true);

    return Scaffold(
        resizeToAvoidBottomPadding: false,
        body: Center(
            child: SizedBox(
          width: 400,
          height: 400,
          child: Column(
            children: [
              Text('Splash test!!!!',
                  style: TextStyle(
                    color: Colors.grey[500],
                    fontSize: 50,
                    fontWeight: FontWeight.w300,
                  )),
              RaisedButton(
                onPressed: () => _showMainPage(context),
                child: const Text('Next',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    )),
              ),
              RaisedButton(
                onPressed: () => _showSignInPage(context),
                child: const Text('WebView',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    )),
              ),
            ],
          ),
        )));
  }
}
