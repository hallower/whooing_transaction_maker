// Copyright 2018 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:whooing_transaction_maker/whooing_auth.dart';

class WhooingSigninPage extends StatefulWidget {
  WhooingSigninPage(this._tempToken);

  final String _tempToken;

  @override
  _WhooingSigninPageState createState() => _WhooingSigninPageState(_tempToken);
}

class _WhooingSigninPageState extends State<WhooingSigninPage> {
  final String _tempToken;

  _WhooingSigninPageState(this._tempToken);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // We're using a Builder here so we have a context that is below the Scaffold
      // to allow calling Scaffold.of(context) so we can show a snackbar.
      body: Builder(builder: (BuildContext context) {
        return WebView(
          initialUrl:
              'https://whooing.com/app_auth/authorize?token=$_tempToken&no_register=y',
          javascriptMode: JavascriptMode.unrestricted,
          gestureNavigationEnabled: true,
          javascriptChannels: <JavascriptChannel>[
            _toasterJavascriptChannel(context),
          ].toSet(),

          navigationDelegate: (NavigationRequest request) {
            
            if (request.url.contains("pin=")) {
              var startPos = request.url.indexOf("pin=") + 4;
              var endPos = request.url.indexOf("&", startPos);
              var pin;

              if (-1 == endPos) {
                pin = request.url.substring(startPos, request.url.length);
              } else {
                pin = request.url.substring(startPos, endPos);
              }

              WhooingAuth().setPin(pin);
              Navigator.pop(context, true);
              return NavigationDecision.prevent;
            }
            
            return NavigationDecision.navigate;
          },
        );
      }),
    );
  }

  JavascriptChannel _toasterJavascriptChannel(BuildContext context) {
    return JavascriptChannel(
        name: 'Toaster',
        onMessageReceived: (JavascriptMessage message) {
          Scaffold.of(context).showSnackBar(
            SnackBar(content: Text(message.message)),
          );
        });
  }
}
