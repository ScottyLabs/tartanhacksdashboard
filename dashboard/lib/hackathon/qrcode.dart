import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:qrscan/qrscan.dart' as scanner;
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'json-classes.dart';


void main() {
  runApp(QRHome());
}

class QRHome extends StatefulWidget{
  @override
  _QRHomeState createState() => _QRHomeState();
}

class _QRHomeState extends State<QRHome> {

  List history;
  List scanConfig = ["", "", false, false];
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
    if(response.statusCode == 200) {
      Map data = json.decode(response.body);
      setState(() {
        id = data["participant"]["_id"];
        admin = data["participant"]["is_admin"];
        token = data["access_token"];
      });
    }
  }

  Future getCheckinItems() async{
    var response = await http.post(
        Uri.encodeFull("https://thd-api.herokuapp.com/checkin/get"),
        headers:{"token": token}
    );
    List data = json.decode(response.body);
    setState(() {
      checkinItems = data.map((element) =>
          CheckinItem.fromJson(element))
          .where((element) => element.self_checkin_enabled == false).toList();
      scanConfig[0] = checkinItems[0].id;
    });
  }

  Future setup() async{
    await getID("gdl2@andrew.cmu.edu", "PerXBo@wgifCUYSk4bX3");
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

  Future checkinUser(user, item, context) async{
    var response = await http.post(
      Uri.encodeFull("https://thd-api.herokuapp.com/checkin/user"),
      headers:{"token": token},
      body:{
        "user_id": user,
        "checkin_item_id": item,
      }
    );
    if(response.statusCode != 200) {
      Map data = json.decode(response.body);
      errorDialog(data['message'], context);
    }
  }

  Future scan(BuildContext context) async {
    String scanRes = await scanner.scan();
    if(scanConfig[2] == true) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) =>
            HistoryPage(id: scanRes, token: token,
                delHistory: delHistory, editing: true)),
      );
    }else if(!admin || scanConfig[3]){
      checkinUser(id, scanRes, context);
    }else{
      checkinUser(scanRes, scanConfig[0], context);
    }
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
        appBar: AppBar(
          title: Text('Your QR Code',
              style: Theme.of(context).textTheme.headline1),
          backgroundColor: Theme.of(context).primaryColor,
          /*
          actions: <Widget>[
            IconButton(
              icon: const Icon(Icons.admin_panel_settings, size: 30),
              onPressed: () {
                if(!admin){
                  getID("gdl2@andrew.cmu.edu", "PerXBo@wgifCUYSk4bX3");
                }else{
                  getID("wweerasi@andrew.cmu.edu", "Anuda123");
                }
              },
            )
          ],
          */
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
                        if(admin)
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
  final CheckinItem info;
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
                      '${info.name}',
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      )
                  ),
                  content: SingleChildScrollView(
                    child: ListBody(
                      children: <Widget>[
                        Text(
                          info.has_checked_in ?
                            'Checked in ${DateFormat.jm().add_yMd().format(
                                new DateTime.fromMillisecondsSinceEpoch(
                                    int.parse(info.check_in_timestamp)*1000,
                                    ).toLocal()
                            )}.'
                            : 'Not checked in.',
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.grey[700],
                            )
                        ),
                        const SizedBox(height: 14),
                        Text(
                          '${info.desc}',
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
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            if(editing)
                              IconButton(
                                  icon: Icon(Icons.delete),
                                  onPressed: () {
                                    delHistory(info);
                                  }
                              )
                            else
                              info.has_checked_in ?
                                  Icon(Icons.check_box)
                                : Icon(Icons.check_box_outline_blank)
                          ],
                        ),
                      const SizedBox(width: 20),
                      Column(
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
                              info.has_checked_in ?
                                'Checked in ${DateFormat.jm().add_yMd().format(
                                    new DateTime.fromMillisecondsSinceEpoch(
                                      int.parse(info.check_in_timestamp)*1000,
                                    ).toLocal()
                                )}.'
                                : "Not checked in.",
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
        CheckinItem.fromJson(Map<String, dynamic>.from(element))).toList();
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
                          const SizedBox(width: 15),
                          Expanded(
                            child: DropdownButton<String>(
                                isExpanded: true,
                                value: widget.scanConfig[0],
                                items: widget.checkinItems
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
                    /*
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
                    */
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
                    const SizedBox(height:15),
                    CheckboxListTile(
                        title: Text("Self-checkin"),
                        value: widget.scanConfig[3],
                        onChanged: (bool newValue) {
                          if(newValue){
                            commentControl.clear();
                          }else{
                            commentControl.text = widget.scanConfig[1];
                          }
                          widget.setConfig(newValue, 3);
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

