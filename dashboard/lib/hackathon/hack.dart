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
  bool valueEchoAR = false;
  bool valueGoogle = false; 
  bool valueMicrosoft = false; 
  bool valueFacebook = false;
  bool value5 = false; 
  bool value6 = false; 
  bool value7 = false; 
  bool value8 = false; 
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
                  title: const Text('Microsoft Prize'),  
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
                  title: const Text('Prize 5'),  
                  value: this.value5,  
                  onChanged: (bool value) {  
                    setState(() {  
                      this.value5 = value;  
                    });  
                  },  
                ), 

                CheckboxListTile(
                  controlAffinity: ListTileControlAffinity.leading,
                  title: const Text('Prize 6'),  
                  value: this.value6,  
                  onChanged: (bool value) {  
                    setState(() {  
                      this.value6 = value;  
                    });  
                  },  
                ), 

                CheckboxListTile(
                  controlAffinity: ListTileControlAffinity.leading,
                  title: const Text('Prize 7'),  
                  value: this.value7,  
                  onChanged: (bool value) {  
                    setState(() {  
                      this.value7 = value;  
                    });  
                  },  
                ), 

                CheckboxListTile(
                  controlAffinity: ListTileControlAffinity.leading,
                  title: const Text('Prize 8'),  
                  value: this.value8,  
                  onChanged: (bool value) {  
                    setState(() {  
                      this.value8 = value;  
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
                  _buildURL(),
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
                      print(_url);
                      print("EchoAR: $valueEchoAR ");
                      print("Google: $valueGoogle ");
                      print("Microsoft: $valueMicrosoft ");
                      print("Facebook: $valueFacebook ");
                      print("Prize 5: $value5 ");
                      print("Prize 6: $value6 ");
                      print("Prize 7: $value7 ");
                      print("Prize 8: $value8 ");
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
