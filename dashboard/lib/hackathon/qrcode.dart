import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:qrscan/qrscan.dart' as scanner;
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';


void main() {
  // debugPaintSizeEnabled = true;
  runApp(QRHome());
}

class QRHome extends StatefulWidget{
  @override
  _QRHomeState createState() => _QRHomeState();
}


class HistoryItem{
  String text1;
  String text2;
  String text3;
  String comment;
  
  HistoryItem(this.text1, this.text2, this.text3, this.comment);
}


class _QRHomeState extends State<QRHome> {

  List history = new List();
  List scanConfig = ["One", "One", false, ""];
  String id;
  bool admin = false;

  void addHistory(text1, text2, text3, comment){
    setState(() {
      history.insert(0, new HistoryItem(text1, text2, text3, comment));
    });
  }

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

  void setID(thisID, thisAdmin){
    setState(() {
      id = thisID;
      admin = thisAdmin;
    });
  }

  Future getID() async{
    var response = await http.post(
        Uri.encodeFull("https://tartanhacks-testing.herokuapp.com/auth/login"),
        body: {
          "email": "joyceh@andrew.cmu.edu",
          "password": "TartanHacksTest"
        }
    );
    Map data = json.decode(response.body);
    setID(data["user"]["id"], data["user"]["admin"]);
  }

  @override
  void initState() {
    getID();
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
          accentColor: Colors.blue,
          buttonColor: Colors.black,
          fontFamily: 'Lato',
          textTheme: TextTheme(
            headline1: TextStyle(fontSize: 35, fontWeight: FontWeight.bold,
                color: Colors.white),
            subtitle1: TextStyle(fontSize: 20, color: Colors.black,
                fontWeight: FontWeight.normal),
            button: TextStyle(fontSize: 30, color: Colors.white)
          )
      ),
        home: QRPage(history: history, addHistory: addHistory,
          delHistory: delHistory, scanConfig: scanConfig, setConfig: setConfig,
          setID: setID, id: id, admin: admin)
    );
  }
}


class QRPage extends StatelessWidget{

  final List history;
  final Function addHistory;
  final Function delHistory;
  final List scanConfig;
  final Function setConfig;
  final Function setID;
  final String id;
  final bool admin;

  QRPage({this.history, this.addHistory, this.delHistory, this.scanConfig,
    this.setConfig, this.setID, this.id, this.admin});

  Future scan(BuildContext context) async {
    String scanRes = await scanner.scan();
    if(scanConfig[2] == true){
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) =>
            HistoryPage(history:history, addHistory:addHistory,
                delHistory: delHistory, editing: true)),
      );
    }else {
      addHistory(scanConfig[0], DateFormat.jm().add_yMd() .format(DateTime.now()),
          scanRes, scanConfig[3]);
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
                setID(id, !admin);
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
                            HistoryPage(history:history, addHistory:addHistory,
                                editing:false)),
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
                                      setConfig: setConfig)),
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
  final HistoryItem info;
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
                      '${info.text1}',
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      )
                  ),
                  content: SingleChildScrollView(
                    child: ListBody(
                      children: <Widget>[
                        Text(
                            '${info.text2}',
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.grey[700],
                            )
                        ),
                        const SizedBox(height: 8),
                        Text(
                            '${info.text3}',
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.grey[700],
                            )
                        ),
                        const SizedBox(height: 14),
                        Text(
                          '${info.comment}',
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
                                '${info.text1}',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                )
                            ),
                            const SizedBox(height: 8),
                            Text(
                                '${info.text2}',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[500],
                                )
                            ),
                            const SizedBox(height: 8),
                            Text(
                                '${info.text3}',
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


class HistoryPage extends StatelessWidget{

  final List history;
  final Function addHistory;
  final Function delHistory;
  final bool editing;

  HistoryPage({this.history, this.addHistory, this.delHistory, this.editing});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Scan History',
              style: Theme.of(context).textTheme.headline1),
          backgroundColor: Theme.of(context).primaryColor,
          toolbarHeight: 70,
        ),
        body: Column(
            children: <Widget>[
              Expanded(
                child:  ListView.builder(
                  itemCount: history.length,
                  itemBuilder: (BuildContext context, int index){
                    return InfoTile(info: history[index],
                        editing: editing, delHistory: delHistory,);
                  },
                ),
              ),
            ]
        )
    );
  }
}

class ConfigPage extends StatefulWidget{
  final List scanConfig;
  final Function setConfig;

  ConfigPage({this.scanConfig, this.setConfig});

  _ConfigPageState createState() => _ConfigPageState();
}


class _ConfigPageState extends State<ConfigPage> {

  final commentControl = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    commentControl.dispose();
    super.dispose();
  }

  @override
  void initState() {
    commentControl.text = !widget.scanConfig[2] ? widget.scanConfig[3] : "";
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
                            child: Text("Option A",
                                style: Theme.of(context).textTheme.subtitle1),
                            width: 120,
                          ),
                          const SizedBox(width: 50),
                          Expanded(
                            child: DropdownButton<String>(
                                isExpanded: true,
                                value: widget.scanConfig[0],
                                items: <String>['One', 'Two', 'Three', 'Four']
                                    .map<DropdownMenuItem<String>>((String value) {
                                  return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(value)
                                  );
                                }).toList(),
                                disabledHint: Text(widget.scanConfig[0]),
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
                    Row(
                        children:[
                          Container(
                            child: Text("Option B",
                                style: Theme.of(context).textTheme.subtitle1),
                            width: 120,
                          ),
                          const SizedBox(width: 50),
                          Expanded(
                              child: DropdownButton<String>(
                                  isExpanded: true,
                                  value: widget.scanConfig[1],
                                  items: <String>['One', 'Two', 'Three', 'Four']
                                      .map<DropdownMenuItem<String>>((String value) {
                                    return DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(value),
                                    );
                                  }).toList(),
                                  disabledHint: Text(widget.scanConfig[1]),
                                  underline: Container(
                                      height: 2,
                                      color: (!widget.scanConfig[2]) ?
                                      Theme.of(context).primaryColor
                                          : Colors.grey[500]
                                  ),
                                  onChanged: (!widget.scanConfig[2]) ? (String newValue) {
                                    widget.setConfig(newValue, 1);
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
                            : "No comments in delete mode"
                      ),
                      onChanged: (String value) {
                        widget.setConfig(value, 3);
                      },
                    ),
                    const SizedBox(height:20),
                    CheckboxListTile(
                      title: Text("Delete Mode"),
                      value: widget.scanConfig[2],
                      onChanged: (bool newValue) {
                        if(newValue){
                          commentControl.clear();
                        }else{
                          commentControl.text = widget.scanConfig[3];
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

