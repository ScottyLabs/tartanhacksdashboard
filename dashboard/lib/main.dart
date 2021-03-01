import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'app.dart';
import 'login-savecreds.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  static bool loggedin = false;
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}



class _MyHomePageState extends State<MyHomePage> {
  bool _loaded = false;


  Future<void> checkLoginStatus() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String result = pref.get('name');
    setState(() {
      _loaded = true;
      if (result != null) MyApp.loggedin = true;
    });
  }

  @override
  void initState() {
    super.initState();
    checkLoginStatus();
  }

  @override
  Widget build(BuildContext context) {
    return _loaded ? (MyApp.loggedin ? App() : LogIn()) : Container();
  }
}
