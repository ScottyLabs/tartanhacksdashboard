import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'eventinfo.dart';
import 'package:url_launcher/url_launcher.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
    @override
    Widget build(BuildContext context) {
        return MaterialApp(
            title: 'Flutter Demo',
            theme: ThemeData(
                primarySwatch: Colors.blue,
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
      List<Color> colorsList = [Colors.red, Colors.yellow, Colors.green, Colors.blue];
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
          onTap: () => launch('${data['link']}')
      );
    }

    @override
    Widget build(BuildContext context) {
        // find a way to pull the event information from the database
        // add them to the lists below: event name, event category, event time, event description
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
                body: Container(
                    child: Column(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget> [
                            Expanded(
                                child: ListView.builder(
                                    itemCount: eventData.length,
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
                ),
            ),
        );
    }
}