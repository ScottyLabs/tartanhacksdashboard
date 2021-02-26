import 'package:flutter/material.dart';

class Submission extends StatefulWidget {
  @override
  _SubmissionState createState() => _SubmissionState();
}
class FormScreen extends StatefulWidget{
  @override
  _FormScreenState createState() => _FormScreenState();
}
class _SubmissionState extends State<Submission>{
  @override
  Widget build(BuildContext context) {
    return FormScreen();
  }
}
class _FormScreenState extends State<FormScreen> {

  String _teamName;
  String _githubUrl;
  String _presUrl;
  String _vidUrl;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  Widget _buildName() {
    return TextFormField(
      decoration: InputDecoration(labelText: 'Team Name'),
      validator: (String value) {
        if (value.isEmpty) {
          return 'Name is Required';
        }

        return null;
      },
      onSaved: (String value) {
        _teamName = value;
      },
    );
  }

  Widget _buildGitHubURL() {
    return TextFormField(
      decoration: InputDecoration(labelText: 'GitHub Repository Url'),
      keyboardType: TextInputType.url,
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
  bool valuenone = false;  
  bool valueEchoAR = false;
  bool valueGoogle = false; 
  bool valueMicrosoft = false; 
  bool valueFacebook = false;
  bool valueWayfair = false; 
  bool valueCO = false; 
  bool valueSocial = false; 
  bool valueImpCMU = false; 
  bool value9 = false; 
  bool value10 = false; 


  Widget _buildPrizes(){
    return Container(  
            padding: new EdgeInsets.all(10.0),  
            child: Column(  
              children: <Widget>[  
                SizedBox(width: 20,),  
                Text('Prizes',textAlign: TextAlign.left, style: TextStyle(fontSize: 20.0), ),
                Text('Select which prizes you are submitting your project to. All projects are automatically submitted to the ScottyLabs Grand Prize.',textAlign: TextAlign.left, style: TextStyle(fontSize: 15.0), ),  
                CheckboxListTile(
                  controlAffinity: ListTileControlAffinity.leading,
                  title: const Text('None'),  
                  value: this.valuenone,  
                  onChanged: (bool value) {  
                    setState(() {  
                      this.valuenone = value;  
                    });  
                  },  
                ),  
                CheckboxListTile(
                  controlAffinity: ListTileControlAffinity.leading,
                  title: const Text('EchoAR Prize: 3 month business plan'),  
                  value: this.valueEchoAR,  
                  onChanged: (bool value) {  
                    setState(() {  
                      this.valueEchoAR = value;  
                    });  
                  },  
                ),  
                CheckboxListTile(  
                  controlAffinity: ListTileControlAffinity.leading,  
                  title: const Text('Google Prize'),  
                  value: this.valueGoogle,  
                  onChanged: (bool value) {  
                    setState(() {  
                      this.valueGoogle = value;  
                    });  
                  },  
                ),  
                CheckboxListTile(
                  controlAffinity: ListTileControlAffinity.leading,
                  title: const Text('Microsoft: Azure Champ Prize: Hack for Good'),  
                  value: this.valueMicrosoft,  
                  onChanged: (bool value) {  
                    setState(() {  
                      this.valueMicrosoft = value;  
                    });  
                  },  
                ),  
                CheckboxListTile(
                  controlAffinity: ListTileControlAffinity.leading,
                  title: const Text('Facebook Prize'),  
                  value: this.valueFacebook,  
                  onChanged: (bool value) {  
                    setState(() {  
                      this.valueFacebook = value;  
                    });  
                  },  
                ),  
                CheckboxListTile(
                  controlAffinity: ListTileControlAffinity.leading,
                  title: const Text('Wayfair Prize: Best Hack to Solve an Inequality Crisis'),  
                  value: this.valueWayfair,  
                  onChanged: (bool value) {  
                    setState(() {  
                      this.valueWayfair = value;  
                    });  
                  },  
                ), 

                CheckboxListTile(
                  controlAffinity: ListTileControlAffinity.leading,
                  title: const Text('CaptialOne Prize: Best Financial Hack'),  
                  value: this.valueCO,  
                  onChanged: (bool value) {  
                    setState(() {  
                      this.valueCO = value;  
                    });  
                  },  
                ), 

                CheckboxListTile(
                  controlAffinity: ListTileControlAffinity.leading,
                  title: const Text('Best Social Impact Hack'),  
                  value: this.valueSocial,  
                  onChanged: (bool value) {  
                    setState(() {  
                      this.valueSocial = value;  
                    });  
                  },  
                ), 

                CheckboxListTile(
                  controlAffinity: ListTileControlAffinity.leading,
                  title: const Text('Impact CMU Award'),  
                  value: this.valueImpCMU,  
                  onChanged: (bool value) {  
                    setState(() {  
                      this.valueImpCMU = value;  
                    });  
                  },  
                ), 

                CheckboxListTile(
                  controlAffinity: ListTileControlAffinity.leading,
                  title: const Text('Prize 9'),  
                  value: this.value9,  
                  onChanged: (bool value) {  
                    setState(() {  
                      this.value9 = value;  
                    });  
                  },  
                ), 

                CheckboxListTile(
                  controlAffinity: ListTileControlAffinity.leading,
                  title: const Text('Prize 10'),  
                  value: this.value10,  
                  onChanged: (bool value) {  
                    setState(() {  
                      this.value10 = value;  
                    });  
                  },  
                ), 

              ],  
            )  
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

                      print(_teamName);
                      print(_githubUrl);
                      print(_presUrl);
                      print(_vidUrl);
                      print("EchoAR: $valueEchoAR ");
                      print("Google: $valueGoogle ");
                      print("Microsoft: $valueMicrosoft ");
                      print("Facebook: $valueFacebook ");
                      print("Prize 5: $valueWayfair ");
                      print("Prize 6: $valueCO ");
                      print("Prize 7: $valueSocial ");
                      print("Prize 8: $valueImpCMU ");
                      print("Prize 9: $value9 ");
                      print("Prize 10: $value10 ");
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
