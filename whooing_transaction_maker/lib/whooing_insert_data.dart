import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:whooing_transaction_maker/models/account_item.dart';
import 'package:whooing_transaction_maker/models/entry_item.dart';
import 'package:whooing_transaction_maker/models/monthly_item.dart';
import 'package:whooing_transaction_maker/models/insert_state_model.dart';
import 'package:whooing_transaction_maker/whooing_auth.dart';

class WhooingInsertData {
  final urlDefaultSection = "https://whooing.com/api/sections/default.json";
  final urlAllAccounts = "https://whooing.com/api/accounts.json_array";
  final urlMonthlyItems = "https://whooing.com/api/monthly_items.json_array";
  final urlEntryItem = "https://whooing.com/api/entries.json";


  Map<String, String> _headers;

  WhooingInsertData() {
    print("WhooingInsertData()");
    _headers = {
      "X-API-KEY": WhooingAuth().getXapiKey(),
      "Content-Type": 'application/x-www-form-urlencoded',
    };
  }

  String _getSectionID(context) => Provider.of<InsertStateModel>(context).sectionID;
  void _setSectionID(context,id) => Provider.of<InsertStateModel>(context).setSectionID(id);

  Future<bool> getDefaultSection(BuildContext context) async {

    if(_getSectionID(context).isNotEmpty)
      return true;

    final response = await http.get(urlDefaultSection, headers: _headers);
    if (response.statusCode == 200) {
      print(response.body);

      final body = jsonDecode(response.body);
      _setSectionID(context, body["results"]["section_id"]);
      print("section ID = ${_getSectionID(context)}");

      // TODO : remove
      getAllAccount(context);
      getMonthlyItems(context);
      return true;
    } else {
      print(
          "Fetch token is failed!!!, [${response.statusCode}] ${response.body}");
      return false;
    }
  }

  Future<bool> getAllAccount(BuildContext context) async {
    String params = "?section_id=${_getSectionID(context)}";

    final response = await http.get(urlAllAccounts + params, headers: _headers);
    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      List<AccountItem> items = new List();
      var result = body["results"];
      result.forEach((key, value){
        value.forEach((account){
          var parsedAccount = AccountItem.fromJson(account);
          parsedAccount.classification = key;

          if(parsedAccount.title.isNotEmpty)
            items.add(parsedAccount);
        });
      });

      Provider.of<InsertStateModel>(context, listen:false).setAccountItems(items);
      return true;
    } else {
      print(
          "Fetch token is failed!!!, [${response.statusCode}] ${response.body}");
      return false;
    }
  }

  Future<bool> getMonthlyItems(BuildContext context) async {
    String params = "?section_id=${_getSectionID(context)}";

    final response =
        await http.get(urlMonthlyItems + params, headers: _headers);
    if (response.statusCode == 200) {
      /*
      "results" : {
        "count" : 0,
        "slot1" : {
          "m4" : {
            "item_id" : "m4",
            "item" : "통신비",
            "money" : 79200,
            "l_account" : "expenses",
            "l_account_id" : "x12",
            "r_account" : "assets",
            "r_account_id" : "x5",
            "pay_date" : 27,
            "due_date " : "20120327",
            "d_day" : 1,
            "paid_date" : "20120227"
          },
          "m8" : {
            "item_id" : "m8",
            "item" : "후잉생명보험",
            "money" : 120000,
            "l_account" : "assets",
            "l_account_id" : "x8",
            "r_account" : "assets",
            "r_account_id" : "x5",
            "pay_date" : 27,
            "due_date " : "20120327",
            "d_day" : 1,
            "paid_date" : "20120227"
          },
          ...
        }
       */
      final body = jsonDecode(response.body);

      List<MonthlyItem> items = new List();
      var result = body["results"];
      result.forEach((key, value) {
        if(key.toString().startsWith("slot")){
          // slot
          value.forEach((item) {
            var parsedItem = MonthlyItem.fromJson(item);
            if(parsedItem.title.isNotEmpty)
              items.add(parsedItem);
          });
        }
      });

      Provider.of<InsertStateModel>(context, listen:false).setMonthlyItems(items);
      return true;
    } else {
      print(
          "Fetch token is failed!!!, [${response.statusCode}] ${response.body}");
      return false;
    }
  }

  Future<bool> postTransaction(BuildContext context, EntryItem item) async {

    // TODO : special character encode
    var entryJson = jsonEncode(item.toJson());
    String params = "section_id=${_getSectionID(context)}&data_type=json&entries=[$entryJson]";

    print("section ID = ${_getSectionID(context)}");

    print("params--------------------------------------------");
    print(params);
    print("params--------------------------------------------");

    final response =
    await http.post(urlEntryItem, headers: _headers, body: params);
    if (response.statusCode == 200) {

      final body = jsonDecode(response.body);
      print(body["results"]);

      return true;
    } else {
      print(
          "Fetch token is failed!!!, [${response.statusCode}] ${response.body}");
      return false;
    }
  }

}
