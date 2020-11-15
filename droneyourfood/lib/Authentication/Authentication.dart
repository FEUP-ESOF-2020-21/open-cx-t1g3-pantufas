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
  String error = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: MediaQuery.of(context).size.width / 1.3,
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
        Container(
          width: MediaQuery.of(context).size.width / 1.3,
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
        Container(
            width: MediaQuery.of(context).size.width / 1.2,
            height: 45,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15.0),
              color: Colors.black,
            ),
            child: MaterialButton(
                onPressed: () async {
                  try {
                    await FirebaseAuth.instance.signInWithEmailAndPassword(
                        email: _emailField.text, password: _passwordField.text);
                    //Only works if the user signs in
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            MyHomePage(title: "Drone your food"),
                      ),
                    );
                  } on FirebaseAuthException catch (e) {
                    if (e.code == 'user-not-found') {
                      setState(() {
                        error = "User not found";
                      });
                      debugPrint('No user found for that email.');
                    } else if (e.code == 'wrong-password') {
                      setState(() {
                        error = "Wrong password";
                      });
                      debugPrint('Wrong password provided for that user.');
                    } else {
                      setState(() {
                        error = "Unknown error";
                      });
                      debugPrint(e.code);
                    }
                  }
                },
                child: Text("Login"))),
        Container(
          child: RichText(
              text: TextSpan(
                  text: 'Register',
                  style: TextStyle(color: Colors.blue),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Register(),
                        ),
                      );
                    })),
        ),
        Container(
          child: Text(error, style: TextStyle(color: Colors.red)),
        )
      ],
    )));
  }
}

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  TextEditingController _emailField = TextEditingController();
  TextEditingController _passwordField = TextEditingController();
  String error = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: MediaQuery.of(context).size.width / 1.3,
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
        Container(
          width: MediaQuery.of(context).size.width / 1.3,
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
        Container(
            width: MediaQuery.of(context).size.width / 1.2,
            height: 45,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15.0),
              color: Colors.black,
            ),
            child: MaterialButton(
                onPressed: () async {
                  try {
                    await FirebaseAuth.instance.createUserWithEmailAndPassword(
                        email: _emailField.text, password: _passwordField.text);
                    //Only works if the user signs in
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            MyHomePage(title: "Drone your food"),
                      ),
                    );
                  } on FirebaseAuthException catch (e) {
                    if (e.code == 'weak-password') {
                      setState(() {
                        error = 'The password provided is too weak.';
                      });
                      debugPrint('The password provided is too weak.');
                    } else if (e.code == 'email-already-in-use') {
                      setState(() {
                        error = 'The account already exists for that email.';
                      });
                      debugPrint('The account already exists for that email.');
                    } else {
                      setState(() {
                        error = "Unknown error";
                      });
                      debugPrint(e.code);
                    }
                  }
                },
                child: Text("Register"))),
        Container(
          child: Text(error, style: TextStyle(color: Colors.red)),
        )
      ],
    )));
  }
}
