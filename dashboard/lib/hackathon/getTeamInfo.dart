import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'prize.dart';
import 'project.dart';
//import 'login.dart';

const url = "https://thd-api.herokuapp.com/projects/get";

Future<Project> getProject(String teamID, String token) async {

  var body = json.encode({'team_id' : teamID});

  print("printing team ID");
  print(teamID);

  print(body.toString());

  Map<String, String> headers = {"Content-type": "application/json", "Token": token};

  final response = await http.post(url, headers: headers, body: body);

  print(response.body.toString());

  if (response.statusCode == 200) {
    print("response = 200");
    var jsonList = json.decode(response.body);
    print(jsonList.toString());
    if (jsonList.length == 0) {
      //_showDialog("Could not find an existing project", "No project found");
    }
    Project project = Project.fromJson(jsonList[0]);
    return project;
  }
  else if (response.statusCode == 401){
    //_showDialog("Please try logging out and back in", "Error accessing projects");
  }
  return null;
}