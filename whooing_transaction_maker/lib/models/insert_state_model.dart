import 'package:flutter/material.dart';
import 'package:whooing_transaction_maker/models/account_item.dart';
import 'package:whooing_transaction_maker/models/monthly_item.dart';

class InsertStateModel extends ChangeNotifier {
  String sectionID = "";

  List<MonthlyItem> monthlyItems = List();

  Map<String, AccountItem> accountItems = Map(); // TODO : Is this required?
  List<AccountItem> leftAccounts = List();
  List<AccountItem> rightAccounts = List();

  int selectedMonthlyItemIndex = -1;
  int selectedLeftAccountItemIndex = -1;
  int selectedRightAccountItemIndex = -1;

  DateTime date = DateTime.now();

  void setSectionID(id) {
    sectionID = id;
  }

  void plusDate() {
    date.add(Duration(days: 1));
    notifyListeners();
  }

  void minusDate() {
    date.add(Duration(days: -1));
    notifyListeners();
  }

  void setDate(DateTime date){
    this.date = date;
    notifyListeners();
  }

  void setMonthlyItems(List<MonthlyItem> items) {
    if (items.length == 0) {
      print("Given Monthly item list is empty!!!");
      return;
    }

    monthlyItems = items;
    notifyListeners();
  }

  void setAccountItems(List<AccountItem> items) {
    if (items.length == 0) {
      print("Given Account item list is empty!!!");
      return;
    }

    for (var item in items) {
      accountItems.putIfAbsent(item.id, () => item);
      if (item.classification == "assets") {
        // 자산
        leftAccounts.add(item);
        rightAccounts.add(item);
      } else if (item.classification == "liabilities") {
        // 부채
        leftAccounts.add(item);
        rightAccounts.add(item);
      } else if (item.classification == "capital") {
        // 순자산
        leftAccounts.add(item);
        rightAccounts.add(item);
      } else if (item.classification == "income") {
        // 수익
        rightAccounts.add(item);
      } else if (item.classification == "expenses") {
        // 비용
        leftAccounts.add(item);
      } else {
        print("Invalid Account classification!!!, "
            "${item.classification} - ${item.title}");
      }
    }

    notifyListeners();
  }

  void setMonthlyItemIndex(int index) {
    if (index < 0 || index >= monthlyItems.length) {
      print(
          "Invalid monthly item index = $index, current list size is = ${monthlyItems.length}");
      return;
    }

    selectedMonthlyItemIndex = index;

    print(
        "Selected Monthly Item = ${monthlyItems[selectedMonthlyItemIndex].title}, ${monthlyItems[selectedMonthlyItemIndex].money}");

    for (int i = 0; i < leftAccounts.length; i++) {
      if (leftAccounts[i].id ==
          monthlyItems[selectedMonthlyItemIndex].leftAccountID) {
        selectedLeftAccountItemIndex = i;
        break;
      }
    }

    for (int i = 0; i < rightAccounts.length; i++) {
      if (rightAccounts[i].id ==
          monthlyItems[selectedMonthlyItemIndex].rightAccountID) {
        selectedRightAccountItemIndex = i;
        break;
      }
    }

    notifyListeners();
  }

  void setLeftItemIndex(int index) {
    if (index < 0 || index >= leftAccounts.length) {
      print(
          "Invalid left item index = $index, current list size is = ${leftAccounts.length}");
      return;
    }
    selectedLeftAccountItemIndex = index;
    notifyListeners();
  }

  void setRightItemIndex(int index) {
    if (index < 0 || index >= rightAccounts.length) {
      print(
          "Invalid left item index = $index, current list size is = ${rightAccounts.length}");
      return;
    }
    selectedRightAccountItemIndex = index;
    notifyListeners();
  }
}
