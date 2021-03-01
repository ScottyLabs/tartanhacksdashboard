import 'package:flutter/material.dart';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import 'login.dart';
import 'package:url_launcher/url_launcher.dart';
import 'profile.dart';
import 'package:flutter_countdown_timer/flutter_countdown_timer.dart';
import 'package:thdapp/models/participant_model.dart';
import 'package:thdapp/models/login_model.dart';
import 'package:thdapp/api.dart';
import 'events_home.dart';




class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => new _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  SharedPreferences prefs;
  int selectedIndex = 0;

  Participant userData = null;



  @override
  initState() {
    super.initState();
    getProfileData();
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

  void logOut() async {
    prefs = await SharedPreferences.getInstance();
    await prefs.clear();

    Navigator.pushReplacement(
      context,
      new MaterialPageRoute(builder: (ctxt) => new LoginScreen()),
    );
  }

  void onNavigationItemTapped(int index) {
    setState(() {
      selectedIndex = index;

      if (selectedIndex==1){

        Navigator.pushReplacement(
          context,
          new MaterialPageRoute(builder: (ctxt) => new EventsHomeScreen()),
        );

      }else if(selectedIndex == 2) {

      } else if (selectedIndex == 3) {

      }else if (selectedIndex == 4) {

      }
    });
  }

  openUrl(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  void getProfileData() async{
    prefs = await SharedPreferences.getInstance();

    String email = prefs.get('email');
    String password = prefs.get('password');

    Login  loginData = await checkCredentials(email, password);
    userData = loginData.user;

    setState(() {

    });
  }

  @override
  Widget build(BuildContext context) {

    if(userData == null){
      return new Scaffold(
        appBar: PreferredSize(
            child: new AppBar(
              title: new Text(
                'TartanHacks 2021',
                textAlign: TextAlign.center,
                style: new TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              backgroundColor: Color.fromARGB(255, 37, 130, 242),
              actions: <Widget>[
                IconButton(
                  icon: Icon(Icons.exit_to_app),
                  onPressed: () {
                    logOut();
                  },
                  color: Colors.white,
                )
              ],
            ),
            preferredSize: Size.fromHeight(60)),
      );
    }else{
      return new Scaffold(
        appBar: PreferredSize(
            child: new AppBar(
              title: new Text(
                'TartanHacks 2021',
                textAlign: TextAlign.center,
                style: new TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              backgroundColor: Color.fromARGB(255, 37, 130, 242),
              actions: <Widget>[
                IconButton(
                  icon: Icon(Icons.exit_to_app),
                  onPressed: () {
                    logOut();
                  },
                  color: Colors.white,
                )
              ],
            ),
            preferredSize: Size.fromHeight(60)),
        body: Padding(
          padding: EdgeInsets.all(20),
          child: ListView(
            children: <Widget>[
              Card(
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Padding(
                    padding: EdgeInsets.all(15),
                    child: Column(
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Expanded(
                              flex: 5,
                              child: new Text(
                                'Hi '+userData.name+'!',
                                textAlign: TextAlign.left,
                                style: new TextStyle(
                                  fontWeight: FontWeight.w300,
                                  fontSize: 30,
                                ),
                              ),
                            ),
                            Expanded(
                                flex: 3,
                                child: RaisedButton(
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                ProfileScreen(userData:userData)));
                                  },
                                  color: Color.fromARGB(255, 37, 130, 242),
                                  child: new Text(
                                    "View Profile",
                                    style: new TextStyle(color: Colors.white),
                                  ),
                                ))
                          ],
                        ),
                        Padding(
                          padding:
                          EdgeInsets.symmetric(vertical: 20, horizontal: 0),
                          child: Text(
                            "Welcome to TartanHacks 2021. Here are all the places where the hacking is happening:",
                            style: new TextStyle(fontSize: 18),
                          ),
                        ),
                        Row(
                          children: <Widget>[
                            Expanded(
                                flex: 2,
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 5, vertical: 0),
                                  child: RaisedButton(
                                    onPressed: () {
                                      openUrl("http://href.scottylabs.org/discord");
                                    },
                                    color: Color.fromARGB(255, 114, 137, 218),
                                    child: new Text(
                                      "Discord",
                                      style: new TextStyle(color: Colors.white),
                                    ),
                                  ),
                                )),
                            Expanded(
                                flex: 2,
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 5, vertical: 0),
                                  child: RaisedButton(
                                    onPressed: () {
                                      openUrl("http://href.scottylabs.org/hopin");
                                    },
                                    color: Color.fromARGB(255, 23, 95, 255),
                                    child: new Text(
                                      "Hopin",
                                      style: new TextStyle(color: Colors.white),
                                    ),
                                  ),
                                )),
                            Expanded(
                                flex: 2,
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 5, vertical: 0),
                                  child: RaisedButton(
                                    onPressed: () {
                                      openUrl("https://tartanhacks.com");
                                    },
                                    color: Colors.red,
                                    child: new Text(
                                      "TH Website",
                                      style: new TextStyle(color: Colors.white),
                                    ),
                                  ),
                                )),
                          ],
                        ),
                      ],
                    )),
              ),
              Padding(
                padding: EdgeInsets.all(8),
              ),
              Card(
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Padding(
                    padding: EdgeInsets.all(15),
                    child: Column(
                      children: <Widget>[
                        Text(
                          "HACKING TIME LEFT",
                          style: new TextStyle(
                              fontSize: 25, fontWeight: FontWeight.w600),
                        ),
                        Padding(
                          padding: EdgeInsets.all(10),
                        ),
                        CountdownTimer(
                          endTime: 1615136400000,
                          textStyle: new TextStyle(
                            color: Color.fromARGB(255, 37, 130, 242),
                            fontSize: 30,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(10),
                        ),
                        ButtonTheme(
                            minWidth: double.infinity,
                            child: RaisedButton(
                              onPressed: () {
                                //TODO: OPen project page
                              },
                              color: Color.fromARGB(255, 37, 130, 242),
                              child: new Text(
                                "View Your Project",
                                style: new TextStyle(color: Colors.white),
                              ),
                            )
                        )

                      ],
                    )),
              ),
            ],
          ),
        ),
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
                icon: Icon(Icons.dashboard), title: Text('HOME')),
            BottomNavigationBarItem(
                icon: Icon(Icons.event), title: Text('SCHEDULE')),
            BottomNavigationBarItem(
                icon: Icon(Icons.code), title: Text('PROJECT')),
            BottomNavigationBarItem(
                icon: Icon(Icons.videogame_asset), title: Text('POINTS')),
          ],
          currentIndex: selectedIndex,
          fixedColor: Color.fromARGB(255, 37, 130, 242),
          onTap: onNavigationItemTapped,
        ),
      );
    }

  }
}
