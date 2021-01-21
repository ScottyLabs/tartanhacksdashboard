import 'package:flutter/material.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:url_launcher/url_launcher.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Flutter Demo',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: new MyHomePage(title: 'Users'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool _isFavorited = true;
  void _toggleFavorite() {
    setState(() {
      if (_isFavorited) {
        _isFavorited = false;
      } else {
        _isFavorited = true;
      }
    });
  }

  Future<List<User>> _getUsers() async {
    var data = await http.get("https://thd-api.herokuapp.com/events/get");
    var jsonData = json.decode(data.body);
    List<User> users = [];
    for(var u in jsonData){
      User user = User(u["index"], u["name"], u["description"], u["timestamp"], u["zoom_link"]);
      users.add(user);
    }
    print(users.length);
    return users;
  }

  Widget eventIcon(data) {
    return Padding(
        padding: const EdgeInsets.only(left: 1.0),
        child: Align(
            alignment: Alignment.centerLeft,
            child: Column(
              children: <Widget> [
                IconButton(
                    icon: Icon(
                      Icons.star_border,
                      color: Colors.white,
                      size: 35,
                    ),
                    tooltip: 'Tap to favorite this event!',
                    onPressed: () {
                      setState(() {
                        _toggleFavorite();
                      });
                    }
                )
              ],
            )
        )
    );
  }

  Widget eventName(data) {
    return Align(
        alignment: Alignment.centerLeft,
        child: RichText(
            text: TextSpan(
              text: '${data['name']}',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black,
                fontSize: 20,
              ),
            )
        )
    );
  }

  Widget eventDescription(data) {
    return Align(
        alignment: Alignment.centerLeft,
        child: Container(
            width: MediaQuery.of(context).size.width*0.60,
            child: RichText(
                text: TextSpan(
                  text: '\n${data['description']}',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 15,
                  ),
                )
            )
        )
    );
  }

  Widget eventTime(data) {
    return Align(
        alignment: Alignment.center,
        child: RichText(
            text: TextSpan(
                text: '${data['time']}',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontSize: 20,
                ),
                children: <TextSpan> [
                  TextSpan(
                      text: '\n${data['day']}',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      )
                  )
                ]
            )
        )
    );
  }

  Widget eventLink(data) {
    return InkWell(
        child: new RichText(
            text: TextSpan(
              text: 'Link to Event',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontSize: 20,
              ),
            )
        ),
        onTap: () => launch('${data['zoom_link']}')
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(widget.title),
      ),
      body: Container(
        child: FutureBuilder(
          future: _getUsers(),
          builder: (BuildContext context, AsyncSnapshot snapshot){
            print(snapshot.data);
            if(snapshot.data == null){
              return Center(
                child: CircularProgressIndicator()
              );
            } else {
              return ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                    leading: IconButton(
                          icon: Icon(
                          Icons.star_border,
                          color: Colors.white,
                          size: 35,
                      ),
                    ),
                    title: Text(snapshot.data[index].name),
                    subtitle: Text(snapshot.data[index].description),
                    onTap: (){
                      Navigator.push(context,
                          new MaterialPageRoute(builder: (context) => DetailPage(snapshot.data[index]))
                      );
                    },
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }
}

class DetailPage extends StatelessWidget {

  final User user;
  DetailPage(this.user);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(user.name),
        )
    );
  }
}

class User {
  final int index;
  final String name;
  final String description;
  final String timestamp;
  final String zoom_link;

  User(this.index, this.name, this.description, this.timestamp, this.zoom_link);
}