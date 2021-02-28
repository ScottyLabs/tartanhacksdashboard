import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'prize.dart';

const url = "https://thd-api.herokuapp.com/projects/prizes/get";

Future<List<Prize>> getAllPrizes() async {
  final response = await http.post(url);

  if (response.statusCode == 200) {
    List<Prize> prizes;
    var jsonList = json.decode(response.body) as List;
    prizes = jsonList.map((i) => Prize.fromJson(i)).toList();
    print(prizes.toString);
    return prizes;
  }
  return null;
}

