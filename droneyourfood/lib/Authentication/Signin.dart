import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:droneyourfood/Authentication/Authentication.dart';
import 'package:droneyourfood/Authentication/Register.dart';
import 'package:droneyourfood/Authentication/PassReset.dart';
import 'package:droneyourfood/Components/ScrollColumn.dart';

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

  void navigateToPasswordResetScreen(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ResetPassword()),
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
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(
              email: emailField.text, password: passwordField.text);

      if (!userCredential.user.emailVerified) {
        setState(() {
          this.error = "Email not verified. Verification email sent";
        });
        await userCredential.user.sendEmailVerification();
      } else {
        // Only works if the user is verified
        navigateToHomeScreen(context);
      }
    } on FirebaseAuthException catch (e) {
      setState(() {
        if (e.code == 'user-not-found')
          this.error = "No user found for that email.";
        else if (e.code == 'wrong-password')
          this.error = "Wrong password provided for that user.";
        else
          this.error = e.message;
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
      RichText(
        text: TextSpan(
          style: TextStyle(color: Colors.grey),
          text: "Forgot your password?",
          recognizer: TapGestureRecognizer()
            ..onTap = () {
              navigateToPasswordResetScreen(context);
            },
        ),
      ),
      genError(context)
    ];
  }

  @override
  Widget build(BuildContext context) {
    final double fieldWidth = MediaQuery.of(context).size.width * 0.8;

    return Scaffold(
      appBar: AppBar(title: Text("Drone your food - Log In")),
      body: Center(
        child: ScrollColumn(
          mainAxisAlignment: MainAxisAlignment.center,
          children:
              genInputs(context, fieldWidth) + genButtons(context, fieldWidth),
        ),
      ),
    );
  }
}
