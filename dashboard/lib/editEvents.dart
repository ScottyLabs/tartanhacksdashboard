import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'anuda.dart';

void main() => runApp(editEventApp());

class editEventApp extends StatelessWidget {
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
  var dropdownValue = 'Zoom';
  final idController = new TextEditingController();
  final eventNameController = new TextEditingController();
  final eventDescController = new TextEditingController();
  final gcalLinkController = new TextEditingController();
  final zoomLinkController = new TextEditingController();
  final zoomIDController = new TextEditingController();
  final zoomPasswordController = new TextEditingController();
  final durationController = new TextEditingController();
  double _height;
  double _width;

  String _setTime, _setDate;

  String _hour, _minute, _time;

  String dateTime;

  DateTime selectedDate = DateTime.now();

  TimeOfDay selectedTime = TimeOfDay(hour: 00, minute: 00);

  TextEditingController _dateController = TextEditingController();
  TextEditingController _timeController = TextEditingController();
  String unixTime = '';
  int accessCode = 0;
  final baseUrl = 'https://thd-api.herokuapp.com/';


  Future<bool> addEventAsync() async {

    String url = baseUrl + "events/new";
    Map<String, String> headers = {"Content-type": "application/json", "Token": "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.IjYwMjgxMGJhODNmMDlmMDAxYmViMDlmMCI.HAjKGgH35L3MSpf2ONVpQR6BS-dFMa5dA0pSNo2ZX9c"};
    String json1 = '{"name":"' + eventNameController.text + '","timestamp":"' + unixTime + '","description":"' + eventDescController.text + '","zoom_access_enabled":true,"gcal_event_url":"' + gcalLinkController.text + '","zoom_link":"' + zoomLinkController.text + '","is_in_person":false,"access_code":' + accessCode.toString() + ',"zoom_id":"' + zoomIDController.text + '","zoom_password":"' + zoomPasswordController.text + '","duration":' + durationController.text + '}';
    print(json1);
    final response = await http.post(url, headers: headers, body: json1);
    if (response.statusCode == 200) {
      return true;
    }
    else{
      print(response.statusCode);
      return false;
    }
    // if (response.statusCode == 200) {
    //   Login loginData;
    //   var data = json.decode(response.body);
    //   loginData = new Login.fromJson(data);
    //   return loginData;
    // } else if (response.statusCode == 401) {
    //   print(response.statusCode);
    //   return null;
    // } else {
    //   print(json1);
    //   return null;
    // }
  }
  void saveData() async {
    bool result = await addEventAsync();
    if (result == true) {
      print(true);
    }
  }
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
  void getDate (DateTime input){
    unixTime = (input.toUtc().millisecondsSinceEpoch/1000).toInt().toString();
  }

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
              child: SingleChildScrollView(
                  child: Column(
                children: [
                  TextField(
                    controller: idController,
                    decoration: InputDecoration(
                        labelText: 'Event ID (0 for new events)'),
                  ),
                  Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: 10.0, horizontal: 0)),
                  TextField(
                    controller: eventNameController,
                    decoration: InputDecoration(labelText: 'Event Name'),
                  ),
                  Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: 10.0, horizontal: 0)),
                  TextField(
                    controller: eventDescController,
                    decoration: InputDecoration(labelText: 'Event Description'),
                  ),
                  Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: 10.0, horizontal: 0)),
                  TextField(
                    controller: gcalLinkController,
                    decoration:
                        InputDecoration(labelText: 'Google Calendar Link'),
                  ),
                  Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: 10.0, horizontal: 0)),
                  TextField(
                    controller: zoomLinkController,
                    decoration: InputDecoration(
                        labelText: 'Event Link (Zoom/Discord/Hopin etc)'),
                  ),
                  Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: 10.0, horizontal: 0)),
                  Text('Meeting Platform',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 30)),
                  Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: 10.0, horizontal: 0)),
                  DropdownButton<String>(
                    value: dropdownValue,
                    icon: Icon(Icons.arrow_downward),
                    iconSize: 24,
                    elevation: 16,
                    style: TextStyle(color: Color.fromARGB(255, 37, 130, 242)),
                    underline: Container(
                      height: 2,
                      color: Color.fromARGB(255, 37, 130, 242),
                    ),
                    onChanged: (String newValue) {
                      setState(() {
                        dropdownValue = newValue;
                        if (newValue == 'Zoom'){
                        accessCode = 1;
                        }
                        else if (newValue == 'Hopin'){
                        accessCode = 2;
                        }
                        else if (newValue == 'Discord'){
                          accessCode = 3;
                        }
                        else {
                          accessCode = 0;
                        }
                      });
                    },
                    items: <String>['Zoom', 'Discord', 'Hopin', 'Other']
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                  Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: 10.0, horizontal: 0)),
                  TextField(
                    controller: zoomIDController,
                    decoration: InputDecoration(labelText: 'Zoom ID'),
                  ),
                  Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: 10.0, horizontal: 0)),
                  TextField(
                    controller: zoomPasswordController,
                    decoration: InputDecoration(labelText: 'Zoom Password'),
                  ),
                  Padding(
                      padding:
                      EdgeInsets.symmetric(vertical: 10.0, horizontal: 0)),
                  TextField(
                    controller: durationController,
                    decoration: InputDecoration(labelText: 'Duration'),
                  ),
                  Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: 10.0, horizontal: 0)),
                  DateTimePicker(
                    type: DateTimePickerType.dateTime,
                    dateMask: 'd MMM, yyyy',
                    initialValue: DateTime.now().toString(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                    icon: Icon(Icons.event),
                    dateLabelText: 'Date',
                    timeLabelText: "Hour",
                    onChanged: (val) => getDate(DateTime.parse(val)),
                    validator: (val) {
                      print(val);
                      return null;
                    },
                    onSaved: (val) => getDate(DateTime.parse(val)),
                  ),
                  const SizedBox(height: 30),
                  RaisedButton(
                    onPressed: () {
                      saveData();// API Call stuff here
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
                      child: const Text('Submit Information',
                          style: TextStyle(fontSize: 20)),
                    ),
                  ),
                ],
              ))),
        ));
  }
}
