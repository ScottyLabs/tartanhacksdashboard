import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

Future<EventsList> fetchEvents() async {
  var url = 'https://thd-api.herokuapp.com/events/get';
  var body = json.encode({});
  var response = await http.post(
    url,
    headers: {
      'accept': 'application/json',
      'Content-Type': 'application/json-patch+json',
    },
    body: body,
  );
  print(jsonDecode(response.body));

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    return EventsList.fromJson(jsonDecode(response.body));
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load events');
  }
}

class Event {
  final String name;
  final String description;
  final String timestamp;
  final String zoom_link;

  Event({this.name, this.description, this.timestamp, this.zoom_link});

  factory Event.fromJson(Map<String, dynamic> parsedJson) {
    return Event(
      name: parsedJson['name'],
      description: parsedJson['description'],
      timestamp: parsedJson['timestamp'],
      zoom_link: parsedJson['zoom_link'],
    );
  }
}

class EventsList {
  final List<Event> events;

  EventsList({
    this.events,
  });

  factory EventsList.fromJson(List<dynamic> parsedJson) {
    List<Event> events = new List<Event>();
    events = parsedJson.map((i)=>Event.fromJson(i)).toList();
    print('events -> ${events}');

    return new EventsList(
      events: events
    );
  }
}

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  MyApp({Key key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Future<EventsList> futureEventsList;

  @override
  void initState() {
    super.initState();
    futureEventsList = fetchEvents();
  }

  Color getColor(categoryNum){
    List<Color> colorsList = [Colors.redAccent[100], Colors.redAccent, Colors.redAccent[400], Colors.redAccent[700]];
    final colorsMap = colorsList.asMap();
    return colorsMap[categoryNum - 1];
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Events',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text('Events'),
        ),
        body: Center(
          child: FutureBuilder<EventsList>(
            future: futureEventsList,
            builder: (context, snapshot) {
              print('project snapshot data is: ${snapshot.data}'); // this is currently null, even though the response goes through on main2.dart and it's printable, we need to check to make sure the types are right, etc.
              if (snapshot.hasData) {
                return Container(
                    child: Column(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget> [
                          Expanded(
                              child: ListView.builder(
                                  // todo - FIND OUT WHAT TO REPLACE eventData with
                                  itemCount: snapshot.length,
                                  itemBuilder: (context, index) {
                                    return Container(
                                        padding: EdgeInsets.fromLTRB(10,10,10,0),
                                        height: 220,
                                        width: double.maxFinite,
                                        child: Card(
                                          elevation: 5,
                                          color: getColor(eventData[index]['category']),
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
                                                                  child: eventTime(eventData[index]),
                                                                ),
                                                              ),
                                                              Padding(
                                                                  padding: const EdgeInsets.only(left:10, top: 5),
                                                                  child: Column(
                                                                      children: <Widget> [
                                                                        Row(
                                                                            children: <Widget> [
                                                                              eventIcon(eventData[index]),
                                                                              SizedBox(
                                                                                width: 10,
                                                                              ),
                                                                              eventName(eventData[index]),
                                                                            ]
                                                                        ),
                                                                        Row(
                                                                            children: <Widget> [
                                                                              eventDescription(eventData[index]),
                                                                            ]
                                                                        ),
                                                                        SizedBox(
                                                                          height: 10,
                                                                        ),
                                                                        Align(
                                                                            alignment: Alignment.centerLeft,
                                                                            child: Container(
                                                                              child: RaisedButton(
                                                                                child: eventLink(eventData[index]),
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
                                          ),
                                        )
                                    );
                                  }
                              )
                          )
                        ]
                    )
                );
              } else if (snapshot.hasError) {
                return Text("${snapshot.error}");
              }
              // By default, show a loading spinner.
              return CircularProgressIndicator();
            },
          ),
        ),
      ),
    );
  }
}
