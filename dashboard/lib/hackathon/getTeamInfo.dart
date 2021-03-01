import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'prize.dart';
import 'project.dart';

const url = "https://thd-api.herokuapp.com/projects/get";

Future<Project> getProject(String teamID, String token) async {
  final response = await http.post(url, headers: {'Token' : token});

  if (response.statusCode == 200) {
    print("response = 200");
    var jsonList = json.decode(response.body);
    Project project = Project.fromJson(jsonList[0]);
    return project;
  }
  return null;
}