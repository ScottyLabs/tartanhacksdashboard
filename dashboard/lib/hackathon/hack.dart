import 'package:flutter/material.dart';

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
      appBar: AppBar(backgroundColor: Colors.red, 
        title: Text('Hackathon'),
      ),
      body: Center(
        child: RaisedButton(
          child: Text('Project Submission Form', 
          style: TextStyle(color: Colors.red, fontSize: 16),),
          
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

  String _teamName;
  String _url;
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

  Widget _buildURL() {
    return TextFormField(
      decoration: InputDecoration(labelText: 'Project Url'),
      keyboardType: TextInputType.url,
      validator: (String value) {
        if (value.isEmpty) {
          return 'URL is Required';
        }

        return null;
      },
      onSaved: (String value) {
        _url = value;
      },
    );
  }

  bool valuenone = false;  
  bool value1 = false;
  bool value2 = false; 
  bool value3 = false; 
  bool value4 = false;
  bool value5 = false; 


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
                  title: const Text('Prize 1'),  
                  value: this.value1,  
                  onChanged: (bool value) {  
                    setState(() {  
                      this.value1 = value;  
                    });  
                  },  
                ),  
                CheckboxListTile(  
                  controlAffinity: ListTileControlAffinity.leading,  
                  title: const Text('Prize 2'),  
                  value: this.value2,  
                  onChanged: (bool value) {  
                    setState(() {  
                      this.value2 = value;  
                    });  
                  },  
                ),  
                CheckboxListTile(
                  controlAffinity: ListTileControlAffinity.leading,
                  title: const Text('Prize 3'),  
                  value: this.value3,  
                  onChanged: (bool value) {  
                    setState(() {  
                      this.value3 = value;  
                    });  
                  },  
                ),  
                CheckboxListTile(
                  controlAffinity: ListTileControlAffinity.leading,
                  title: const Text('Prize 4'),  
                  value: this.value4,  
                  onChanged: (bool value) {  
                    setState(() {  
                      this.value4 = value;  
                    });  
                  },  
                ),  
                CheckboxListTile(
                  controlAffinity: ListTileControlAffinity.leading,
                  title: const Text('Prize 5'),  
                  value: this.value5,  
                  onChanged: (bool value) {  
                    setState(() {  
                      this.value5 = value;  
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
      appBar: AppBar(backgroundColor: Colors.red, title: Text("Project Submission Form")),
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
                  _buildURL(),
                  _buildPrizes(),
                  SizedBox(height: 10),
                  RaisedButton(
                    child: Text(
                      'Send',
                      style: TextStyle(color: Colors.red, fontSize: 16),
                    ),
                    onPressed: () {
                      if (!_formKey.currentState.validate()) {
                        return;
                      }

                      _formKey.currentState.save();

                      print(_teamName);
                      print(_url);
                      print("Prize 1: $value1 ");
                      print("Prize 2: $value2 ");
                      print("Prize 3: $value3 ");
                      print("Prize 4: $value4 ");
                      print("Prize 5: $value5 ");
                      //Send to where it needs to be sent
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
