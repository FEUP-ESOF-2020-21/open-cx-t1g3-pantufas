import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'package:droneyourfood/main.dart';

abstract class AuthState<T extends StatefulWidget> extends State<T> {
  TextEditingController _emailField = TextEditingController();
  TextEditingController _passwordField = TextEditingController();
  String _error = "";

  List<Widget> genButtons(BuildContext context, final double fieldWidth);

  void navigateToHomeScreen(context) {
    Navigator.popUntil(context, (Route<dynamic> route) => route.isFirst);
    Navigator.pop(context);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MyHomePage(title: "Drone your food"),
      ),
    );
  }

  Widget genInputField(BuildContext context, TextEditingController ctrl,
      String txt, bool isObscure) {
    return TextFormField(
      style: TextStyle(color: Colors.white),
      controller: ctrl,
      obscureText: isObscure,
      decoration: InputDecoration(
        hintText: txt,
        hintStyle: TextStyle(
          color: Colors.grey,
        ),
      ),
    );
  }

  List<Widget> genInputs(BuildContext context, final double fieldWidth) {
    return [
      SizedBox(
        width: fieldWidth,
        child: genInputField(context, _emailField, "Email", false),
      ),
      SizedBox(
        width: fieldWidth,
        child: genInputField(context, _passwordField, "Password", true),
      ),
    ];
  }

  Widget genError(BuildContext context) {
    /* ERROR DISPLAYING AFTER FAILURE */
    return Container(
      child: Text(this._error,
          textAlign: TextAlign.center, style: TextStyle(color: Colors.red)),
    );
  }
}

class SignIn extends StatefulWidget {
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends AuthState<SignIn> {
  void navigateToRegisterScreen(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Register()),
    );
  }

  void signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;

    // Create a new credential
    final GoogleAuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    // Once signed in, return the UserCredential
    await FirebaseAuth.instance.signInWithCredential(credential);

    // fogao -> >:(
    navigateToHomeScreen(context);
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

  List<Widget> genButtons(BuildContext context, final double fieldWidth) {
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
      ElevatedButton(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(Colors.red),
            minimumSize:
                MaterialStateProperty.all<Size>(Size(fieldWidth, fontSize * 2)),
          ),
          child:
              Text("Sign In with Google", style: TextStyle(fontSize: fontSize)),
          onPressed: signInWithGoogle),
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
      genError(context)
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
              genInputs(context, fieldWidth) + genButtons(context, fieldWidth),
        )));
  }
}

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends AuthState<Register> {
  TextEditingController _userNameField = TextEditingController();

  void register() async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: _emailField.text, password: _passwordField.text);
      await userCredential.user.updateProfile(displayName: _userNameField.text);
      //Only works if the user signs in
      navigateToHomeScreen(context);
    } on FirebaseAuthException catch (e) {
      setState(() {
        this._error = e.message;
      });
    }
  }

  @override
  List<Widget> genInputs(BuildContext context, final double fieldWidth) {
    return <Widget>[
          SizedBox(
            width: fieldWidth,
            child: genInputField(context, _userNameField, "Username", false),
          )
        ] +
        super.genInputs(context, fieldWidth);
  }

  List<Widget> genButtons(BuildContext context, final double fieldWidth) {
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
      genError(context)
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
              genInputs(context, fieldWidth) + genButtons(context, fieldWidth),
        )));
  }
}
