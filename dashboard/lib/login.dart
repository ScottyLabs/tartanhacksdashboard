import 'package:flutter/material.dart';
import 'main.dart';

class LogIn extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      key: key,
      home: Center(
      child: RaisedButton(
        onPressed: () => key.currentState.pushNamed('/app'),
        child: Text("Tap here to just access the app. Dev only."),
      ),
    ));
  }

}