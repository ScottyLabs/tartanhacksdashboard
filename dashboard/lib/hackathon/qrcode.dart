import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:qrscan/qrscan.dart' as scanner;
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';


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
  
  HistoryItem(this.text1, this.text2, this.text3);
}


class _QRHomeState extends State<QRHome> {

  List history = new List();
  List scanConfig = ["One", "One", false];
  String id;
  bool admin = false;

  void addHistory(text1, text2, text3){
    setState(() {
      history.add(new HistoryItem(text1, text2, text3));
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
    return MaterialApp(
        title: 'QR Scanner',
        theme: ThemeData(
          canvasColor: Colors.white,
          accentColor: Color(0xffcb1a1d),
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
          setID: setID, id: id, admin: admin,)
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
      addHistory(scanRes, scanConfig[0], scanConfig[1]);
    }
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
        appBar: AppBar(
          title: Text('Your QR Code',
              style: Theme.of(context).textTheme.headline1),
          backgroundColor: Theme.of(context).accentColor,
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
                  QrImage(
                    data: "$id",
                    version: QrVersions.auto,
                    size: 300.0,
                    foregroundColor: (id == null) ? Colors.white : Colors.black,
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
          backgroundColor: Theme.of(context).accentColor,
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


class ConfigPage extends StatelessWidget {

  final List scanConfig;
  final Function setConfig;

  ConfigPage({this.scanConfig, this.setConfig});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Scan Config',
              style: Theme.of(context).textTheme.headline1),
          backgroundColor: Theme.of(context).accentColor,
          toolbarHeight: 70,
        ),
        body:Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                      children: [
                        Container(
                          child: Text("Option A",
                              style: Theme.of(context).textTheme.subtitle1),
                          width: 100,
                        ),
                        const SizedBox(width: 50),
                        DropdownButton<String>(
                            value: scanConfig[0],
                            items: <String>['One', 'Two', 'Three', 'Four']
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Container(
                                    child: Text(value),
                                    width: 100
                                )
                              );
                            }).toList(),
                            disabledHint: Text(scanConfig[0]),
                            underline: Container(
                                height: 2,
                                color: Theme.of(context).accentColor
                            ),
                            onChanged: (!scanConfig[2]) ? (String newValue) {
                              setConfig(newValue, 0);
                            } : null
                        ),
                      ]
                  ),
                  Row(
                      children:[
                        Container(
                          child: Text("Option A",
                              style: Theme.of(context).textTheme.subtitle1),
                          width: 100,
                        ),
                        const SizedBox(width: 50),
                        DropdownButton<String>(
                            value: scanConfig[1],
                            items: <String>['One', 'Two', 'Three', 'Four']
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Container(
                                  child: Text(value),
                                  width: 100
                                )
                              );
                            }).toList(),
                            disabledHint: Text(scanConfig[1]),
                            underline: Container(
                              height: 2,
                              color: Theme.of(context).accentColor
                            ),
                            onChanged: (!scanConfig[2]) ? (String newValue) {
                              setConfig(newValue, 1);
                            } : null
                        )
                      ]
                  ),
                  const SizedBox(height:20),
                  CheckboxListTile(
                    title: Text("Edit Mode"),
                    value: scanConfig[2],
                    onChanged: (bool newValue) {
                      setConfig(newValue, 2);
                    }
                  )
                ]
            )
        )
    );
  }
}

