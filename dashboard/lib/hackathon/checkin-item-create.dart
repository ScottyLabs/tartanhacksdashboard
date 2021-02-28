import 'package:flutter/material.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'json-classes.dart';


void main(){
  runApp(CIIPage());
}

class CIIPage extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    return MaterialApp(
        title: 'Checkin Items',
        theme: ThemeData(
          canvasColor: Colors.white,
          primaryColor: Color(0xFF2582F2),
          accentColor: Color(0xFF212A36),
          buttonColor: Color(0xFF212A36),
          fontFamily: 'Lato',
          textTheme: TextTheme(
              headline1: TextStyle(fontSize: 35, fontWeight: FontWeight.bold,
                  color: Colors.white),
              headline2: TextStyle(fontSize: 28, fontWeight: FontWeight.bold,
                  color: Colors.white),
              subtitle1: TextStyle(fontSize: 20, color: Colors.black,
                  fontWeight: FontWeight.normal),
              button: TextStyle(fontSize: 30, color: Colors.white)
          ),
          textButtonTheme: TextButtonThemeData(
            style: TextButton.styleFrom(
                primary: Color(0xFF2582F2),
                textStyle: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)
            ),
          ),
        ),
        home: SelectScreen()
    );
  }
}

class SelectScreen extends StatelessWidget{

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
        child:Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            RaisedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => NewCIIPage()),
                );
              },
              padding: const EdgeInsets.only(top:10, bottom:10,
                  left:30, right:30),
              child: Text('Create New Event',
                  style: Theme.of(context).textTheme.button)
            ),
            const SizedBox(height:20),
            RaisedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ViewCIIPage()),
                  );
                },
                padding: const EdgeInsets.only(top:10, bottom:10,
                    left:30, right:30),
                child: Text('Edit Events',
                    style: Theme.of(context).textTheme.button)
            ),
          ],
        )
      )
    );
  }
}

class AlwaysDisabledFocusNode extends FocusNode {
  @override
  bool get hasFocus => false;
}

class NewCIIPage extends StatefulWidget{
  final CheckinItem editing;

  NewCIIPage({this.editing});

  @override
  _NewCIIState createState() => _NewCIIState();
}

class _NewCIIState extends State<NewCIIPage>{

  Map input = {
    "name" : "",
    "desc" : "",
    "date" : DateTime.now().millisecondsSinceEpoch.toString(),
    "lat" : 0,
    "long": 0,
    "units" : 0,
    "checkin-limit" : 0,
    "access_code" : 0,
    "active_status" : 0,
    "self_checkin_enabled" : false,
    "points" : 0
  };

  TextEditingController controller1 = TextEditingController();
  TextEditingController controller2 = TextEditingController();
  TextEditingController controller3 = TextEditingController();
  TextEditingController controller4 = TextEditingController();
  TextEditingController controller5 = TextEditingController();
  TextEditingController controller6 = TextEditingController();
  TextEditingController controller7 = TextEditingController();

  DateTime pickedDate = DateTime.now();
  TimeOfDay pickedTime = TimeOfDay.now();

  String token = "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.IjYwMjgxMGJhODNmMDlmMDAxYmViMDlmMCI.HAjKGgH35L3MSpf2ONVpQR6BS-dFMa5dA0pSNo2ZX9c";

  Future errorDialog(title, text, context) async {
    return showDialog<void>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(title,
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                )
            ),
            content: Text(text),
            actions: <Widget>[
              TextButton(
                child: Text('Close'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        }
    );
  }

  Future createCII(context) async{
    var response = await http.post(
        Uri.encodeFull("https://thd-api.herokuapp.com/checkin/new"),
        headers: {
          "token": token,
          "Content-Type" : "application/json"},
        body: json.encode(input)
    );

    Map data = json.decode(response.body);
    if(response.statusCode != 200) {
      errorDialog("Error", data['message'], context);
    }else{
      errorDialog("Success", data["message"], context);
    }
  }

  Future editCII(context) async{
    print(json.encode(input));
    var response = await http.post(
        Uri.encodeFull("https://thd-api.herokuapp.com/checkin/edit"),
        headers: {
          "token": token,
          "Content-Type" : "application/json"},
        body: json.encode(input)
    );

    Map data = json.decode(response.body);
    if(response.statusCode != 200) {
      errorDialog("Error", data['message'], context);
    }else{
      errorDialog("Success", data["message"], context);
    }
  }

  void updateDate(){
    DateTime combined = new DateTime(pickedDate.year, pickedDate.month,
        pickedDate.day, pickedTime.hour, pickedTime.minute);
    setState(() {
      input["date"] = (combined.millisecondsSinceEpoch/1000).round().toString();
    });
  }

  bool dateInRange(DateTime d, DateTime start, DateTime end){
    return start.isBefore(d) && end.isAfter(d);
  }

