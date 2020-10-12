import 'package:flutter/material.dart';

class SplashPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  _showMainPage(BuildContext context) =>
      Navigator.pushNamed(context, '/insert');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomPadding: false,
        body: Center(
            child: SizedBox(
          width: 400,
          height: 400,
          child: Column(
            children: [
              Text('Splash test!!!!',
                  style: TextStyle(
                    color: Colors.grey[500],
                    fontSize: 50,
                    fontWeight: FontWeight.w300,
                  )),
              RaisedButton(
                onPressed: () => _showMainPage(context),
                child: const Text('Next',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    )),
              ),
            ],
          ),
        )));
  }
}
