import 'package:flutter/material.dart';
import 'splash_page.dart';
import 'main_page.dart';
import 'whooing_signin_page.dart';

void main() {
  runApp(WimpleApp());
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
        //'/': (context) => MainPage(),
        '/home': (context) => MainPage(),
      },
    );
  }
}
