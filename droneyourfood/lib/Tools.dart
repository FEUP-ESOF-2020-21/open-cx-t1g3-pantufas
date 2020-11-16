import 'package:flutter/material.dart';

import 'package:droneyourfood/Authentication/Profile.dart';
import 'package:droneyourfood/Shopping/Shopping.dart';

class Tools {
  static void navigatorPopAll(BuildContext context) {
    Navigator.popUntil(context, (Route<dynamic> route) => route.isFirst);
    Navigator.pop(context);
  }

  static void navigatorPopAllPush(BuildContext context, Route route) {
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
}
