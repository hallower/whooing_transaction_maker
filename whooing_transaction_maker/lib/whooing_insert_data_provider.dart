import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:whooing_transaction_maker/models/account_item.dart';
import 'package:whooing_transaction_maker/models/monthly_item.dart';
import 'package:whooing_transaction_maker/models/insert_state_model.dart';
import 'package:whooing_transaction_maker/whooing_auth.dart';

class WhooingInsertDataProvider {
  final urlDefaultSection = "https://whooing.com/api/sections/default.json";
  final urlAllAccounts = "https://whooing.com/api/accounts.json_array";
  final urlMonthlyItems = "https://whooing.com/api/monthly_items.json_array";

  String _sectionID;
  Map<String, String> _headers;

  WhooingInsertDataProvider() {
    _sectionID = "";
    _headers = {
      "X-API-KEY": WhooingAuth().getXapiKey(),
      "Content-Type": 'application/x-www-form-urlencoded',
    };
  }

  Future<bool> getDefaultSection(BuildContext context) async {

    if(_sectionID.isNotEmpty)
      return true;

    final response = await http.get(urlDefaultSection, headers: _headers);
    if (response.statusCode == 200) {
      print(response.body);

      final body = jsonDecode(response.body);
      _sectionID = body["results"]["section_id"];
      print("section ID = $_sectionID");

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
    String params = "?section_id=$_sectionID";

    final response = await http.get(urlAllAccounts + params, headers: _headers);
    if (response.statusCode == 200) {
      /*
      "results" : {
        "assets" : {
            "x1" : {
            "account_id" : "x1",
            "type" : "group",
            "title" : "유동자산",
            "memo" : "바로쓸 수 있는 것들",
            "open_date" : 20090511,
            "close_date" : 20160101,
            "category" : "",
            },
            "x2" : {
              "account_id" : "x2",
              "type" : "account",
              "title" : "현금",
              "memo" : "내 지갑 및 서랍에 있는 돈",
              "open_date" : 20090511,
              "close_date" : 20160101,
              "category" : "normal",
            }
        },
        "liabilities" : {
        },
        "income" : {
        },
        "expenses" : {
        }
       */
      final body = jsonDecode(response.body);
      List<AccountItem> items = new List();
      var result = body["results"];
      result.forEach((key, value){
        print("Account type = $key");

        value.forEach((account){
          var parsedAccount = AccountItem.fromJson(account);
          parsedAccount.classification = key;
          print(" - Account = ${parsedAccount.title}");

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
    String params = "?section_id=$_sectionID";

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
            // item in slot
            print("item = $item");
            // TODO : remove
            var parsedItem = MonthlyItem.fromJson(item);
            print("pared = ${parsedItem.title}!!");

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
}
