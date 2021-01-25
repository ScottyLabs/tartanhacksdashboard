import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:qrscan/qrscan.dart' as scanner;
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:json_annotation/json_annotation.dart';

part 'qrcode.g.dart';

void main() {
  runApp(QRHome());
}

class QRHome extends StatefulWidget{
  @override
  _QRHomeState createState() => _QRHomeState();
}

@JsonSerializable()
class CheckinItem{
  @JsonKey(name: '_id')
  String id;
  String name;
  String desc;
  String date;
  int lat;
  int long;
  int units;
  int checkin_limit; // ignore: non_constant_identifier_names
  int access_code; // ignore: non_constant_identifier_names
  int active_status; // ignore: non_constant_identifier_names

  CheckinItem(this.id, this.name, this.desc, this.date, this.lat, this.long,
      this.units, this.checkin_limit, this.access_code, this.active_status);


  factory CheckinItem.fromJson(Map<String, dynamic> json) =>
      _$CheckinItemFromJson(json);

  Map<String, dynamic> toJson() => _$CheckinItemToJson(this);
}

@JsonSerializable()
class CheckinEvent{
  @JsonKey(name: '_id')
  String id;
  String timestamp;
  CheckinItem checkin_item; // ignore: non_constant_identifier_names
  String user;

  CheckinEvent(this.id, this.timestamp, this.checkin_item, this.user);

  factory CheckinEvent.fromJson(Map<String, dynamic> json) =>
      _$CheckinEventFromJson(json);

  Map<String, dynamic> toJson() => _$CheckinEventToJson(this);

}


class _QRHomeState extends State<QRHome> {

  List history;
  List scanConfig = ["", "", false];
  String id;
  bool admin = false;
  String token;
  List checkinItems;

  void delHistory(hItem){
    setState(() {
      history.remove(hItem);
    });
  }

  void setConfig(value, index){
    setState(() {
      scanConfig[index] = value;
    });
  }

  Future getID(email, pass) async{
    id = null;
    admin = false;
    token = null;
    var response = await http.post(
        Uri.encodeFull("https://thd-api.herokuapp.com/auth/login"),
        body: {
          "email": email,
          "password": pass
        }
    );
    Map data = json.decode(response.body);
    setState(() {
      id = data["participant"]["_id"];
      admin = data["participant"]["is_admin"];
      token = data["access_token"];
    });
  }

  Future getCheckinItems() async{
    var response = await http.post(
        Uri.encodeFull("https://thd-api.herokuapp.com/checkin/get"),
        headers:{"token": token}
    );
    List data = json.decode(response.body);
    setState(() {
      checkinItems = data.map((element) =>
          CheckinItem.fromJson(element)).toList();
      scanConfig[0] = checkinItems[0].id;
    });
  }

  Future setup() async{
    await getID("joyceh@andrew.cmu.edu", "TartanHacksTest");
    await getCheckinItems();
  }

  @override
  void initState() {
    setup();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    return MaterialApp(
        title: 'QR Scanner',
        theme: ThemeData(
          canvasColor: Colors.white,
          primaryColor: Color(0xffcb1a1d),
          accentColor: Colors.black,
          buttonColor: Colors.black,
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
              primary: Color(0xffcb1a1d),
              textStyle: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)
            ),
          ),
      ),
        home: QRPage(history: history, delHistory: delHistory,
          scanConfig: scanConfig, setConfig: setConfig,
          getID: getID, id: id, admin: admin, token: token,
          checkinItems: checkinItems)
    );
  }
}


class QRPage extends StatelessWidget{

  final List history;
  final Function delHistory;
  final List scanConfig;
  final Function setConfig;
  final Function getID;
  final String id;
  final bool admin;
  final String token;
  final List checkinItems;

  QRPage({this.history, this.delHistory, this.scanConfig,
    this.setConfig, this.getID, this.id, this.admin, this.token,
    this.checkinItems});

  Future errorDialog(text, context) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Check in failed',
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

  Future checkinUser(user, context) async{
    var response = await http.post(
      Uri.encodeFull("https://thd-api.herokuapp.com/checkin/user"),
      headers:{"token": token},
      body:{
        "user_id": user,
        "checkin_item_id": scanConfig[0],
      }
    );
    if(response.statusCode != 200) {
      Map data = json.decode(response.body);
      errorDialog(data['message'], context);
    }
  }

