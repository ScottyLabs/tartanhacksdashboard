import 'package:flutter/material.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/services.dart';
import 'json-classes.dart';



void main(){
  runApp(Leaderboard());
}

class Leaderboard extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    return MaterialApp(
        title: 'Leaderboard',
        home: LBPage()
    );
  }
}



class InfoTile extends StatelessWidget{
  final Participant info;
  final int rank;

  InfoTile({this.info, this.rank});

  @override
  Widget build(BuildContext context){
    return Card(
        margin: const EdgeInsets.all(12),
          child: Padding(
              padding: const EdgeInsets.all(24),
              child: Row(
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                            '$rank',
                            style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                            )
                        ),
                      ],
                    ),
                    const SizedBox(width: 20),
                    Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                              '${info.name}',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              )
                          ),
                          const SizedBox(height: 8),
                          Text(
                              'Total points: ${info.total_points}',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[500],
                              )
                          ),
                        ]
                    )
                  ]
              )
          )
    );
  }
}



class LBPage extends StatefulWidget{
  @override
  _LBState createState() => _LBState();
}

class _LBState extends State<LBPage>{

  List lboard;
  bool loaded = false;

  Future getLB() async{
    var response = await http.get(
        Uri.https("thd-api.herokuapp.com", "/checkin/leaderboard",),
        headers:{"token": "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.IjVmMTMyYzIzNmVlYThmMDAyM2ZiMGQ0OCI.-vRgqFjQrxToLEVPKnu-2w-2wakuH_62BfElCvuyBZo"}
    );

    List data = json.decode(response.body);
    data = data.map((element) =>
        Participant.fromJson(Map<String, dynamic>.from(element))).toList();
    if(this.mounted){
      setState(() {
        lboard = data;
        loaded = true;
      });
    }
  }

  @override
  void initState() {
    if(lboard != null){
      lboard = null;
    }
    getLB();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
            children: <Widget>[
              (lboard != null) ?
              Expanded(
                child: ListView.builder(
                  itemCount: lboard.length,
                  itemBuilder: (BuildContext context, int index){
                    return InfoTile(info: lboard[index], rank: index+1);
                  },
                ),
              )
              : SizedBox(
                  height: 100,
                  child: Align(
                      alignment: Alignment.center,
                      child:
                      (loaded) ?
                      Text(
                          "No leaderboard data found.",
                          style: TextStyle(
                            fontSize: 30,
                          )
                      )
                          : Text(
                          "Loading...",
                          style: TextStyle(
                            fontSize: 35,
                            fontWeight: FontWeight.bold,
                          )
                      )
                  )
              )
            ]
        )
    );
  }
}