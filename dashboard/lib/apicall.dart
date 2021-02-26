import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'eventmodel.dart';

Future<List<Event>> getEvents() async {
  var url = 'https://thd-api.herokuapp.com/events/get';
  final response = await http.post(url);
  print(response.statusCode);
  if (response.statusCode == 200){
    List<Event> EventsList;
    var data = json.decode(response.body) as List;
    EventsList = data.map<Event> ((json) => Event.fromJson(json)).toList();
    print(EventsList);
    return EventsList;
  }else{
    return null;
  }
}