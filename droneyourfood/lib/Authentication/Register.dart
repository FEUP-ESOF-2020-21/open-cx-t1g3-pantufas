import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:droneyourfood/Authentication/Authentication.dart';
import 'package:droneyourfood/Components/ScrollColumn.dart';

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
              email: emailField.text, password: passwordField.text);
      await userCredential.user.updateProfile(displayName: _userNameField.text);

      setState(() {
        this.error = "Verification email sent";
      });
      await userCredential.user.sendEmailVerification();
    } on FirebaseAuthException catch (e) {
      setState(() {
        if (e.code == 'weak-password')
          this.error = "The password provided is too weak.";
        else if (e.code == 'email-already-in-use')
          this.error = "An account already exists for that email.";
        else
          this.error = e.message;
      });
    }
  }

  @override
  List<Widget> genInputs(BuildContext context, final double fieldWidth) {
    return <Widget>[
          SizedBox(
            width: fieldWidth,
            child: genInputField(context, _userNameField, "Username", false,
                Key("usernameInput")),
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
      appBar: AppBar(title: Text("Drone your food - Sign Up")),
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
