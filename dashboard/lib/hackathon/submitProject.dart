import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'prize.dart';
//import 'login.dart''

String url = "https://thd-api.herokuapp.com/projects/";

void enterProject(String projectID, List<String> prizeIds, String token) async {
  String new_url = url + "/prizes/enter" + "?project_id=" + projectID;

  Map<String, String> headers = {
    "Content-type": "application/json",
    "Token": token
  };

  for (String prize in prizeIds) {
    String updated_url = new_url + "&prize_id=" + prize;
    var response = await http.get(updated_url, headers: headers);
    if (response.statusCode != 200 && response.statusCode != 400) {
      print("error");
      print(response.statusCode);
      //_showDialog("Error with Submission", "Unable to submit project for prize");
      return;
    }
    //_showDialog("Your project was submitted.", "Success");
  }
}

Future<bool> editProject(String teamID, String token, String github, String slides, String video, bool presenting, String id, List<String> prizeIds) async {

  String new_url = url + "/edit";

  print("printing id again");
  print(id);

  Map<String, String> headers = {"Content-type": "application/json", "Token": token};

  var body = json.encode({'_id' : id, 'team_id' : teamID, 'github_url' : github, 'slides_url' : slides,
                          'video_url' : video, 'will_present_live' : presenting});

  final response = await http.post(new_url, headers: headers, body: body);

  print(response.body.toString());

  if (response.statusCode == 200) {
    enterProject(id, prizeIds, token);
    return true;
  }
  return false;
}

Future<bool> newProject(String teamID, String token, String github, String slides, String video, bool presenting, String id, List<String> prizeIds) async {

  String new_url = url + "/new";

  Map<String, String> headers = {"Content-type": "application/json", "Token": token};

  var body = json.encode({'_id' : id, 'team_id' : teamID, 'github_url' : github, 'slides_url' : slides,
  'video_url' : video, 'will_present_live' : presenting, '_id' : id});

  final response = await http.post(new_url, headers: headers, body: body);

  if (response.statusCode == 200) {
    enterProject(id, prizeIds, token);
    return true;
  }
  return false;
}
