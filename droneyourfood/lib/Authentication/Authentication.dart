import 'package:flutter/material.dart';

import 'package:droneyourfood/main.dart';
import 'package:droneyourfood/Tools.dart';
import 'package:droneyourfood/Shopping/Shopping.dart';

abstract class AuthState<T extends StatefulWidget> extends State<T> {
  TextEditingController emailField = TextEditingController();
  TextEditingController passwordField = TextEditingController();
  String error = "";

  List<Widget> genButtons(BuildContext context, final double fieldWidth);

  void navigateToHomeScreen(context) {
    ShoppingCart.instance.getCartFromFirebase(); // reload cart (if needed)
    Tools.navigatorPushAsRoot(
      context,
      MaterialPageRoute(
        builder: (context) => MyHomePage(title: "Drone your food"),
      ),
    );
  }

  Widget genInputField(BuildContext context, TextEditingController ctrl,
      String txt, bool isObscure, final Key k) {
    return TextFormField(
      key: k, // usefull for gherkin tests
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
        child: genInputField(
            context, emailField, "Email", false, Key("emailInput")),
      ),
      SizedBox(
        width: fieldWidth,
        child: genInputField(
            context, passwordField, "Password", true, Key("passInput")),
      ),
    ];
  }

  Widget genError(BuildContext context) {
    /* ERROR DISPLAYING AFTER FAILURE */
    return Container(
      child: Text(this.error,
          textAlign: TextAlign.center, style: TextStyle(color: Colors.red)),
    );
  }
}
