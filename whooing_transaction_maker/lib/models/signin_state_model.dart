import 'dart:collection';
import 'package:flutter/material.dart';


enum SigninStatus { NotSignedIn, NeedSignInPage, SignInInProgress, SignedIn}

var _signinStatusMsg =  {
  SigninStatus.NotSignedIn: "Sign-in Checking",
  SigninStatus.NeedSignInPage: "Prepare Sign-in",
  SigninStatus.SignInInProgress:"Sign-in in progress",
  SigninStatus.SignedIn: "Signed In",
};

class SigninStatusModel extends ChangeNotifier {
  SigninStatus status = SigninStatus.NotSignedIn;
  String msg = _signinStatusMsg[SigninStatus.NotSignedIn];

  void changeStatus(newStatus) {
    status = newStatus;
    msg = _signinStatusMsg[status];
    notifyListeners();
  }

  void signOut(){
    status = SigninStatus.NotSignedIn;
    msg = _signinStatusMsg[status];
  }

}