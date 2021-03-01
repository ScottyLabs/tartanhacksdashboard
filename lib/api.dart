import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'models/login_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'models/event_model.dart';


SharedPreferences prefs;

const baseUrl = "https://thd-api.herokuapp.com/";

Future<Login> checkCredentials(String email, String password) async {
  String url = baseUrl + "auth/login";
  Map<String, String> headers = {"Content-type": "application/json"};
  String json1 = '{"email":"' + email + '","password":"' + password + '"}';

  final response = await http.post(url, headers: headers, body: json1);

  if (response.statusCode == 200) {
    Login loginData;
    var data = json.decode(response.body);
    loginData = new Login.fromJson(data);

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('token', loginData.access_token);
    prefs.setString('email', loginData.user.email);
    prefs.setString('password', password);
    prefs.setBool('is_admin', loginData.user.is_admin);
    prefs.setString('team_id', loginData.user.team_id);

    return loginData;
  } else {
    print(json1);
    return null;
  }
}

Future<String> resetPassword(String email) async {
  print(email);
  String url = baseUrl + "auth/forgot";
  Map<String, String> headers = {"Content-type": "application/json"};
  String json1 = '{"email":"' + email + '"}';
  final response = await http.post(url, headers: headers, body: json1);

  // need to fix for reset password. what is the base url
  if (response.statusCode == 200) {
    return "Please check your email address to reset your password.";
  } else {
    return "We encountered an error while resetting your password. Please contact ScottyLabs for help";
  }
}

Future<List<Event>> getEvents() async {
  var url = baseUrl+'events/get';
  final response = await http.post(url);
  print(response.statusCode);
  if (response.statusCode == 200){
    List<Event> EventsList;
    var data = json.decode(response.body) as List;
    EventsList = data.map<Event> ((json) => Event.fromJson(json)).toList();
    return EventsList;
  }else{
    return null;
  }
}

Future<bool> addEvents(String name, String unixTime, String description, String gcal, String zoom_link, int access_code, String zoom_id, String zoom_password, String duration) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();

  String token = prefs.getString("token");

  String url = baseUrl + "events/new";
  Map<String, String> headers = {"Content-type": "application/json", "Token": token};
  String json1 = '{"name":"' + name + '","timestamp":"' + unixTime + '","description":"' + description + '","zoom_access_enabled":true,"gcal_event_url":"' + gcal + '","zoom_link":"' + zoom_link + '","is_in_person":false,"access_code":' + access_code.toString() + ',"zoom_id":"' + zoom_id + '","zoom_password":"' + zoom_password + '","duration":' + duration + '}';
  print(json1);
  final response = await http.post(url, headers: headers, body: json1);
  if (response.statusCode == 200) {
    return true;
  }else if(response.statusCode == 401){
    refreshToken();
    return addEvents(name, unixTime, description, gcal, zoom_link, access_code, zoom_id, zoom_password, duration);
  }else{
    return false;
  }
}

Future<bool> editEvents(String eventId, String name, String unixTime, String description, String gcal, String zoom_link, int access_code, String zoom_id, String zoom_password, String duration) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();

  String token = prefs.getString("token");

  String url = baseUrl + "events/edit";
  Map<String, String> headers = {"Content-type": "application/json", "Token": token};
  String json1 = '{"_id":"'+eventId+'","name":"' + name + '","timestamp":"' + unixTime + '","description":"' + description + '","zoom_access_enabled":true,"gcal_event_url":"' + gcal + '","zoom_link":"' + zoom_link + '","is_in_person":false,"access_code":' + access_code.toString() + ',"zoom_id":"' + zoom_id + '","zoom_password":"' + zoom_password + '","duration":' + duration + '}';
  print(json1);
  final response = await http.post(url, headers: headers, body: json1);
  if (response.statusCode == 200) {
    return true;
  }else if(response.statusCode == 401){
    refreshToken();
    return addEvents(name, unixTime, description, gcal, zoom_link, access_code, zoom_id, zoom_password, duration);
  }else{
    return false;
  }
}


void refreshToken() async{
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String email = prefs.getString("email");
  String password = prefs.getString("password");
  Login res = await checkCredentials(email, password);
}

