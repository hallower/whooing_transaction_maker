import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:whooing_transaction_maker/models/entry_item.dart';
import 'package:whooing_transaction_maker/models/insert_state_model.dart';
import 'package:whooing_transaction_maker/whooing_insert_data.dart';

import 'models/account_item.dart';

final ItemScrollController insertLeftListController = ItemScrollController();
final ItemScrollController insertRightListController = ItemScrollController();
// TODO : dispose
final textControlItemPrice =
    TextEditingController(); //MoneyMaskedTextController(decimalSeparator: '.', thousandSeparator: ',')

Widget getInsertPage(BuildContext context) {
  return Column(
    children: [
      Expanded(flex: 5, child: __upperSection(context)),
      Column(children: [
        __middleSection(context),
        Container(
          height: 200,
          child: __lowerSection(context),
        )
      ]),
    ],
  );
}

Widget __upperSection(BuildContext context) {
  textControlItemPrice.text =
      (Provider.of<InsertStateModel>(context).selectedMonthlyItemIndex != -1)
          ? Provider.of<InsertStateModel>(context)
              .monthlyItems[Provider.of<InsertStateModel>(context)
                  .selectedMonthlyItemIndex]
              .money
          : "";

  return Row(
    children: [
      Expanded(
        flex: 6,
        child: ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: Provider.of<InsertStateModel>(context).monthlyItems.length,
          shrinkWrap: true,
          itemBuilder: (BuildContext context, int index) {
            return GestureDetector(
                child: Container(
                    margin: const EdgeInsets.all(4.0),
                    padding: const EdgeInsets.all(4.0),
                    decoration: BoxDecoration(
                      border: Border.all(width: 1.0),
                      borderRadius: BorderRadius.all(Radius.circular(5.0)),
                    ),
                    child: Center(
                        child: Text(
                      Provider.of<InsertStateModel>(context)
                          .monthlyItems[index]
                          .title,
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.w300,
                      ),
                    ))),
                onTap: () {
                  Provider.of<InsertStateModel>(context)
                      .setMonthlyItemIndex(index);
                });
          },
        ),
      ),
      Expanded(
          flex: 4,
          child: Column(
            children: [
              Container(
                  margin: const EdgeInsets.all(4.0),
                  padding: const EdgeInsets.all(4.0),
                  decoration: BoxDecoration(
                    border: Border.all(width: 1.0),
                    borderRadius: BorderRadius.all(Radius.circular(5.0)),
                  ),
                  child: GestureDetector(
                      onTap: () async {
                        final DateTime picked = await showDatePicker(
                          context: context,
                          initialDate: Provider.of<InsertStateModel>(context)
                              .date,
                          firstDate: DateTime(DateTime.now().year - 1),
                          lastDate: DateTime(DateTime.now().year + 10),
                        );
                        if (picked != null && picked != Provider.of<InsertStateModel>(context).date)
                          Provider.of<InsertStateModel>(context).setDate(picked);
                      },
                      child: Text(
                        new DateFormat.MMMMd().format(
                            Provider.of<InsertStateModel>(context).date),
                        style: TextStyle(
                          color: Colors.grey[500],
                          fontSize: 20,
                          fontWeight: FontWeight.w300,
                        ),
                      ))),
              Container(
                  margin: const EdgeInsets.all(4.0),
                  padding: const EdgeInsets.all(4.0),
                  decoration: BoxDecoration(
                    border: Border.all(width: 1.0),
                    borderRadius: BorderRadius.all(Radius.circular(5.0)),
                  ),
                  child: TextFormField(
                    /*decoration: InputDecoration(
                      border: InputBorder.none, hintText: 'Enter price'),

                   */
                    /*
                initialValue: (Provider.of<InsertStateModel>(context)
                            .selectedMonthlyItemIndex !=
                        -1)
                    ? Provider.of<InsertStateModel>(context)
                        .monthlyItems[Provider.of<InsertStateModel>(context)
                            .selectedMonthlyItemIndex]
                        .money
                    : "0",
                */
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'[0-9.-]')),
                    ],
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.w800,
                    ),
                    controller: textControlItemPrice,
                  )),
              RaisedButton(
                onPressed: () async {

                  if (textControlItemPrice.text.isEmpty ||
                      textControlItemPrice.text.compareTo("0") == 0) {
                    // TODO : toast
                    print("Invalid Price!!!");
                    return;
                  }

                  var leftItemIndex = Provider.of<InsertStateModel>(context)
                      .selectedLeftAccountItemIndex;
                  var rightItemIndex = Provider.of<InsertStateModel>(context)
                      .selectedRightAccountItemIndex;

                  if (leftItemIndex == -1 || rightItemIndex == -1) {
                    Scaffold.of(context).showSnackBar(SnackBar(
                      content: Text("Please select left, right accounts."),
                    ));
                    return;
                  }

                  var selectedMonthlyItem =
                      Provider.of<InsertStateModel>(context).monthlyItems[
                          Provider.of<InsertStateModel>(context)
                              .selectedMonthlyItemIndex];

                  AccountItem leftItem = Provider.of<InsertStateModel>(context)
                      .leftAccounts[leftItemIndex];
                  AccountItem rightItem = Provider.of<InsertStateModel>(context)
                      .leftAccounts[rightItemIndex];


                  var formatter = new DateFormat('yyyyMMdd');
                  var day = formatter.format(Provider.of<InsertStateModel>(context).date);

                  // TODO : change this
                  // TODO : special character check
                  EntryItem testItem = EntryItem(
                      "",
                      day,
                      leftItem.id,
                      leftItem.classification,
                      rightItem.id,
                      rightItem.classification,
                      selectedMonthlyItem.title,
                      textControlItemPrice.text,
                      "",
                      "",
                      "");

                  var res = await WhooingInsertData()
                      .postTransaction(context, testItem);

                  /*
                  if (res) {
                    Scaffold.of(context).showSnackBar(SnackBar(
                      content: Text("Submit succeed"),
                    ));
                  } else {
                    Scaffold.of(context).showSnackBar(SnackBar(
                      content: Text("Submit failed"),
                    ));
                  }
                  */
                },
                child: const Text('Button',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    )),
              ),
            ],
          )),
    ],
  );
}

