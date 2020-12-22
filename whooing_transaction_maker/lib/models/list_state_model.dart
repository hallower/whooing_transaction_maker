import 'package:flutter/material.dart';
import 'package:whooing_transaction_maker/models/account_item.dart';
import 'package:whooing_transaction_maker/models/entry_item.dart';
import 'package:whooing_transaction_maker/models/monthly_item.dart';

class ListStateModel extends ChangeNotifier {
  bool notInitialized = true;
  List<EntryItem> entryItems = List();
  int selectedEntryItemIndex = -1;

  void setEntries(List<EntryItem> items) {
    print("setEntries!!!");
    if (items.length == 0) {
      print("Given Monthly item list is empty!!!");
      return;
    }

    // To be refreshed whenever entry item is zero
    notInitialized = false;

    entryItems = items;
    notifyListeners();
  }

  void setEntryItemIndex(int index)
  {
    selectedEntryItemIndex = index;
  }
}
