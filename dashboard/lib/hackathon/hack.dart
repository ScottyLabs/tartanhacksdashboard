import 'package:dashboard/hackathon/submission.dart';
import 'package:flutter/material.dart';

class HackHome extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Color.fromARGB(0xFF, 0x25, 0x82, 0xF2), 
        title: Text('Hackathon'),
      ),
      body: ListView(
      children: [
        Card(
          child: ListTile(
            title: Text("Project Submission"),
            subtitle: Text("Submit your project link here!"),
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => Submission())),
            ),
        )
      ],
    ));
  }
  
}