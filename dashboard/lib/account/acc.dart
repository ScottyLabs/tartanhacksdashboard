import 'package:dashboard/main.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../login-savecreds.dart';

class AccountHome extends StatelessWidget {
  final Function logoff;
  AccountHome(this.logoff);




  // Future<void> logout(context) async {
  //     final SharedPreferences prefs = await SharedPreferences.getInstance();
  //     prefs.setString('name', null);
  //     prefs.setString('id', null);
  //     prefs.setBool('admin', false);
  //     prefs.setString('token', null);
  //     MyApp.loggedin = false;
  //     Navigator.pop(context);
  //   }



  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
        body: Container(
          // decoration: new BoxDecoration(color: Colors.black), - black background
            padding: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width * 0.05),
            height: height,
            width: width,
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "Logged in.",
                    style: TextStyle(fontSize: 20)
                  ),
                  SizedBox(height: 20),
                  RaisedButton(
                    child: Text("Log Out",
                        style: TextStyle(fontSize: 30, color: Colors.white)),
                    color: Color(0xffE21031),
                    onPressed: () {
                      logoff(context);
                    }
                  )
                ]
            )
        )
    );
  }
}
  