  Future scan(BuildContext context) async {
    String scanRes = await scanner.scan();
    if(scanConfig[2] == true){
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) =>
            HistoryPage(id: scanRes, token: token,
                delHistory: delHistory, editing: true)),
      );
    }else {
      checkinUser(scanRes, context);
    }
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
        appBar: AppBar(
          title: Text('Your QR Code',
              style: Theme.of(context).textTheme.headline1),
          backgroundColor: Theme.of(context).primaryColor,
          actions: <Widget>[
            IconButton(
              icon: const Icon(Icons.admin_panel_settings, size: 30),
              onPressed: () {
                if(!admin){
                  getID("gdl2@andrew.cmu.edu", "8JK9NtPb&jdM!E3@");
                }else{
                  getID("joyceh@andrew.cmu.edu", "TartanHacksTest");
                }
              },
            )
          ],
          toolbarHeight: 70,
        ),
        body: Center(
            child: Column(
                children: <Widget>[
                  const SizedBox(height: 30),
                  SizedBox(
                    height: 300,
                    width: 300,
                    child: (id != null) ? QrImage(
                      data: "$id",
                      version: QrVersions.auto,
                      size: 300.0,
                      foregroundColor: Colors.black,
                    )
                    : Align(
                      alignment: Alignment.center,
                      child: Text(
                        "Loading...",
                        style: TextStyle(
                          fontSize: 35,
                          fontWeight: FontWeight.bold,
                        )
                      )
                    )
                  ),
                  const SizedBox(height: 20),
                  RaisedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) =>
                            HistoryPage(id: id, token: token,
                            delHistory: delHistory, editing: false)),
                      );
                    },
                    padding: const EdgeInsets.only(top:10, bottom:10,
                        left:30, right:30),
                    child: Text('View Recent Activity',
                        style: Theme.of(context).textTheme.button),
                  ),
                  if(admin)
                  ButtonBar(
                      alignment: MainAxisAlignment.spaceEvenly,
                      children:<Widget>[
                        RaisedButton(
                          onPressed: () {
                            scan(context);
                          },
                          padding: const EdgeInsets.only(top:10, bottom:10,
                              left:30, right:30),
                          child: Text('To Scanner',
                              style: Theme.of(context).textTheme.button),
                        ),
                        OutlineButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) =>
                                  ConfigPage(scanConfig: scanConfig,
                                      setConfig: setConfig,
                                      checkinItems: checkinItems)),
                            );
                          },
                          padding: const EdgeInsets.only(top:10, bottom:10,
                              left:30, right:30),
                          child: Icon(Icons.settings_outlined, size:30),
                        )
                      ]
                  )
                ]
            )
        )
    );
  }
}


class InfoTile extends StatelessWidget{
  final CheckinEvent info;
  final bool editing;
  final Function delHistory;

  InfoTile({this.info, this.editing, this.delHistory});

  @override
  Widget build(BuildContext context){
    return Card(
        margin: const EdgeInsets.all(12),
        child: InkWell(
          onTap: () async {
            return showDialog<void>(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text(
                      '${info.checkin_item.name}',
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      )
                  ),
                  content: SingleChildScrollView(
                    child: ListBody(
                      children: <Widget>[
                        Text(
                            '${DateFormat.jm().add_yMd().format(
                                new DateTime.fromMillisecondsSinceEpoch(
                                    int.parse(info.timestamp)*1000,
                                    ).toLocal()
                            )}',
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.grey[700],
                            )
                        ),
                        const SizedBox(height: 8),
                        Text(
                            'Checked in by: X',
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.grey[700],
                            )
                        ),
                        const SizedBox(height: 14),
                        Text(
                          '${info.checkin_item.desc}',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey[500],
                            )
                        )
                      ],
                    ),
                  ),
                  actions: <Widget>[
                    TextButton(
                      child: Text('Close'),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                );
              },
            );
          },
            child: Padding(
                padding: const EdgeInsets.all(24),
                child: Row(
                    children: [
                      if(editing)
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            IconButton(
                                icon: Icon(Icons.delete),
                                onPressed: () {
                                  delHistory(info);
                                }
                            )
                          ],
                        ),
                      const SizedBox(width: 20),
                      Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                                '${info.checkin_item.name}',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                )
                            ),
                            const SizedBox(height: 8),
                            Text(
                                '${DateFormat.jm().add_yMd().format(
                                    new DateTime.fromMillisecondsSinceEpoch(
                                      int.parse(info.timestamp)*1000,
                                    ).toLocal()
                                )}',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[500],
                                )
                            ),
                            const SizedBox(height: 8),
                            Text(
                                'Checked in by: X',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[500],
                                )
                            ),
                          ]
                      )
                    ]
                )
            )
        )
    );
  }
}

