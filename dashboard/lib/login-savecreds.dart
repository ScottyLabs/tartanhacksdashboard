import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'app.dart';
import 'main.dart';


class LogIn extends StatefulWidget {
  @override
  _LogInState createState() => _LogInState();
}

class _LogInState extends State<LogIn> {
  final emailController = new TextEditingController();
  final passwordController = new TextEditingController();

  bool loginView = true;
  String title = 'Login';
  String linkText = 'Signup';
  String linkDesc = "Don't have an account? ";
  String failureMsg = '';

  bool isLoggedIn = false;
  String name = '';
  String id = '';
  bool admin = false;
  String token = '';

  //@override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    emailController.dispose();
    passwordController.dispose();
    //super.dispose();
  }

  void switchView() {
    setState(() {
      if(loginView) {
        title = "Sign up";
        linkText = "Login";
        linkDesc = "Already have an account? ";
        loginView = false;
      }else{
        title = 'Login';
        linkText = 'Sign up';
        linkDesc = "Don't have an account? ";
        loginView = true;
      }
    });
  }

  Future getUserInfo(email, pass) async{
    var response = await http.post(
        Uri.encodeFull("https://thd-api.herokuapp.com/auth/login"),
        body: {
          "email": email,
          "password": pass
        }
    );
    if(response.statusCode == 200) {
      Map data = json.decode(response.body);
      setState(() {
        name = data["participant"]["name"];
        id = data["participant"]["_id"];
        admin = data["participant"]["is_admin"];
        token = data["access_token"];
      });
    }else{
      setState(() {
        failureMsg = "Login failed";
      });
    }
  }

  void autoLogin() async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String checking = prefs.getString('name');

    if(checking != null) {
      setState(() {
        isLoggedIn = true;
        name = checking;
        id = prefs.getString('id');
        admin = prefs.getBool('admin');
        token = prefs.getString('token');
      });
    }
  }

  Future logout(context) async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('name', null);
    prefs.setString('id', null);
    prefs.setBool('admin', false);
    prefs.setString('token', null);

    setState(() {
      isLoggedIn = false;
      name = null;
      id = null;
      admin = false;
      token = null;
    });
    Navigator.push(context, MaterialPageRoute(builder: (context) => LogIn()));
  }

  Future login(context) async{
    await getUserInfo(emailController.text, passwordController.text);

    if(failureMsg == ''){
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('name', name);
      prefs.setString('id', id);
      prefs.setBool('admin', admin);
      prefs.setString('token', token);

      setState(() {
        MyApp.loggedin = true;
      });
      // Navigator.push(context, MaterialPageRoute(builder: (context) =>
      //     DummyPage(logout, name)));
    }
  }

  @override
  void initState() {
    autoLogin();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    if(isLoggedIn) return App(logout, name);
    else return Scaffold(
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
                /*
                child: Image.asset(
                  'assets/tartanhackslogo.png',
                  fit: BoxFit.fill,
                ),
                */ //do not have the asset yet, this is for the signup page
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      title,
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
                autocorrect: false,
                enableSuggestions: false,
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
                  suffixIcon: Icon(Icons.visibility_off),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                ),
              ),
              //email.set("emailValue", emailTextValue),
              //password.set("passwordValue", passwordTextValue), //THIS ISN'T WORKING!
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      failureMsg,
                      style: TextStyle(
                          fontSize: 12.0, fontWeight: FontWeight.bold,
                          color: Color(0xffE21031)
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Forget password?',
                      style: TextStyle(fontSize: 12.0),
                    ),
                    RaisedButton(
                      child: Text(title),
                      color: Color(0xffE21031),
                      onPressed: () {
                        login(context);
                      },
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20.0),
              GestureDetector(
                onTap: () {
                  switchView();
                },
                child: Text.rich(
                  TextSpan(text: linkDesc, children: [
                    TextSpan(
                      text: linkText,
                      style: TextStyle(
                          color: Color(0xffE21031),
                          decoration: TextDecoration.underline
                      ),
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

class DummyPage extends StatelessWidget{

  final Function logout;
  final String name;

  DummyPage(this.logout, this.name);

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
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "Logged in as $name.",
                    style: TextStyle(fontSize: 20)
                  ),
                  SizedBox(height: 20),
                  RaisedButton(
                    child: Text("Log Out",
                        style: TextStyle(fontSize: 30, color: Colors.white)),
                    color: Color(0xffE21031),
                    onPressed: () {
                      logout(context);
                    }
                  )
                ]
            )
        )
    );
  }
}