Widget __middleSection(BuildContext context) {
  return Row(children: [
    Expanded(
        flex: 5,
        child: Container(
            margin: const EdgeInsets.all(4.0),
            padding: const EdgeInsets.all(10.0),
            decoration: BoxDecoration(
              color: Colors.grey[400],
              border: Border.all(width: 1.0),
              borderRadius: BorderRadius.all(Radius.circular(15.0)),
            ),
            child: Text('Left',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.red[500],
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                )))),
    Expanded(
        flex: 5,
        child: Container(
            margin: const EdgeInsets.all(4.0),
            padding: const EdgeInsets.all(10.0),
            decoration: BoxDecoration(
              color: Colors.grey[400],
              border: Border.all(width: 1.0),
              borderRadius: BorderRadius.all(Radius.circular(15.0)),
            ),
            child: Text('Right',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.blue[500],
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                )))),
  ]);
}

Widget __lowerSection(BuildContext context) {
  return Row(
    children: [
      Expanded(
        flex: 5,
        child: ScrollablePositionedList.builder(
          padding: const EdgeInsets.all(16),
          itemCount: Provider.of<InsertStateModel>(context).leftAccounts.length,
          itemScrollController: insertLeftListController,
          itemBuilder: (BuildContext context, int index) {
            var selectedIndex = Provider.of<InsertStateModel>(context)
                .selectedLeftAccountItemIndex;

            var selectedStyle = (selectedIndex == -1 || selectedIndex != index)
                ? null
                : TextStyle(
                    color: Colors.red[500],
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  );

            return GestureDetector(
              child: Container(
                child: Container(
                    margin: const EdgeInsets.all(2.0),
                    padding: const EdgeInsets.all(4.0),
                    decoration: BoxDecoration(
                      border: Border.all(width: 1.0),
                      borderRadius: BorderRadius.all(Radius.circular(5.0)),
                    ),
                    child: Center(
                        child: Text(
                            Provider.of<InsertStateModel>(context)
                                .leftAccounts[index]
                                .title,
                            style: selectedStyle))),
              ),
              onTap: () {
                Provider.of<InsertStateModel>(context).setLeftItemIndex(index);
              },
            );
          },
        ),
      ),
      Expanded(
        flex: 5,
        child: ScrollablePositionedList.builder(
          padding: const EdgeInsets.all(16),
          itemCount:
              Provider.of<InsertStateModel>(context).rightAccounts.length,
          itemScrollController: insertRightListController,
          itemBuilder: (BuildContext context, int index) {
            var selectedIndex = Provider.of<InsertStateModel>(context)
                .selectedRightAccountItemIndex;

            var selectedStyle = (selectedIndex == -1 || selectedIndex != index)
                ? null
                : TextStyle(
                    color: Colors.blue[500],
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  );

            return GestureDetector(
              child: Container(
                margin: const EdgeInsets.all(2.0),
                padding: const EdgeInsets.all(4.0),
                decoration: BoxDecoration(
                  border: Border.all(width: 1.0),
                  borderRadius: BorderRadius.all(Radius.circular(5.0)),
                ),
                child: Center(
                    child: Text(
                        Provider.of<InsertStateModel>(context)
                            .rightAccounts[index]
                            .title,
                        style: selectedStyle)),
              ),
              onTap: () {
                Provider.of<InsertStateModel>(context).setRightItemIndex(index);
              },
            );
          },
        ),
      ),
    ],
  );
}
