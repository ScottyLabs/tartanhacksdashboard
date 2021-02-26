import 'package:flutter/material.dart';
import 'main.dart';
import 'package:http/http.dart' as http;
import 'loginmodel.dart';
import 'api.dart';
import 'dart:async';

class LogIn extends StatelessWidget {
  final emailController = new TextEditingController();
  final passwordController = new TextEditingController();
  //@override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    emailController.dispose();
    passwordController.dispose();
    //super.dispose();
  }

  void login(String email, String password) async {
    Login logindata = await checkCredentials(email, password);
    // print(logindata.user.name);
  }

  @override
  /*Widget build(BuildContext context) {
    return MaterialApp(
      home: Center(
      child: RaisedButton(
        onPressed: (){},
        child: Text("Tap here to just access the app. Dev only."),
      ),
    ));
  }*/
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    emailTextValue() {
      print("title text field: ${emailController.text}");
      return emailController.text;
    }

    passwordTextValue() {
      print("title text field: ${passwordController.text}");
      return passwordController.text;
    }

    return Scaffold(
      body: Container(
        // decoration: new BoxDecoration(color: Colors.black), - black background
        padding: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.width * 0.05),
        height: height,
        width: width,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: width,
                height: height * 0.45,
                child:
                    /*Image.asset(
                  'assets/center_logo.png',
                  fit: BoxFit.fill,
                ),*/
                    Image(image: AssetImage('center_logo.png')),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      'Login',
                      style: TextStyle(
                          fontSize: 25.0, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 30.0,
              ),
              TextField(
                controller: emailController,
                decoration: InputDecoration(
                  hintText: 'Email',
                  suffixIcon: Icon(Icons.email),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                ),
              ),
              SizedBox(
                height: 20.0,
              ),
              TextField(
                controller: passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  hintText: 'Password',
                  /*suffixIcon: Icon(Icons.lock),*/
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                ),
              ),
              //email.set("emailValue", emailTextValue),
              //password.set("passwordValue", passwordTextValue), //THIS ISN'T WORKING!
              SizedBox(
                height: 30.0,
              ),
              ButtonTheme(
                height: 45.0,
                minWidth: 380.0,
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    /*Text(
                      'Forget password?',
                      style: TextStyle(fontSize: 12.0),
                    ),*/
                    RaisedButton(
                      child: Text('Login',
                          style: TextStyle(color: Color(0xffffffff))),
                      color: Color.fromARGB(255, 37, 130, 242),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16.0),
                          side: BorderSide(
                              color: Color.fromARGB(255, 37, 130, 242))),
                      onPressed: () {
                        //print("email: ${emailController.text}");
                        //print("password: ${passwordController.text}");
                        login(emailController.text, passwordController.text);
                        /*Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => TemporaryOutputs()),
                        );*/
                      },
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20.0),
              GestureDetector(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => Second()));
                },
                child: Text.rich(
                  TextSpan(children: [
                    TextSpan(
                      text: 'Forget Password',
                      style:
                          TextStyle(color: Color.fromARGB(255, 37, 130, 242)),
                    ),
                  ]),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Second extends StatefulWidget {
  @override
  _SecondState createState() => _SecondState();
}

class _SecondState extends State<Second> {
  final emailController = new TextEditingController();
  final passwordController = new TextEditingController();
  //@override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    emailController.dispose();
    passwordController.dispose();
    //super.dispose();
  }

  void reset(String email) async {
    Login resetdata = await resetPassword(email);
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Container(
        // decoration: new BoxDecoration(color: Colors.black), - black background
        padding: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.width * 0.05),
        height: height,
        width: width,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                  width: width,
                  height: height * 0.45,
                  child:
                      /*Image.asset(
                  'assets/center_logo.png',
                  fit: BoxFit.fill,
                ),*/ // if you want to do it this way, remember to move the png back into the assets folder
                      Image(image: AssetImage('center_logo.png')) //not working
                  ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      'Password Reset',
                      style: TextStyle(
                          fontSize: 25.0, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 30.0,
              ),
              TextField(
                controller: emailController,
                decoration: InputDecoration(
                  hintText: 'Email',
                  suffixIcon: Icon(Icons.email),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                ),
              ),
              /*SizedBox(
                height: 20.0,
              ),
              TextField(
                controller: passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  hintText: 'Password',
                  suffixIcon: Icon(Icons.visibility_off),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                ),
              ),*/
              SizedBox(
                height: 30.0,
              ),
              ButtonTheme(
                height: 45.0,
                minWidth: 380.0,
                padding: const EdgeInsets.all(14.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    /*Text(
                      'Forget password?',
                      style: TextStyle(fontSize: 12.0),
                    ),*/
                    RaisedButton(
                      child: Text('Recover',
                          style: TextStyle(
                              fontSize: 15.0, color: Color(0xffffffff))),
                      color: Color.fromARGB(255, 37, 130, 242),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16.0),
                          side: BorderSide(
                              color: Color.fromARGB(255, 37, 130, 242))),
                      onPressed: () {
                        //print("title text field: ${emailController.text}");
                        reset(emailController.text);
                        /*print("title text field: ${passwordController.text}");*/
                        /*Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => TemporaryOutputs()),
                        );*/
                      },
                    ),
                  ],
                ),
              ),
              SizedBox(height: 40.0),
              GestureDetector(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => LogIn()));
                },
                child: Text.rich(
                  TextSpan(text: 'Already have an account\t', children: [
                    TextSpan(
                      text: 'Login',
                      style:
                          TextStyle(color: Color.fromARGB(255, 37, 130, 242)),
                    ),
                  ]),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class TemporaryOutputs extends StatefulWidget {
  @override
  _TemporaryOutputsState createState() => _TemporaryOutputsState();
}

class _TemporaryOutputsState extends State<TemporaryOutputs> {
  @override
  Widget build(BuildContext context) {
    //double width = MediaQuery.of(context).size.width;
    //double height = MediaQuery.of(context).size.height;
    //var evalue = email.get("emailValue");
    //var pvalue = password.get("passwordValue");
    //print(evalue);
    //print(pvalue);
    return Scaffold();
  }
}

class GlobalState {
  final Map<dynamic, dynamic> _data = <dynamic, dynamic>{};

  static GlobalState instance = GlobalState._();
  GlobalState._();

  set(dynamic key, dynamic value) => _data[key] = value;
  get(dynamic key) => _data[key];
}

final GlobalState email = GlobalState.instance;
final GlobalState password = GlobalState.instance;
