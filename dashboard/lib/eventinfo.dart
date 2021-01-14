import 'package:flutter/material.dart';
//import 'package:scheduling_cards/dart_mongo.dart' as dart_mongo;

class EventInfo {
  // this is test data, the optimal solution is to obtain a JSON of the events table in the MongoDB
  static final getData = [
    {
      'name': 'Hacking Begins!',
      'description': 'TartanHacks has officially started! Come up with ideas with your team, and start hacking!',
      'time': '9:00 AM',
      'day': 'March 5',
      'link': 'https://www.google.com/',
      'category': 1,
    },
    {
      'name': 'Flutter Workshop!',
      'description': 'Learn how to use the Flutter SDK made by Google to develop cross-platform applications!',
      'time': '2:00 PM',
      'day': 'March 6',
      'link': 'https://www.google.com/',
      'category': 2,
    },
    {
      'name': 'Dart Workshop!',
      'description': 'Learn how to code in Dart to build applications in conjunction with Flutter!',
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