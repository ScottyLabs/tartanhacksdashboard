import 'package:flutter/material.dart';
import 'app.dart';
import 'login-savecreds.dart';

final GlobalKey<NavigatorState> key = new GlobalKey<NavigatorState>();

void main() {
  runApp(FirstUp());
}

class FirstUp extends StatelessWidget {
  Widget build(BuildContext context) {
  return MaterialApp(
    home: LogIn(),
    navigatorKey: key,
    routes: <String, WidgetBuilder>{
      "/app": (context) => App(),
    },
  );
  }
}