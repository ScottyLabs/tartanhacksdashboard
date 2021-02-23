import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

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

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    //print('The response body is: ${jsonDecode(response.body)}');
    print(jsonDecode(response.body));
    //return (jsonDecode(response.body));
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
  //EventsList regularEventsList;
  bool _isFavorited = true;

  @override

  void _toggleFavorite() {
    setState(() {
      if (_isFavorited) {
        _isFavorited = false;
      } else {
        _isFavorited = true;
      }
    });
  }

  void initState() {
    super.initState();
    futureEventsList = fetchEvents();
    //fetchEvents().then( (EventsList regularEventsList2) => regularEventsList );
    //print('regularEventsList:  ${regularEventsList}');
  }

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
              text: '${data.name}',
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
                  text: '\n${data.description}',
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
                text: '${data.timestamp}',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontSize: 20,
                ),
                children: <TextSpan> [
                  TextSpan(
                      text: '\n${data.timestamp}',
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
        onTap: () => launch('${data.zoom_link}')
    );
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
              print('project snapshot data is: ${snapshot.data}'); // this is currently null, even though the response goes through & it's printable
              if (snapshot.hasData) {
                print('snapshot.data.events: ${snapshot.data.events}');
                return Container(
                    child: Column(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget> [
                          Expanded(
                              child: ListView.builder(
                                  itemCount: snapshot.data.events.length,
                                  itemBuilder: (context, index) {
                                    return Container(
                                        padding: EdgeInsets.fromLTRB(10,10,10,0),
                                        height: 220,
                                        width: double.maxFinite,
                                        child: Card(
                                          elevation: 5,
                                          //color: getColor(regularEventsList.events[index]['category']),
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
                                                                  child: eventTime(snapshot.data.events[index]),
                                                                ),
                                                              ),
                                                              Padding(
                                                                  padding: const EdgeInsets.only(left:10, top: 5),
                                                                  child: Column(
                                                                      children: <Widget> [
                                                                        Row(
                                                                            children: <Widget> [
                                                                              eventIcon(snapshot.data.events[index]),
                                                                              SizedBox(
                                                                                width: 10,
                                                                              ),
                                                                              eventName(snapshot.data.events[index]),
                                                                            ]
                                                                        ),
                                                                        Row(
                                                                            children: <Widget> [
                                                                              eventDescription(snapshot.data.events[index]),
                                                                            ]
                                                                        ),
                                                                        SizedBox(
                                                                          height: 10,
                                                                        ),
                                                                        Align(
                                                                            alignment: Alignment.centerLeft,
                                                                            child: Container(
                                                                              child: RaisedButton(
                                                                                child: eventLink(snapshot.data.events[index]),
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
              return CircularProgressIndicator();
            },
          ),
        ),
      ),
    );
  }
}
