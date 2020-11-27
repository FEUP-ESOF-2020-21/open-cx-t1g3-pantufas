import 'package:flutter/material.dart';

import 'package:droneyourfood/Profile/Profile.dart';
import 'package:droneyourfood/Shopping/Shopping.dart';

class MyAppBar {
  final BuildContext context;
  final String title;

  MyAppBar(this.context, this.title);

  AppBar get appBar {
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

  static double getAppBarHeight(BuildContext context) {
    return MediaQuery.of(context).size.height -
        MediaQuery.of(context).padding.top -
        kToolbarHeight;
  }
}
