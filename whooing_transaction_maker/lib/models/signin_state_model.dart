import 'dart:collection';

import 'package:flutter/material.dart';


enum SigninStatus { NotSignedIn, NeedSignInPage, SignInInProgress, SignedIn}

var SigninStatusMsg =  {
  SigninStatus.NotSignedIn: "logoff",
  SigninStatus.NeedSignInPage: "Prepare Sign-in",
  SigninStatus.SignInInProgress:"Sign-in in progress",
  SigninStatus.SignedIn: "Signed In",
};

// new HashMap<SigninStatus, String>() =

class SigninStatusModel extends ChangeNotifier {

  SigninStatus status = SigninStatus.NotSignedIn;
  String msg = SigninStatusMsg[SigninStatus.NotSignedIn];

  void changeStatus(newStatus) {
    print("SigninStatus changeStatus -> $newStatus");
    status = newStatus;
    msg = SigninStatusMsg[status];
    notifyListeners();
  }

  void signOut(){
    status = SigninStatus.NotSignedIn;
    msg = SigninStatusMsg[status];
  }

}