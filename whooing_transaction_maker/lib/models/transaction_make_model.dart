import 'package:flutter/material.dart';


enum SubmitStatus { None, Submitting, Submitted, Failed }
var SubmitStatusMessage = {
  SubmitStatus.None : "",
  SubmitStatus.Submitting : "Transaction is in submitting",
  SubmitStatus.Submitted : "Transaction is submitted successfully",
  SubmitStatus.Failed : "Submitting a transaction is failed!!!",
};

class TransactionMakeModel extends ChangeNotifier {

  SubmitStatus status;
  String message;

  void changeStatus(newStatus) {
    print("TransactionMakeModel changeStatus -> $newStatus");
    status = newStatus;
    message = SubmitStatusMessage[status];
    notifyListeners();
  }
}