class HistoryPage extends StatefulWidget{
  final String id;
  final String token;
  final Function delHistory;
  final bool editing;

  HistoryPage({this.id, this.token, this.delHistory, this.editing});

  _HistoryPageState createState() => _HistoryPageState();

}

class _HistoryPageState extends State<HistoryPage>{

  String name;
  List history;
  bool loaded = false;

  Future getHistory() async{
    var queryParams = {
      "user_id": widget.id,
    };
    var response = await http.get(
        Uri.https("thd-api.herokuapp.com", "/checkin/history",
            queryParams),
        headers:{"token": widget.token}
    );

    Map data = json.decode(response.body);
    List raw = data["checkin_history"];
    raw = raw.map((element) =>
        CheckinEvent.fromJson(Map<String, dynamic>.from(element))).toList();
    if(this.mounted){
      setState(() {
        name = data["user"]["name"];
        history = raw.reversed.toList();
        loaded = true;
      });
    }
  }

  @override
  void initState() {
    if(history != null){
      history = null;
    }
    if(name != null){
      name = null;
    }
    getHistory();
    //print(history.runtimeType);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title:
          (name != null) ?
          Text("$name's History",
              style: Theme.of(context).textTheme.headline2)
          : null,
          backgroundColor: Theme.of(context).primaryColor,
          toolbarHeight: 70,
        ),
        body: Column(
            children: <Widget>[
              (history != null && history.length > 0) ?
                  Expanded(
                    child: ListView.builder(
                      itemCount: history.length,
                      itemBuilder: (BuildContext context, int index){
                        return InfoTile(info: history[index],
                          editing: widget.editing,
                          delHistory: widget.delHistory,);
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
                        "No checkin items found.",
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

class ConfigPage extends StatefulWidget{
  final List scanConfig;
  final Function setConfig;
  final List checkinItems;

  ConfigPage({this.scanConfig, this.setConfig, this.checkinItems});

  _ConfigPageState createState() => _ConfigPageState();
}


class _ConfigPageState extends State<ConfigPage> {

  final commentControl = TextEditingController();

  @override
  void dispose() {
    commentControl.dispose();
    super.dispose();
  }

  @override
  void initState() {
    commentControl.text = !widget.scanConfig[2] ? widget.scanConfig[1] : "";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Scan Config',
              style: Theme.of(context).textTheme.headline1),
          backgroundColor: Theme.of(context).primaryColor,
          toolbarHeight: 70,
        ),
        body:Padding(
            padding: const EdgeInsets.all(24),
            child: SingleChildScrollView(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                        children: [
                          Container(
                            child: Text("Check In Item",
                                style: Theme.of(context).textTheme.subtitle1),
                            width: 150,
                          ),
                          const SizedBox(width: 30),
                          Expanded(
                            child: DropdownButton<String>(
                                isExpanded: true,
                                value: widget.scanConfig[0],
                                items: widget.checkinItems
                                    .where((element) => 
                                      element.active_status == 2)
                                    .map<DropdownMenuItem<String>>((value) {
                                  return DropdownMenuItem<String>(
                                      value: value.id,
                                      child: Text(value.name)
                                  );
                                }).toList(),
                                disabledHint: Text("N/A"),
                                underline: Container(
                                    height: 2,
                                    color: (!widget.scanConfig[2]) ?
                                    Theme.of(context).primaryColor
                                        : Colors.grey[500]
                                ),
                                onChanged: (!widget.scanConfig[2]) ? (String newValue) {
                                  widget.setConfig(newValue, 0);
                                } : null
                            )
                          )
                        ]
                    ),
                    const SizedBox(height:20),
                    TextField(
                      autofocus: false,
                      enabled: !widget.scanConfig[2],
                      controller: commentControl,
                      maxLines: 5,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: !widget.scanConfig[2] ? "Additional comment"
                            : "No comments in viewing mode"
                      ),
                      onChanged: (String value) {
                        widget.setConfig(value, 3);
                      },
                    ),
                    const SizedBox(height:20),
                    CheckboxListTile(
                      title: Text("View History"),
                      value: widget.scanConfig[2],
                      onChanged: (bool newValue) {
                        if(newValue){
                          commentControl.clear();
                        }else{
                          commentControl.text = widget.scanConfig[1];
                        }
                        widget.setConfig(newValue, 2);
                      }
                    ),
                    const SizedBox(height:20),
                    RaisedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      padding: const EdgeInsets.only(top:10, bottom:10,
                          left:60, right:60),
                      child: Text('Confirm',
                          style: Theme.of(context).textTheme.button),
                    )
                  ]
              )
            )
        )
    );
  }
}

