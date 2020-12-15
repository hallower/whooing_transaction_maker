import 'dart:convert';

class EntryItem {
  String id;
  String date;
  String leftAccountID;
  String leftAccountTitle;
  String rightAccountID;
  String rightAccountTitle;
  String title;
  String money;
  String total;
  String memo;
  String appID;

  EntryItem(this.id,
      this.date,
      this.leftAccountID,
      this.leftAccountTitle,
      this.rightAccountID,
      this.rightAccountTitle,
      this.title,
      this.money,
      this.total,
      this.memo,
      this.appID);

  EntryItem.fromJson(Map<String, dynamic> json)
      : id = json['entry_id'].toString(),
        date = json['entry_date'].toString(),
        leftAccountID = json['l_account_id'],
        leftAccountTitle = json['l_account'],
        rightAccountID = json['r_account_id'],
        rightAccountTitle = json['r_account'],
        title = json['item'],//Utf8Decoder().convert(json['item']),
        money = json['money'].toString(),
        total = json['total'].toString(),
        memo = json['memo'],//Utf8Decoder().convert(json['memo']),
        appID = json['app_id'].toString();

  Map<String, dynamic> toJson() {
    var result = Map<String, dynamic>();

    if (id.isNotEmpty)
      result.putIfAbsent('entry_id', () => int.parse(id));
    result.putIfAbsent('entry_date', () => int.parse(date));
    result.putIfAbsent('l_account_id', () => leftAccountID);
    result.putIfAbsent('l_account', () => leftAccountTitle);
    result.putIfAbsent('r_account_id', () => rightAccountID);
    result.putIfAbsent('r_account', () => rightAccountTitle);
    result.putIfAbsent('item', () => title); //Utf8Encoder().convert(title));
    result.putIfAbsent('money', () => int.parse(money));
    if (total.isNotEmpty)
      result.putIfAbsent('total', () => int.parse(total));
    if (memo.isNotEmpty)
      result.putIfAbsent('memo', () => memo); //Utf8Encoder().convert(memo),
    if (appID.isNotEmpty)
      result.putIfAbsent('app_id', () => appID);

    return result;
  }
}
