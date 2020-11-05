import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:whooing_transaction_maker/models/insert_state_model.dart';
import 'package:whooing_transaction_maker/models/signin_state_model.dart';
import 'splash_page.dart';
import 'main_page.dart';
import 'whooing_signin_page.dart';

void main() {
  /*
      ChangeNotifierProvider(
        create: (_) => SigninStatusModel(),
        child: WimpleApp(),
      )
     */
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider<SigninStatusModel>(create: (_) => SigninStatusModel()),
      ChangeNotifierProvider<InsertStateModel>(create: (_) => InsertStateModel()),
    ],
    child: WimpleApp(),
  ));
}

class WimpleApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Whooing Transaction Maker',
      theme: ThemeData(
        primarySwatch: Colors.orange,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => SplashPage(),
        '/home': (context) => MainPage(),
      },
    );
  }
}
