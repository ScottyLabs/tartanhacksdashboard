import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

class Event {
  final String name;
  final String description;
  final String timestamp;

  Event({this.name, this.description, this.timestamp});

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      name: json['name'],
      description: json['description'],
      timestamp: json['timestamp'],
    );
  }
}

Future<Map<String, dynamic>> getEventDetails() async {
  var url = 'https://thd-api.herokuapp.com/events/get';
  var body = json.encode({});

  print('Body: $body');

  var response = await http.post(
    url,
    headers: {
      'accept': 'application/json',
      'Content-Type': 'application/json-patch+json',
    },
    body: body,
  );
  print(json.decode(response.body));

  // todo - handle non-200 status code, etc
  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    print(json.decode(response.body));
    return json.decode(response.body);
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load events.');
  }
}

class EventInfo {
  // this is test data, the optimal solution is to obtain a JSON of the events table in the MongoDB

  static final getData2 = [getEventDetails()];

  static final getData = [
    {
      'name': 'Hacking Begins!',
      'description': 'Come up with ideas with your team, and start hacking!',
      'time': '9:00 AM',
      'day': 'March 5',
      'link': 'https://www.google.com/',
      'category': 1,
    },
    {
      'name': 'Flutter Workshop!',
      'description': 'Learn how to use Flutter!',
      'time': '2:00 PM',
      'day': 'March 6',
      'link': 'https://www.google.com/',
      'category': 2,
    },
    {
      'name': 'Dart Workshop!',
      'description': 'Learn how to code in Dart!',
      'time': '4:00 PM',
      'day': 'March 6',
      'link': 'https://www.google.com/',
      'category': 3,
    },
    {
      'name': 'Hacking Ends!',
      'description': 'Hacking is over! Submit your projects before the deadline to be judged!',
      'time': '9:00 PM',
      'day': 'March 7',
      'link': 'https://www.google.com/',
      'category': 4,
    },
  ];
}