class AccountItem {
  String id;
  String classification;
  bool isGroup;
  String title;
  String memo;
  String startDate;
  String endDate;
  String category;

  AccountItem(this.id, this.isGroup, this.title, this.memo, this.startDate,
      this.endDate, this.category);

  AccountItem.fromJson(Map<String, dynamic> json)
      : id = json['account_id'],
        isGroup = (json['type'] == "group"),
        title = json['title'].toString().trim(),
        memo = json['memo'],
        startDate = json['open_date'].toString(),
        endDate = json['close_date'].toString(),
        category = json['category'];

  Map<String, dynamic> toJson() => {
        'account_id': id,
        'type': isGroup ? "group" : "account",
        'title': title,
        'memo': memo,
        'open_date': int.parse(startDate),
        'close_date': int.parse(endDate),
        'category': category,
      };
}
