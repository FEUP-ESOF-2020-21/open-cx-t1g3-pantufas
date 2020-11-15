import 'package:droneyourfood/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class SignIn extends StatefulWidget {
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  TextEditingController _emailField = TextEditingController();
  TextEditingController _passwordField = TextEditingController();
  String _error = "";

  void navigateToHomeScreen(BuildContext context) {
    Navigator.pop(context);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MyHomePage(title: "Drone your food"),
      ),
    );
  }

  void navigateToRegisterScreen(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Register()),
    );
  }

  void login() async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _emailField.text, password: _passwordField.text);
      //Only works if the user signs in
      navigateToHomeScreen(context);
    } on FirebaseAuthException catch (e) {
      setState(() {
        this._error = e.message;
      });
    }
  }

  List<Widget> getInputs(BuildContext context, final double fieldWidth) {
    return [
      SizedBox(
        width: fieldWidth,
        child: TextFormField(
          style: TextStyle(color: Colors.white),
          controller: _emailField,
          decoration: InputDecoration(
            hintText: "Email",
            hintStyle: TextStyle(
              color: Colors.grey,
            ),
          ),
        ),
      ),
      SizedBox(
        width: fieldWidth,
        child: TextFormField(
          style: TextStyle(color: Colors.white),
          controller: _passwordField,
          obscureText: true,
          decoration: InputDecoration(
            hintText: "password",
            hintStyle: TextStyle(
              color: Colors.grey,
            ),
          ),
        ),
      ),
    ];
  }

  List<Widget> getButtons(BuildContext context, final double fieldWidth) {
    final double fontSize = 16;

    return [
      /* LOGIN BUTTON */
      ElevatedButton(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all<Color>(Colors.blue),
          minimumSize:
              MaterialStateProperty.all<Size>(Size(fieldWidth, fontSize * 2)),
        ),
        child: Text("Log in", style: TextStyle(fontSize: fontSize)),
        onPressed: login,
      ),
      /* REGISTER BUTTON */
      ElevatedButton(
        style: ButtonStyle(
          minimumSize:
              MaterialStateProperty.all<Size>(Size(fieldWidth, fontSize * 2)),
        ),
        child: Text("Sign Up", style: TextStyle(fontSize: fontSize)),
        onPressed: () {
          navigateToRegisterScreen(context);
        },
      ),
      /* ERROR DISPLAYING AFTER FAILED SIGNIN */
      Container(
        child: Text(this._error,
            textAlign: TextAlign.center, style: TextStyle(color: Colors.red)),
      )
    ];
  }

  @override
  Widget build(BuildContext context) {
    final double fieldWidth = MediaQuery.of(context).size.width * 0.8;

    return Scaffold(
        appBar: AppBar(
          // Here we take the value from the MyHomePage object that was created by
          // the App.build method, and use it to set our appbar title.
          title: Text("Drone your food - Log In"),
        ),
        body: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children:
              getInputs(context, fieldWidth) + getButtons(context, fieldWidth),
        )));
  }
}

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  TextEditingController _userNameField = TextEditingController();
  TextEditingController _emailField = TextEditingController();
  TextEditingController _passwordField = TextEditingController();
  String _error = "";

  void navigateToHomeScreen(context) {
    Navigator.pop(context);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MyHomePage(title: "Drone your food"),
      ),
    );
  }

  void register() async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _emailField.text, password: _passwordField.text);
      //Only works if the user signs in
      navigateToHomeScreen(context);
    } on FirebaseAuthException catch (e) {
      setState(() {
        this._error = e.message;
      });
    }
  }

  List<Widget> getInputs(BuildContext context, final double fieldWidth) {
    return [
      SizedBox(
        width: fieldWidth,
        child: TextFormField(
          style: TextStyle(color: Colors.white),
          controller: _emailField,
          decoration: InputDecoration(
            hintText: "Email",
            hintStyle: TextStyle(
              color: Colors.grey,
            ),
          ),
        ),
      ),
      SizedBox(
        width: fieldWidth,
        child: TextFormField(
          style: TextStyle(color: Colors.white),
          controller: _passwordField,
          obscureText: true,
          decoration: InputDecoration(
            hintText: "password",
            hintStyle: TextStyle(
              color: Colors.grey,
            ),
          ),
        ),
      ),
    ];
  }

  List<Widget> getButtons(BuildContext context, final double fieldWidth) {
    final double fontSize = 16;

    /*
     * !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
     * ! FOI A ANA QUE ESCOLHEU O ROSA !
     * ! XAU                           !
     * !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
     */

    return [
      /* REGISTER BUTTON */
      ElevatedButton(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all<Color>(Colors.pink),
          minimumSize:
              MaterialStateProperty.all<Size>(Size(fieldWidth, fontSize * 2)),
        ),
        child: Text("Sign Up", style: TextStyle(fontSize: fontSize)),
        onPressed: register,
      ),
      /* ERROR DISPLAYING AFTER FAILED SIGNIN */
      Container(
        child: Text(this._error,
            textAlign: TextAlign.center, style: TextStyle(color: Colors.red)),
      )
    ];
  }

  @override
  Widget build(BuildContext context) {
    final double fieldWidth = MediaQuery.of(context).size.width * 0.8;

    return Scaffold(
        appBar: AppBar(
          // Here we take the value from the MyHomePage object that was created by
          // the App.build method, and use it to set our appbar title.
          title: Text(
            "Drone your food - Sign Up",
          ),
        ),
        body: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children:
              getInputs(context, fieldWidth) + getButtons(context, fieldWidth),
        )));
  }
}
