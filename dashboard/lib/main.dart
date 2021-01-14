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

    void _toggleFavorite() {
        setState(() {
            if (_isFavorited) {
                _isFavorited = false;
            } else {
                _isFavorited = true;
            }
        });
    }

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

    Widget eventIcon(data) {
        // var categorycolor = '${data['color']}';
        return Padding(
            padding: const EdgeInsets.only(left: 1.0),
            child: Align(
                alignment: Alignment.centerLeft,
                child: Column(
                  children: <Widget> [
                    IconButton(
                        icon: Icon(
                            Icons.star_border,
                            color: Colors.red,
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
            child: RichText(
                  text: TextSpan(
                      text: '\n${data['description']}',
                      style: TextStyle(
                          color: Colors.grey,
                          fontSize: 15,
                          fontWeight: FontWeight.bold
                      ),
                  )
            )
        );
    }

    Widget eventTime(data) {
        return Align(
            alignment: Alignment.centerRight,
            child: RichText(
                text: TextSpan(
                    text: '${data['time']}',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                        fontSize: 20,
                    ),
                    children: <TextSpan> [
                        TextSpan(
                            text: '\n${data['day']}',
                            style: TextStyle(
                                color: Colors.green,
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
                                                child: Padding(
                                                    padding: EdgeInsets.all(7),
                                                    child: Stack(
                                                        children: <Widget> [
                                                            Align(
                                                                alignment: Alignment.centerRight,
                                                                child: Stack(
                                                                    children: <Widget> [
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
                                                                                            SizedBox(
                                                                                              width: 30,
                                                                                            ),
                                                                                            Container(
                                                                                                alignment: Alignment.centerRight,
                                                                                                child: eventTime(eventData[index]),
                                                                                            ),
                                                                                            SizedBox(
                                                                                                height: 10,
                                                                                            ),
                                                                                        ]
                                                                                    ),
                                                                                    Row(
                                                                                      children: <Widget> [
                                                                                        eventDescription(eventData[index]),
                                                                                      ]
                                                                                    ),
                                                                                    SizedBox(
                                                                                      height: 30
                                                                                    ),
                                                                                    Container(
                                                                                      child: Center(
                                                                                        child: RaisedButton(
                                                                                          child: eventLink(eventData[index]),
                                                                                          color: Colors.red,
                                                                                        ),
                                                                                      )
                                                                                    )
                                                                                ]
                                                                            )
                                                                        )
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