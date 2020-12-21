import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:whooing_transaction_maker/whooing_list_data.dart';

import 'models/insert_state_model.dart';
import 'models/list_state_model.dart';

final int limitOfAcountTitle = 6;
final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
    new GlobalKey<RefreshIndicatorState>();
// TODO : Remove this, do not do like this.
BuildContext _context;

Future<void> _refresh() {
  return new Future.delayed(Duration.zero, () {
    WhooingListData().getEntriesOf3Days(_context);
  });
}

Widget getListPage(BuildContext context) {
  _context = context;

  return Column(
    children: [
      Expanded(
        flex: 6,
        child: RefreshIndicator(
          key: _refreshIndicatorKey,
          onRefresh: _refresh,
          child: ListView.builder(
            padding: const EdgeInsets.all(8),
            itemCount: Provider.of<ListStateModel>(context).entryItems.length,
            shrinkWrap: true,
            itemBuilder: (BuildContext context, int index) {
              return GestureDetector(
                child: Container(
                    margin: const EdgeInsets.all(4.0),
                    padding: const EdgeInsets.all(4.0),
                    decoration: BoxDecoration(
                      border: Border.all(width: 1.0),
                      borderRadius: BorderRadius.all(Radius.circular(5.0)),
                    ), //             <--- BoxDecoration here
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Text(
                                  "${Provider.of<ListStateModel>(context).entryItems[index].date.substring(0, 4)}-"
                                  "${Provider.of<ListStateModel>(context).entryItems[index].date.substring(4, 6)}-"
                                  "${Provider.of<ListStateModel>(context).entryItems[index].date.substring(6, 8)}",
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w300,
                                  ),
                                ),
                                Container(
                                    margin: const EdgeInsets.all(4.0),
                                    padding: const EdgeInsets.all(4.0),
                                    decoration: BoxDecoration(
                                      border: Border.all(width: 1.0),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(5.0)),
                                    ), //             <--- BoxDecoration here
                                    child: Text(
                                      "${(Provider.of<InsertStateModel>(context).accountItems[Provider.of<ListStateModel>(context).entryItems[index].leftAccountID].title.length>limitOfAcountTitle)?
                                      Provider.of<InsertStateModel>(context).accountItems[Provider.of<ListStateModel>(context).entryItems[index].leftAccountID].title.substring(0,limitOfAcountTitle):
                                      Provider.of<InsertStateModel>(context).accountItems[Provider.of<ListStateModel>(context).entryItems[index].leftAccountID].title}",
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w300,
                                      ),
                                    )),
                                Container(
                                    margin: const EdgeInsets.all(4.0),
                                    padding: const EdgeInsets.all(4.0),
                                    decoration: BoxDecoration(
                                      border: Border.all(width: 1.0),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(5.0)),
                                    ), //             <--- BoxDecoration here
                                    child: Text(
                                      "${(Provider.of<InsertStateModel>(context).accountItems[Provider.of<ListStateModel>(context).entryItems[index].rightAccountID].title.length>limitOfAcountTitle)?
                                      Provider.of<InsertStateModel>(context).accountItems[Provider.of<ListStateModel>(context).entryItems[index].rightAccountID].title.substring(0,limitOfAcountTitle):
                                      Provider.of<InsertStateModel>(context).accountItems[Provider.of<ListStateModel>(context).entryItems[index].rightAccountID].title}",
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w300,
                                      ),
                                    )),
                              ]),
                          Text(
                            "${(Provider.of<ListStateModel>(context).entryItems[index].title.length > 6) ?
                            Provider.of<ListStateModel>(context).entryItems[index].title.substring(0, 6) :
                            Provider.of<ListStateModel>(context).entryItems[index].title}",
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                          Column(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Container(
                                  margin: const EdgeInsets.all(8.0),
                                  padding: const EdgeInsets.all(8.0),
                                  decoration: BoxDecoration(
                                    border: Border(
                                        bottom: BorderSide(
                                            color: Colors.black, width: 2.0)),
                                  ), //             <--- BoxDecoration here
                                  child: Text(
                                    "${Provider.of<ListStateModel>(context).entryItems[index].money}",
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w300,
                                    ),
                                  ),
                                ),
                                Text(
                                  "${Provider.of<ListStateModel>(context).entryItems[index].total}",
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w300,
                                  ),
                                ),
                              ]),
                        ])),
                onTap: () {
                  print("onTap, ${index} selected");
                  Provider.of<ListStateModel>(context).setEntryItemIndex(index);
                },
              );
            },
          ),
        ),
      )
    ],
  );
}
