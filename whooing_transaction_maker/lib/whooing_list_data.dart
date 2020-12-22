import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:whooing_transaction_maker/models/entry_item.dart';
import 'package:whooing_transaction_maker/models/monthly_item.dart';
import 'package:whooing_transaction_maker/models/insert_state_model.dart';
import 'package:whooing_transaction_maker/whooing_auth.dart';

import 'models/list_state_model.dart';

class WhooingListData {
  final urlEntryItem = "https://whooing.com/api/entries.json";

  Map<String, String> _headers;

  WhooingListData() {
    print("WhooingListData()");
    _headers = {
      "X-API-KEY": WhooingAuth().getXapiKey(),
      "Content-Type": 'application/x-www-form-urlencoded',
    };
  }

  String _getSectionID(context) => Provider.of<InsertStateModel>(context).sectionID;
  void _setSectionID(context,id) => Provider.of<InsertStateModel>(context).setSectionID(id);

  Future<bool> getEntriesOf3Days(BuildContext context) async {
    return getEntries(context, 3);
  }

  Future<bool> getEntries(BuildContext context, int days) async {

    // TODO : date argument
    var now = new DateTime.now();
    var formatter = new DateFormat('yyyyMMdd');
    var endDate = formatter.format(now);
    var startDate = formatter.format(new DateTime(now.year, now.month, now.day-days));

    String params = "?section_id=${_getSectionID(context)}&start_date=$startDate&end_date=$endDate";

    print(params);

    final response =
    await http.get(urlEntryItem + params, headers: _headers);
    if (response.statusCode == 200) {
    /*
    {
	"code" : 200,
	"message" : "",
	"error_parameters" : {},
	"rest_of_api" : 4988,
	"results" : {
		"reports" : [],
		"rows" : [
			{
				"entry_id" : 1352827,
				"entry_date" : 20110817.0001,
				"l_account" : "expenses",
				"l_account_id" : "x20",
				"r_account" : "assets",
				"r_account_id" : "x4",
				"item" : "후원(과장학금)",
				"money" : 10000,
				"total" : 840721.99
				"memo" : "",
				"app_id" : 0,
				"attachments" : [
					{
						"uuid": "810cbdb1b-7486jvk57",
						"src": "https://denvz4zd77vw1.cloudfront.net/get/810cbdb1b-7486jvk57",
						"filename": "example.jpg",
						"mimeType": "image/jpeg",
						"size": 28098,
					},
					...
				]
			},
			{
				"entry_id" : 1352823,
				"entry_date" : 20110813.0001,
				"l_account" : "assets",
				"l_account_id" : "x3",
				"r_account" : "assets",
				"r_account_id" : "x4",
				"item" : "계좌이체",
				"money" : 10000,
				"total" : 840721.99
				"memo" : "",
				"app_id" : 0,
				"attachments" : []
			}
		]
	}
}
     */
      print(response.body);

      final body = jsonDecode(response.body);

      List<EntryItem> items = new List();
      var result = body["results"]["rows"];

      result.forEach((item) {
            // item in slot
            print("item = $item");
            // TODO : remove
            var parsedItem = EntryItem.fromJson(item);
            print("pared = ${parsedItem.title}!!");

            if(parsedItem.title.isNotEmpty)
              items.add(parsedItem);
      });


      Provider.of<ListStateModel>(context, listen:false).setEntries(items);
      return true;
    } else {
      print(
          "Fetch token is failed!!!, [${response.statusCode}] ${response.body}");
      return false;
    }
  }


}
