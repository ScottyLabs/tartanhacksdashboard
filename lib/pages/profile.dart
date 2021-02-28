import 'package:flutter/material.dart';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import 'login.dart';


class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => new _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {


  @override
  initState() {
    super.initState();
  }

  void _showDialog(String response, String title) {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text(title),
          content: new Text(response),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text(
                "OK",
                style: new TextStyle(color: Colors.white),
              ),
              color: new Color.fromARGB(255, 255, 75, 43),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: PreferredSize(
          child: new AppBar(
            title: new Text(
              'Hacker Profile',
              textAlign: TextAlign.center,
              style: new TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            backgroundColor: Color.fromARGB(255, 37, 130, 242),
          ),
          preferredSize: Size.fromHeight(60)),
      body: Padding(
        padding: EdgeInsets.all(20),

      ),
    );
  }
}
