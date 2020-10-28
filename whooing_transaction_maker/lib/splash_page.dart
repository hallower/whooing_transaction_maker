import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:whooing_transaction_maker/models/signin_state_model.dart';
import 'package:whooing_transaction_maker/whooing_auth.dart';
import 'package:whooing_transaction_maker/whooing_signin_page.dart';

class SplashPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  _showMainPage(BuildContext context) =>
      Navigator.pushNamedAndRemoveUntil(context, '/home', (Route<dynamic> route) => false);

  _showSignInWebPage(BuildContext context, String token) {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => WhooingSigninPage(token)));
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Provider.of<SigninStatusModel>(context, listen: true).addListener(() {
        _checkStatus(context);
      });

      _checkStatus(context);
    });
  }

  void _checkStatus(BuildContext context) {
    // TODO : move this in the view model
    print(
        'WhooingAuth status ${Provider.of<SigninStatusModel>(context, listen: false).status.toString()}');

    switch (Provider.of<SigninStatusModel>(context, listen: false).status) {
      case SigninStatus.NotSignedIn:
        WhooingAuth().prepareSignIn(context);
        break;
      case SigninStatus.NeedSignInPage:
        _showSignInWebPage(context, WhooingAuth().tempToken);
        break;
      case SigninStatus.SignInInProgress:
        WhooingAuth().completeSignIn(context);
        break;
      case SigninStatus.SignedIn:
        _showMainPage(context);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
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
              Text("status = ${Provider.of<SigninStatusModel>(context).msg}",
                  style: TextStyle(
                    color: Colors.grey[500],
                    fontSize: 30,
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
            ],
          ),
        )));
  }
}
