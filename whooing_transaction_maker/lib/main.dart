import 'package:flutter/material.dart';
import 'splash_page.dart';
import 'insert_page.dart';

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
        // This makes the visual density adapt to the platform that you run
        // the app on. For desktop platforms, the controls will be smaller and
        // closer together (more dense) than on mobile platforms.
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => SplashPage(),
        '/insert' : (context) => InsertPage(),
        //'/list': (context) => ListPage(),
      },
    );
  }
}
