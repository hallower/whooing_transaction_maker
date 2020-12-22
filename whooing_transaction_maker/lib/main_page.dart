import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:whooing_transaction_maker/settings_page.dart';
import 'package:whooing_transaction_maker/whooing_list_data.dart';
import 'models/list_state_model.dart';
import 'whooing_insert_data.dart';
import 'insert_page.dart';
import 'list_page.dart';
import 'models/insert_state_model.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

//enum TabTitle { InsertTab, ListTab, SettingsTab}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;

  final WhooingInsertData wdp = WhooingInsertData();

  @override
  void initState() {
    super.initState();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Widget _getPage(BuildContext context) {
    print("get page $_selectedIndex");
    switch (_selectedIndex) {
      case 0://TabTitle.InsertTab:
        return getInsertPage(context);
      case 1://TabTitle.ListTab:
        return getListPage(context);
      case 2://TabTitle.SettingsTab:
        return getSettingsPage(context);
    }
    return Text('Oops');
  }

  void _handleWidgetsAfterBuild() {

    switch (_selectedIndex) {
      case 0://TabTitle.InsertTab:
        {
          var leftIndex = Provider
              .of<InsertStateModel>(context)
              .selectedLeftAccountItemIndex;
          var rightIndex = Provider
              .of<InsertStateModel>(context)
              .selectedRightAccountItemIndex;

          print("Widget positioning, left=$leftIndex, right=$rightIndex");
          if (leftIndex != -1)
            insertLeftListController.scrollTo(index: leftIndex, duration: Duration(milliseconds: 500));

          if (rightIndex != -1)
            insertRightListController.scrollTo(index: rightIndex, duration: Duration(milliseconds: 500));
        }
        break;
      case 1://TabTitle.ListTab:
        if(Provider.of<ListStateModel>(context).notInitialized) {
          print("List Tab is not initialized");
          WhooingListData().getEntriesOf3Days(context);
        }
        break;
      case 2://TabTitle.SettingsTab:
        break;
    }
  }

  Widget _makeBottomNavigationBar() {
    return BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.input),
            title: Text('Insert'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            title: Text('List'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            title: Text('Settings'),
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped);
  }


  @override
  Widget build(BuildContext context) {
    wdp.getDefaultSection(context);

    print("build main page!!!");

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _handleWidgetsAfterBuild();
    });

    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        title: Text("Insert Page"),
      ),
      body: _getPage(context),
      bottomNavigationBar: _makeBottomNavigationBar(),
    );
  }
}
