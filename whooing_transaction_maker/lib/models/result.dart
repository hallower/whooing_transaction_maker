

import 'package:flutter/material.dart';

class Result extends ChangeNotifier {
  String request;
  String json;

  void notify() {
    notifyListeners();
  }

}