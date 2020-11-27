import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:droneyourfood/Authentication/Authentication.dart';
import 'package:droneyourfood/Components/ScrollColumn.dart';

class ResetPassword extends StatefulWidget {
  @override
  _ResetPasswordState createState() => _ResetPasswordState();
}

class _ResetPasswordState extends AuthState<ResetPassword> {
  TextEditingController emailField = TextEditingController();

  void resetPassword() async {
    //Error reset
    this.error = "";
    try {
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: emailField.text);
      setState(() {
        this.error = "Email sent";
      });
    } on FirebaseAuthException catch (e) {
      setState(() {
        if (e.code == "user-not-found") {
          this.error = "Email sent";
        } else {
          this.error = e.message;
        }
      });
    }
  }

  @override
  List<Widget> genInputs(BuildContext context, final double fieldWidth) {
    return <Widget>[
      SizedBox(
        width: fieldWidth,
        child: genInputField(context, emailField, "Email", false),
      )
    ];
  }

  List<Widget> genButtons(BuildContext context, final double fieldWidth) {
    final double fontSize = 16;

    return [
      /* REGISTER BUTTON */
      ElevatedButton(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all<Color>(Colors.orange),
          minimumSize:
              MaterialStateProperty.all<Size>(Size(fieldWidth, fontSize * 2)),
        ),
        child: Text("Send password reset email",
            style: TextStyle(fontSize: fontSize)),
        onPressed: resetPassword,
      ),
      genError(context)
    ];
  }

  @override
  Widget build(BuildContext context) {
    final double fieldWidth = MediaQuery.of(context).size.width * 0.8;

    return Scaffold(
        appBar: AppBar(title: Text("Drone your food - Reset Password")),
        body: Center(
            child: ScrollColumn(
          mainAxisAlignment: MainAxisAlignment.center,
          children:
              genInputs(context, fieldWidth) + genButtons(context, fieldWidth),
        )));
  }
}
