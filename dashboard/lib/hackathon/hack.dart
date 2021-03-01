import 'package:flutter/material.dart';
import 'prize.dart';
import 'getPrizes.dart';
import 'dart:async';
import 'package:grouped_buttons/grouped_buttons.dart';
import 'project.dart';
import 'getTeamInfo.dart';

class HackHome extends StatefulWidget {
  @override
  _HackHomeState createState() => _HackHomeState();
}
class FormScreen extends StatefulWidget{
  @override
  _FormScreenState createState() => _FormScreenState();
}
class _HackHomeState extends State<HackHome>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Color.fromARGB(0xFF, 0x25, 0x82, 0xF2), 
        title: Text('Hackathon'),
      ),
      body: Center(
        child: RaisedButton(
          color: Color.fromARGB(0xFF, 0x5D, 0x5F, 0x61),
          child: Text('Project Submission Form', 
          style: TextStyle(color: Colors.white, fontSize: 16),),
          
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => FormScreen()),
            );
          },
        ),
      ),
    );
  }
}
class _FormScreenState extends State<FormScreen> {

  String _projName = "";
  String _githubUrl = "";
  String _presUrl = "";
  String _vidUrl = "";
  List<Prize> prizes = [];
  List<String> selectedNames = [];
  List<String> prizeNames = [];
  //TODO: update with values from checkin endpoint
  String teamID = "someTeam"; //dummy value for commit
  String token = "123"; //dummy value for commit
  bool hasProject = false;
  TextEditingController nameController = TextEditingController();
  TextEditingController githubController = TextEditingController();
  TextEditingController slidesController = TextEditingController();
  TextEditingController videoController = TextEditingController();

  @override
  void initState() {
    super.initState();
    getData();

  }

  getData() async {
    prizes = await getAllPrizes();
    prizeNames = getPrizeNames(prizes);
    Project proj = await getProject(teamID, token);
    if (proj != null) {
      hasProject = true;
      _projName = proj.name;
      _presUrl = proj.slides;
      _vidUrl = proj.video;
      _githubUrl = proj.github;
      nameController.text = _projName;
      slidesController.text = _presUrl;
      videoController.text = _vidUrl;
      githubController.text = _githubUrl;
      selectedNames = [];
    }
    setState(() {});
  }

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  Widget _buildName() {
    return TextFormField(
      decoration: InputDecoration(labelText: 'Project Name'),
      controller: nameController,
      validator: (String value) {
        if (value.isEmpty) {
          return 'Project name is required';
        }

        return null;
      },
      onSaved: (String value) {
        _projName = value;
      },
    );
  }

  Widget _buildGitHubURL() {
    return TextFormField(
      decoration: InputDecoration(labelText: 'GitHub Repository Url'),
      keyboardType: TextInputType.url,
      controller: githubController,
      validator: (String value) {
        if (value.isEmpty) {
          return 'URL is Required';
        }

        return null;
      },
      onSaved: (String value) {
        _githubUrl = value;
      },
    );
  }

  Widget _buildPresURL() {
    return TextFormField(
      decoration: InputDecoration(labelText: 'Presentation Url'),
      controller: slidesController,
      keyboardType: TextInputType.url,
      validator: (String value) {
        if (value.isEmpty) {
          return 'URL is Required';
        }

        return null;
      },
      onSaved: (String value) {
        _presUrl = value;
      },
    );
  }

  Widget _buildVidURL() {
    return TextFormField(
      decoration: InputDecoration(labelText: 'Video Url'),
      controller: videoController,
      keyboardType: TextInputType.url,
      validator: (String value) {
        if (value.isEmpty) {
          return 'URL is Required';
        }

        return null;
      },
      onSaved: (String value) {
        _vidUrl = value;
      },
    );
  }

  List<String> getPrizeNames(List<Prize> prizes) {
    List<String> prizeNames = [];

    for (var prize in prizes) {
      prizeNames.add(prize.name);
    }
    return prizeNames;
  }


  Widget _buildPrizes() {
    return CheckboxGroup(
        padding: new EdgeInsets.all(10.0),
        orientation: GroupedButtonsOrientation.VERTICAL,
        margin: const EdgeInsets.only(left: 12.0),
        labels: prizeNames,
        onSelected: ((List<String> checked) => selectedNames = checked)
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Color.fromARGB(0xFF, 0x25, 0x82, 0xF2), title: Text("Project Submission Form")),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Center(
            
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  _buildName(),
                  _buildGitHubURL(),
                  _buildPresURL(),
                  _buildVidURL(),
                  _buildPrizes(),
                  SizedBox(height: 10),
                  RaisedButton(
                    color: Color.fromARGB(0xFF, 0x5D, 0x5F, 0x61),
                    child: Text(
                      'Send',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                    onPressed: () {
                      if (!_formKey.currentState.validate()) {
                        return;
                      }

                      _formKey.currentState.save();

                      print(_projName);
                      print(_githubUrl);
                      print(_presUrl);
                      print(_vidUrl);

                      List<String> selectedIds = [];

                      for (var prizeItem in prizes) {
                        if (selectedNames.contains(prizeItem.name)) {
                          selectedIds.add(prizeItem.id);
                        }
                      }
                      print(selectedIds.toString());

                      //Send to API
                    },
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
  
}
