import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'anuda.dart';


void main() => runApp(EditEventApp());

class EditEventApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Events and Scheduling',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: editHomePage(title: 'Events and Scheduling'),
    );
  }
}

class editHomePage extends StatefulWidget {
  editHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _editHomePageState createState() => _editHomePageState();
}

class _editHomePageState extends State<editHomePage> {
  bool isAdmin = true;
  var eventData = [];

  final idController = new TextEditingController();
  final eventNameController = new TextEditingController();
  final eventDescController = new TextEditingController();
  final gcalLinkController = new TextEditingController();
  final zoomLinkController = new TextEditingController();
  final zoomIDController = new TextEditingController();
  final zoomPasswordController = new TextEditingController();
  final durationController = new TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    idController.dispose();
    eventNameController.dispose();
    eventDescController.dispose();
    gcalLinkController.dispose();
    zoomLinkController.dispose();
    zoomIDController.dispose();
    zoomPasswordController.dispose();
    durationController.dispose();
    //super.dispose();
  }


  @override
  void initState() {
    super.initState();
  }

  // String getTime(String unixDate) {
  //   var date =
  //   new DateTime.fromMillisecondsSinceEpoch(int.parse(unixDate) * 1000);
  //   date = date.toLocal();
  //   String formattedDate = DateFormat('hh:mm a').format(date);
  //   return formattedDate;
  // }

  @override
  Widget build(BuildContext context) {
    // if statement (if participant, return this... if admin, return with admin privileges)
    return MaterialApp(
      theme: ThemeData(fontFamily: 'TerminalGrotesque'),
      home: Scaffold(
          appBar: AppBar(
            title: Text(widget.title),
            backgroundColor: Color.fromARGB(255, 37, 130, 242), //blue
          ),
          backgroundColor: Color.fromARGB(240, 255, 255, 255), //gray
          body: Padding(
            padding: EdgeInsets.all(25.0),
            child:
                SingleChildScrollView(
                    child:Column(
                      children: [
                        TextField(
                          controller: idController,
                          decoration: InputDecoration(
                              labelText: 'Event ID (0 for new events)'
                          ),
                        ),
                        Padding(padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 0)),
                        TextField(
                          controller: eventNameController,
                          decoration: InputDecoration(
                                labelText: 'Event Name'
                            ),
                        ),
                        Padding(padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 0)),
                        TextField(
                          controller: eventDescController,
                          decoration: InputDecoration(
                              labelText: 'Event Description'
                            ),
                        ),
                        Padding(padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 0)),
                        TextField(
                          controller: gcalLinkController,
                          decoration: InputDecoration(
                              labelText: 'Google Calendar Link'
                          ),
                        ),
                        Padding(padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 0)),
                        TextField(
                          controller: zoomLinkController,
                          decoration: InputDecoration(
                              labelText: 'Zoom Link'
                          ),
                        ),
                        Padding(padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 0)),
                        TextField(
                          controller: zoomIDController,
                          decoration: InputDecoration(
                              labelText: 'Zoom ID'
                          ),
                        ),
                        Padding(padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 0)),
                        TextField(
                          controller: zoomPasswordController,
                          decoration: InputDecoration(
                              labelText: 'Zoom Password'
                          ),
                        ),
                        Padding(padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 0)),
                        TextField(
                          controller: durationController,
                          decoration: InputDecoration(
                              labelText: 'Duration'
                          ),
                        ),
                        Padding(padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 0)),
                        const SizedBox(height: 30),
                        RaisedButton(
                          onPressed: () {

                          },
                          textColor: Colors.white,
                          padding: const EdgeInsets.all(0.0),
                          child: Container(
                            decoration: const BoxDecoration(
                              gradient: LinearGradient(
                                colors: <Color>[
                                  Color(0xFF0D47A1),
                                  Color(0xFF1976D2),
                                  Color(0xFF42A5F5),
                                ],
                              ),
                            ),
                            padding: const EdgeInsets.all(10.0),
                            child:
                            const Text('Gradient Button', style: TextStyle(fontSize: 20)),
                          ),
                        ),
              ],
                    )
          )
      ),
      )
    );
  }
}

