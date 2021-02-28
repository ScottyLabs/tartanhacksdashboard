import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'models/login_model.dart';
import 'package:shared_preferences/shared_preferences.dart';


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