  Future pickDate(BuildContext context) async {
    DateTime sDate = DateTime(DateTime.now().year-5);
    DateTime eDate = DateTime(DateTime.now().year+5);
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: dateInRange(pickedDate, sDate, eDate) ? pickedDate
            : DateTime.now(),
        firstDate: sDate,
        lastDate: eDate,
    );
    if (picked != null && picked != pickedDate)
      setState(() {
        pickedDate = picked;
        controller6.text = DateFormat.yMMMd().format(pickedDate);
        updateDate();
      });
  }

  Future pickTime(BuildContext context) async {
    final TimeOfDay picked = await showTimePicker(
      context: context,
      initialTime: pickedTime,
    );
    if (picked != null && picked != pickedTime)
      setState(() {
        pickedTime = picked;
        controller7.text = pickedTime.format(context);
        updateDate();
      });
  }

  @override
  void dispose(){
    controller1.dispose();
    controller2.dispose();
    controller3.dispose();
    controller4.dispose();
    controller5.dispose();
    controller6.dispose();
    controller7.dispose();
    super.dispose();
  }

  Future setUpEvent() async{
    input = widget.editing.toJson();
    controller1.text = input["name"];
    controller2.text = input["desc"];
    controller3.text = input["units"].toString();
    controller4.text = input["checkin_limit"].toString();
    controller5.text = input["points"].toString();

    DateTime temp = new DateTime.fromMillisecondsSinceEpoch(
      int.parse(input["date"])*1000,
    ).toLocal();
    pickedDate = new DateTime(temp.year, temp.month, temp.day);
    pickedTime = new TimeOfDay.fromDateTime(temp);
  }

  Future setUpWrapper() async{
    await setUpEvent();
  }

  @override
  void initState(){
    if(widget.editing != null){
      setUpWrapper();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    controller6.text = DateFormat.yMMMd().format(pickedDate);
    controller7.text = pickedTime.format(context);
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.editing == null ? 'New Checkin Item'
              : 'Editing Checkin Item',
              style: Theme.of(context).textTheme.headline2),
          backgroundColor: Theme.of(context).primaryColor,
          toolbarHeight: 50,
        ),
          body: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 32),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  TextField(
                    autofocus: false,
                    controller: controller1,
                    decoration: InputDecoration(
                        labelText: "Name",
                        border: OutlineInputBorder()
                    ),
                    onChanged: (String value) {
                      setState(() {
                        input["name"] = value;
                      });
                    },
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    autofocus: false,
                    controller: controller2,
                    decoration: InputDecoration(
                        labelText: "Description",
                        border: OutlineInputBorder()
                    ),
                    onChanged: (String value) {
                      setState(() {
                        input["desc"] = value;
                      });
                    },
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    autofocus: false,
                    focusNode: AlwaysDisabledFocusNode(),
                    controller: controller6,
                    decoration: InputDecoration(
                        labelText: "Date",
                        border: OutlineInputBorder()
                    ),
                    onTap: () {
                      pickDate(context);
                    },
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    autofocus: false,
                    focusNode: AlwaysDisabledFocusNode(),
                    controller: controller7,
                    decoration: InputDecoration(
                        labelText: "Time",
                        border: OutlineInputBorder()
                    ),
                    onTap: () {
                      pickTime(context);
                    },
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    autofocus: false,
                    controller: controller3,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                        labelText: "Units",
                        border: OutlineInputBorder()
                    ),
                    onChanged: (String value) {
                      setState(() {
                        input["units"] = int.parse(value);
                      });
                    },
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    autofocus: false,
                    controller: controller4,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                        labelText: "Checkin Limit",
                        border: OutlineInputBorder()
                    ),
                    onChanged: (String value) {
                      setState(() {
                        input["checkin_limit"] = int.parse(value);
                      });
                    },
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    autofocus: false,
                    controller: controller5,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                        labelText: "Points",
                        border: OutlineInputBorder()
                    ),
                    onChanged: (String value) {
                      setState(() {
                        input["points"] = int.parse(value);
                      });
                    },
                  ),
                  const SizedBox(height: 8),
                  Row(
                      children: [
                        Container(
                          child: Text("Access Level",
                              style: Theme.of(context).textTheme.subtitle1),
                          width: 150,
                        ),
                        const SizedBox(width: 30),
                        Expanded(
                            child: DropdownButton<int>(
                                isExpanded: true,
                                value: input["access_code"],
                                items:[
                                  DropdownMenuItem<int>(
                                      value: 0,
                                      child: Text("All users")),
                                  DropdownMenuItem<int>(
                                      value: 1,
                                      child: Text("Admins only")),
                                  DropdownMenuItem<int>(
                                      value: 2,
                                      child: Text("All participants")),
                                  DropdownMenuItem<int>(
                                      value: 3,
                                      child: Text("On campus participants")),
                                  DropdownMenuItem<int>(
                                      value: 4,
                                      child: Text("Off-campus participants"))
                                ],
                                underline: Container(
                                    height: 2
                                ),
                                onChanged: (int newValue) {
                                  setState(() {
                                    input["access_code"] = newValue;
                                  });
                                }
                            )
                        )
                      ]
                  ),
                  const SizedBox(height: 8),
                  Row(
                      children: [
                        Container(
                          child: Text("Active Status",
                              style: Theme.of(context).textTheme.subtitle1),
                          width: 150,
                        ),
                        const SizedBox(width: 30),
                        Expanded(
                            child: DropdownButton<int>(
                                isExpanded: true,
                                value: input["active_status"],
                                items:[
                                  DropdownMenuItem<int>(
                                      value: 0,
                                      child: Text("Deleted")),
                                  DropdownMenuItem<int>(
                                      value: 1,
                                      child: Text("Upcoming")),
                                  DropdownMenuItem<int>(
                                      value: 2,
                                      child: Text("Live")),
                                  DropdownMenuItem<int>(
                                      value: 3,
                                      child: Text("Complete"))
                                ],
                                underline: Container(
                                    height: 2
                                ),
                                onChanged: (int newValue) {
                                  setState(() {
                                    input["active_status"] = newValue;
                                  });
                                }
                            )
                        ),
                      ]
                  ),
                  const SizedBox(height: 8),
                  CheckboxListTile(
                      title: Text("Self-checkin enabled"),
                      value: input["self_checkin_enabled"],
                      onChanged: (bool newValue) {
                        setState(() {
                          input["self_checkin_enabled"] = newValue;
                        });
                      }
                  ),
                  const SizedBox(height: 8),
                  widget.editing != null ?
                    RaisedButton(
                        onPressed: () {
                          editCII(context);
                        },
                        padding: const EdgeInsets.only(top:10, bottom:10,
                            left:30, right:30),
                        child: Text('Save',
                            style: Theme.of(context).textTheme.button)
                    )
                    : RaisedButton(
                        onPressed: () {
                          createCII(context);
                        },
                        padding: const EdgeInsets.only(top:10, bottom:10,
                            left:30, right:30),
                        child: Text('Create',
                            style: Theme.of(context).textTheme.button)
                    ),
                ]
              )
            )
          )
    );
  }
}

