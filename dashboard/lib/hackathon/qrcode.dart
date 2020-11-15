import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'dart:math';
import 'package:qrscan/qrscan.dart' as scanner;
import 'dart:async';


void main() {
  // debugPaintSizeEnabled = true;
  runApp(QRHome());
}

class QRHome extends StatefulWidget{
  @override
  _QRHomeState createState() => _QRHomeState();
}


class _QRHomeState extends State<QRHome> {

  List<Widget> tiles = new List<Widget>();
  List<String> scanConfig = ["One", "One"];

  void addTile(text1, text2, text3){
    setState(() {
      tiles.add(new InfoTile(text1: text1, text2: text2, text3: text3));
    });
  }

  void setConfig(value, index){
    setState(() {
      scanConfig[index] = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'QR Page',
        theme: ThemeData(
          canvasColor: Colors.white,
          buttonColor: Colors.blue,
          textTheme: TextTheme(
            subtitle1: TextStyle(fontSize: 20),
            button: TextStyle(fontSize: 30, color: Colors.white)
          )
      ),
        home: QRPage(tiles: tiles, addTile: addTile, scanConfig: scanConfig,
            setConfig: setConfig)
    );
  }
}


class QRPage extends StatelessWidget{

  final List<Widget> tiles;
  final Function addTile;
  final List<String> scanConfig;
  final Function setConfig;

  QRPage({this.tiles, this.addTile, this.scanConfig, this.setConfig});

  Future scan() async {
    String scanRes = await scanner.scan();
    addTile(scanRes, scanConfig[0], scanConfig[1]);
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
        appBar: AppBar(
          title: Text('QR Page', style: TextStyle(fontSize: 30)),
          toolbarHeight: 70,
        ),
        body: Center(
            child: Column(
                children: <Widget>[
                  const SizedBox(height: 30),
                  QrImage(
                    data: "1234567890987654321",
                    version: QrVersions.auto,
                    size: 300.0,
                  ),
                  const SizedBox(height: 20),
                  RaisedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) =>
                            HistoryPage(tiles:tiles, addTile:addTile)),
                      );
                    },
                    padding: const EdgeInsets.only(top:10, bottom:10,
                        left:30, right:30),
                    child: Text('View Recent Activity',
                        style:TextStyle(fontSize:30, color:Colors.white)),
                  ),
                  ButtonBar(
                      alignment: MainAxisAlignment.spaceEvenly,
                      children:<Widget>[
                        RaisedButton(
                          onPressed: () {
                            scan();
                          },
                          padding: const EdgeInsets.only(top:10, bottom:10,
                              left:30, right:30),
                          child: Text('To Scanner',
                              style:TextStyle(fontSize:30, color:Colors.white)),
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
  final String text1;
  final String text2;
  final String text3;

  InfoTile({this.text1, this.text2, this.text3});

  @override
  Widget build(BuildContext context){
    return Card(
        margin: const EdgeInsets.all(12),
        child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                      '$text1',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      )
                  ),
                  const SizedBox(height: 8),
                  Text(
                      '$text2',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[500],
                      )
                  ),
                  const SizedBox(height: 8),
                  Text(
                      '$text3',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[500],
                      )
                  ),
                ]
            )
        )
    );
  }
}


class HistoryPage extends StatelessWidget{

  final List<Widget> tiles;
  final Function addTile;
  final rng = new Random();

  HistoryPage({this.tiles, this.addTile});

  void handleChange(){
    addTile(rng.nextInt(1000000000).toString(),
        rng.nextInt(1000000000).toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('History Page', style: TextStyle(fontSize: 30)),
          toolbarHeight: 70,
        ),
        body: Column(
            children: <Widget>[
              Expanded(
                child:  ListView.builder(
                  itemCount: tiles.length,
                  itemBuilder: (BuildContext context, int index){
                    return tiles[index];
                  },
                ),
              ),
            ]
        )
    );
  }
}


class ConfigPage extends StatelessWidget {

  final List<String> scanConfig;
  final Function setConfig;

  ConfigPage({this.scanConfig, this.setConfig});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Scan Config', style: TextStyle(fontSize: 30)),
          toolbarHeight: 70,
        ),
        body:Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                      children: [
                        Text("Option A",
                            style: Theme.of(context).textTheme.subtitle1),
                        const SizedBox(width: 50),
                        DropdownButton<String>(
                            value: scanConfig[0],
                            items: <String>['One', 'Two', 'Three', 'Four']
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                            onChanged: (String newValue) {
                              setConfig(newValue, 0);
                            }
                        ),
                      ]
                  ),
                  Row(
                      children:[
                        Text("Option B",
                            style: Theme.of(context).textTheme.subtitle1),
                        const SizedBox(width: 50),
                        DropdownButton<String>(
                            value: scanConfig[1],
                            items: <String>['One', 'Two', 'Three', 'Four']
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                            onChanged: (String newValue) {
                              setConfig(newValue, 1);
                            }
                        )
                      ]
                  )
                ]
            )
        )
    );
  }
}

