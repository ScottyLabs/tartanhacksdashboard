import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'loginmodel.dart';

const baseUrl = "https://thd-api.herokuapp.com/auth/login";

Future<Login> checkCredentials(String email, String password) async {
  //print(email);
  //print(password);

  String url = baseUrl;
  Map<String, String> headers = {"Content-type": "application/json"};
  String json1 = '{"email":"' + email + '","password":"' + password + '"}';

  final response = await http.post(url, headers: headers, body: json1);
  if (response.statusCode == 200) {
    Login loginData;
    var data = json.decode(response.body);
    loginData = new Login.fromJson(data);
    return loginData;
  } else if (response.statusCode == 401) {
    print(response.statusCode);
    return null;
  } else {
    print(json1);
    return null;
  }
}

Future<Login> resetPassword(String email) async {
  String url = baseUrl;
  Map<String, String> headers = {"Content-type": "application/json"};
  String json1 = '{"email":"' + email + '"}';
  final response = await http.post(url, headers: headers, body: json1);

  // need to fix for reset password. what is the base url
  if (response.statusCode == 200) {
    Login loginData;
    var data = json.decode(response.body);
    loginData = new Login.fromJson(data);
    return loginData;
  } else if (response.statusCode == 401) {
    print(response.statusCode);
    return null;
  } else {
    print(json1);
    return null;
  }
}
