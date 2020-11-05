/*
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
 */

class MonthlyItem {
  String id;
  String title;
  String money;
  String leftAccountTitle;
  String leftAccountID;
  String rightAccountTitle;
  String rightAccountID;
  int payDay;
  String dueDate;
  int dDay;
  String paidDate;

  MonthlyItem(
      this.id,
      this.title,
      this.money,
      this.leftAccountTitle,
      this.leftAccountID,
      this.rightAccountTitle,
      this.rightAccountID,
      this.payDay,
      this.dueDate,
      this.dDay,
      this.paidDate);

  MonthlyItem.fromJson(Map<String, dynamic> json)
      : id = json['item_id'],
        title = json['item'].toString().trim(),
        money = json['money'].toString(),
        leftAccountTitle = json['l_account'],
        leftAccountID = json['l_account_id'],
        rightAccountTitle = json['r_account'],
        rightAccountID = json['r_account_id'],
        payDay = json['pay_date'],
        dueDate = json['due_date'].toString(),
        dDay = json['d_day'],
        paidDate = json['paid_date'].toString();

  Map<String, dynamic> toJson() => {
        'item_id': id,
        'item': title,
        'money': int.parse(money),
        'l_account': leftAccountTitle,
        'l_account_id': leftAccountID,
        'r_account': rightAccountTitle,
        'r_account_id': rightAccountID,
        'pay_date': payDay,
        'due_date': int.parse(dueDate),
        'd_day': dDay,
        'paid_date': int.parse(paidDate),
      };
}
