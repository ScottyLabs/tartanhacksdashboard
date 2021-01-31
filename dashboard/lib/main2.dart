import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'eventinfo.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: MyHomePage(title: 'Events and Scheduling'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool _isFavorited = true;
  var eventData = EventInfo.getData;

  Future<Map<String, dynamic>> getEventDetails() async {
    var url = 'https://thd-api.herokuapp.com/events/get';
    var body = json.encode({});

    print('Request Body: $body');

    var response = await http.post(
      url,
      headers: {
        'accept': 'application/json',
        'Content-Type': 'application/json-patch+json',
      },
      body: body,
    );

    if (response.statusCode == 200) {
      print(json.decode(response.body));
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load events.');
    }
  }

  Future<Map<String, dynamic>> eventResponse;

  @override
  void initState() {
    super.initState();
    eventResponse = getEventDetails();
    print('event response: ${eventResponse}');
  }

  // create a favorites system for the user to add an event to a favorites
  // list so they can refer back to it or receive notifications for the event
  void _toggleFavorite() {
    setState(() {
      if (_isFavorited) {
        _isFavorited = false;
      } else {
        _isFavorited = true;
      }
    });
  }

  // switch case for the filtration for categories
  void handleClick(String value) {
    switch (value) {
      case 'Hacker':
        break;
      case 'Sponsor':
        break;
      case 'Mentor':
        break;
      case 'General':
        break;
    }
  }

  // assigns colors for the categories for filtration of events
  Color getColor(categoryNum){
    List<Color> colorsList = [Colors.redAccent[100], Colors.redAccent, Colors.redAccent[400], Colors.redAccent[700]];
    final colorsMap = colorsList.asMap();
    return colorsMap[categoryNum - 1];
  }

  // symbol and color for each event based on category
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

  // name of the event
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

  // description for the event
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

  // date and time of the event
  Widget eventTime(data) {
    return Align(
        alignment: Alignment.center,
        child: RichText(
            text: TextSpan(
                text: '${data['timestamp']}',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontSize: 20,
                ),
                children: <TextSpan> [
                  TextSpan(
                      text: '\n${data['timestamp']}',
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

  // hyperlinked button for the event
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

  Widget projectWidget() {
    return FutureBuilder(
      future: eventResponse,
      builder: (BuildContext context, AsyncSnapshot<Map<String, dynamic>> snapshot) {
        if (snapshot.hasData) {
          return Container(
              child: ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (BuildContext context,  index) {
                  Event event = snapshot.data[index];
                  return Column(
                    children: <Widget>[
                      // Widget to display the list of project
                      Card(
                          elevation: 5,
                          child: Padding(
                              padding: EdgeInsets.all(7),
                              child: Stack(
                                  children: <Widget> [
                                    Align(
                                        alignment: Alignment.center,
                                        child: Stack(
                                            children: <Widget> [
                                              Align(
                                                alignment: Alignment.centerRight,
                                                child:
                                                Container(
                                                  width: 100,
                                                  height: 220,
                                                  color: Color.fromRGBO(0, 0, 0, 0.5),
                                                  child: eventTime(event),
                                                ),
                                              ),
                                              Padding(
                                                  padding: const EdgeInsets.only(left:10, top: 5),
                                                  child: Column(
                                                      children: <Widget> [
                                                        Row(
                                                            children: <Widget> [
                                                              eventIcon(event),
                                                              SizedBox(
                                                                width: 10,
                                                              ),
                                                              eventName(event),
                                                            ]
                                                        ),
                                                        Row(
                                                            children: <Widget> [
                                                              eventDescription(event),
                                                            ]
                                                        ),
                                                        SizedBox(
                                                          height: 10,
                                                        ),
                                                        Align(
                                                            alignment: Alignment.centerLeft,
                                                            child: Container(
                                                              child: RaisedButton(
                                                                child: eventLink(event),
                                                              ),
                                                            )
                                                        )
                                                      ]
                                                  )
                                              ),
                                            ]
                                        )
                                    )
                                  ]
                              )
                          )
                      )
                    ],
                  );
                },
              )
          );
        } else
          print('project snapshot data is: ${snapshot.data}');
          return Center(
            child: CircularProgressIndicator()
          );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
          actions: <Widget>[
            PopupMenuButton<String>(
              onSelected: handleClick,
              itemBuilder: (BuildContext context) {
                return {'Hacker', 'Sponsor', 'Mentor', 'General'}.map((String choice) {
                  return PopupMenuItem<String>(
                    value: choice,
                    child: Text(choice),
                  );
                }).toList();
              },
            ),
          ],
        ),
        body: projectWidget(),
      ),
    );
  }
}