import 'package:flutter/material.dart';
import 'package:scheduling_cards/dart_mongo.dart' as dart_mongo;

class EventInfo {
  // this is test data, the optimal solution is to obtain a JSON of the events table in the MongoDB
  static final getData = [
    {
      'name': 'Hacking Begins!',
      'description': 'start hacking!',
      'time': '9:00 AM',
      'day': 'March 5',
      'link': '',
      'color': 'red',
    },
    {
      'name': 'Flutter Workshop!',
      'description': 'learn flutter!',
      'time': '2:00 PM',
      'day': 'March 6',
      'link': '',
      'color': 'blue',
    },
    {
      'name': 'Dart Workshop!',
      'description': 'learn dart!',
      'time': '4:00 PM',
      'day': 'March 6',
      'link': '',
      'color': 'blue',
    },
    {
      'name': 'Hacking Ends!',
      'description': 'submit your projects!',
      'time': '9:00 PM',
      'day': 'March 7',
      'link': '',
      'color': 'red',
    },
  ];
}