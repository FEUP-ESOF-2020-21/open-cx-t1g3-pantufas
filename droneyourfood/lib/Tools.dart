import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:droneyourfood/Authentication/Profile.dart';
import 'package:droneyourfood/Shopping/Shopping.dart';

class Tools {
  static void navigatorPopAll(BuildContext context) {
    Navigator.popUntil(context, (Route<dynamic> route) => route.isFirst);
    Navigator.pop(context);
  }

  static void navigatorPushAsRoot(BuildContext context, Route route) {
    navigatorPopAll(context);
    Navigator.push(context, route);
  }

  static AppBar genAppBar(BuildContext context, String title) {
    return AppBar(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              ShoppingCart().getButton(context),
              ProfileButton(),
            ],
          )
        ],
      ),
    );
  }

  static void signout(BuildContext context) async {
    debugPrint("Sign-out");
    ShoppingCart.instance.updateFirebaseCart();

    await FirebaseAuth.instance.signOut();
    ShoppingCart.instance.clearCart(); // reload
  }
}