class InfoTile extends StatelessWidget{
  final CheckinItem info;
  final Function refresh;

  InfoTile(this.info, this.refresh);

  @override
  Widget build(BuildContext context){
    return Card(
        margin: const EdgeInsets.all(12),
        child: InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) =>
                    NewCIIPage(editing:info)),
              ).then((val)=>refresh());
            },
            child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                        '${info.name}',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        )
                    ),
                    const SizedBox(height: 8),
                    Text(
                        info.desc,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[500],
                        )
                    ),
                  ]
                )
            )
        )
    );
  }
}

class ViewCIIPage extends StatefulWidget{
  @override
  _ViewCIIState createState() => _ViewCIIState();
}

class _ViewCIIState extends State<ViewCIIPage>{
  List checkinItems;
  String token = "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.IjYwMjgxMGJhODNmMDlmMDAxYmViMDlmMCI.HAjKGgH35L3MSpf2ONVpQR6BS-dFMa5dA0pSNo2ZX9c";
  bool loaded = false;

  Future getCheckinItems() async{
    var response = await http.post(
        Uri.encodeFull("https://thd-api.herokuapp.com/checkin/get"),
        headers:{"token": token}
    );
    List data = json.decode(response.body);
    data = data.map((element) =>
        CheckinItem.fromJson(element)).toList();
    
    if(this.mounted){
      setState(() {
        checkinItems = data;
        loaded = true;
      });
    }
  }

  @override
  void initState() {
    if(checkinItems != null){
      checkinItems = null;
    }
    getCheckinItems();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("All Checkin Events",
              style: Theme.of(context).textTheme.headline2),
          backgroundColor: Theme.of(context).primaryColor,
          toolbarHeight: 50,
        ),
        body: Column(
            children: <Widget>[
              (checkinItems != null) ?
              Expanded(
                child: ListView.builder(
                  itemCount: checkinItems.length,
                  itemBuilder: (BuildContext context, int index){
                    return InfoTile(checkinItems[index], getCheckinItems);
                  },
                ),
              )
                  : SizedBox(
                  height: 100,
                  child: Align(
                      alignment: Alignment.center,
                      child:
                      (loaded) ?
                      Text(
                          "No event data found.",
                          style: TextStyle(
                            fontSize: 30,
                          )
                      )
                          : Text(
                          "Loading...",
                          style: TextStyle(
                            fontSize: 35,
                            fontWeight: FontWeight.bold,
                          )
                      )
                  )
              )
            ]
        )
    );
  }
}