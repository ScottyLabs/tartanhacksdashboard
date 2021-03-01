import 'package:dashboard/hackathon/hack.dart';
import 'package:dashboard/info/info.dart';
import 'package:flutter/material.dart';

import 'package:dashboard/account/acc.dart';

import 'home/home.dart';



class App extends StatelessWidget {
  // This widget is the root of your application.
  final Function logoff;

  MyHomePage(this.logoff);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(this.logoff),
    );
  }
}

class MyHomePage extends StatefulWidget {
  final Function logoff;
  MyHomePage(this.logoff, {Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState(logoff);
}

class _MyHomePageState extends State<MyHomePage> {
  final Function logoff;
  _MyHomePageState(this.logoff);

  int _selectedIndex = 0;
  List<Widget> _widgetOptions = <Widget>[
    Home(),
    HackHome(),
    InfoHome(),
    AccountHome(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Home"
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.code),
            label: "Hackathon"
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.info),
            label: "Information"
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: "Account"
          )
        ],
        selectedItemColor: Colors.red,
        currentIndex: _selectedIndex,
        onTap: (index) => setState(
          () {
            _selectedIndex = index;
          } 
        ),
      ),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
