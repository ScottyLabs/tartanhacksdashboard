import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'eventmodel.dart';
import 'events.dart';
import 'apicall.dart';
import 'package:intl/intl.dart';
import 'package:share/share.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'login.dart';


class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => new _ProfileScreenState();
}



class _ProfileScreenState extends State<ProfileScreen> {

  final past_events = [];
  final upcoming_events = [];
  var eventData = [];

  getData() async {
    eventData = await getEvents();
    var currentTime = DateTime.now().millisecondsSinceEpoch / 1000;
    for (int i=0; i<eventData.length; i++) {
      if (currentTime > int.parse(eventData[i].timestamp)) {
        past_events.add(eventData[i]);
      } else {
        upcoming_events.add(eventData[i]);
      }
    }
    eventData = upcoming_events;
    setState(() {});
  }

  @override
  initState() {
    super.initState();
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
                  fontFamily: 'TerminalGrotesque'),
            )));
  }

  // description for the event
  Widget eventDescription(data) {
    return Align(
        alignment: Alignment.centerLeft,
        child: Container(
            width: MediaQuery.of(context).size.width * 0.60,
            child: RichText(
                text: TextSpan(
                  text: '\n${data.description}',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 15,
                  ),
                ))));
  }

  String formatDate(String unixDate) {
    var date =
    new DateTime.fromMillisecondsSinceEpoch(int.parse(unixDate) * 1000);
    date = date.toLocal();
    String formattedDate = DateFormat('EEE dd MMM').format(date);
    return formattedDate.toUpperCase();
  }

  String getTime(String unixDate) {
    var date =
    new DateTime.fromMillisecondsSinceEpoch(int.parse(unixDate) * 1000);
    date = date.toLocal();
    String formattedDate = DateFormat('hh:mm a').format(date);
    return formattedDate;
  }

  Widget eventTime(data) {
    return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text(
            '${getTime(data.timestamp)}',
            textAlign: TextAlign.center,
            style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontSize: 20,
                fontFamily: 'TerminalGrotesque'),
          ),
          Text(
            '${formatDate(data.timestamp)}',
            textAlign: TextAlign.center,
            style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontSize: 16.5,
                fontFamily: 'TerminalGrotesque'),
          ),
        ]);
  }

  // hyperlinked button for the event
  Widget zoomLink(data) {
    if (data.access_code == 2){
      return IconButton(
          icon: new Image.asset(
            "lib/logos/hopinLogo.png",
            width: 24,
            height: 24,
            color: Colors.white,
          ),
          tooltip: 'Zoom Link!',
          color: Color.fromARGB(255, 37, 130, 242),
          onPressed: () => launch('${data.zoom_link}')
      );
    }
    else if (data.access_code == 1){
      return IconButton(
          icon: Icon(
            Icons.videocam,
            color: Colors.white,
            size: 25,
          ),
          tooltip: 'Zoom Link!',
          color: Color.fromARGB(255, 37, 130, 242),
          onPressed: () => launch('${data.zoom_link}')
      );
    }
    else{
      return IconButton(
          icon: new Image.asset(
            "lib/logos/discordLogoWhite.png",
            width: 24,
            height: 24,
            color: Colors.white,
          ),
          tooltip: 'Zoom Link!',
          color: Color.fromARGB(255, 37, 130, 242),
          onPressed: () => launch('${data.zoom_link}')
      );
    }}

  Widget calLink(data) {
    return IconButton(
        icon: Icon(
          Icons.calendar_today_outlined,
          color: Colors.white,
          size: 25,
        ),
        tooltip: 'Calendar Link!',
        color: Color.fromARGB(255, 37, 130, 242),
        onPressed: () => launch('${data.gcal_event_url}')
    );
  }

  Widget shareLink(data) {
    return IconButton(
      icon: Icon(
        Icons.ios_share,
        color: Colors.white,
        size: 25,
      ),
      tooltip: 'Share Link!',
      color: Color.fromARGB(255, 37, 130, 242),
      onPressed: ()
      {
        String text = 'Join ${data.name} at ' + '${data.zoom_link}';
        final RenderBox box = context.findRenderObject();
        Share.share(text,
            sharePositionOrigin:
            box.localToGlobal(Offset.zero) &
            box.size);
      },
    );
  }

  Widget editEvent(data) {
    return IconButton(
        icon: Icon(
          Icons.edit,
          color: Colors.white,
          size: 25,
        ),
        tooltip: 'Edit Event',
        color: Color.fromARGB(255, 37, 130, 242),
        onPressed: ()
        {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  scrollable: true,
                  title: Text('Edit Event'),
                  // Need to figure out how to
                );
              }
          );
        }
    );
  }

  void _showDialog(String response, String title) {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text(title),
          content: new Text(response),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text(
                "OK",
                style: new TextStyle(color: Colors.white),
              ),
              color: new Color.fromARGB(255, 255, 75, 43),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: PreferredSize(
          child: new AppBar(
            title: new Text(
              'Hacker Profile',
              textAlign: TextAlign.center,
              style: new TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            backgroundColor: Color.fromARGB(255, 37, 130, 242),
          ),
          preferredSize: Size.fromHeight(60)),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(children: <Widget>[
          Row(children: <Widget>[
            //eventIcon(eventData[index]),
            eventName(eventData[index]),
          ]),
        ])

      ),
    );
  }
}
