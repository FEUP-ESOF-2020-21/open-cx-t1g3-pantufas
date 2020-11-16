import 'package:flutter/material.dart';
import 'CategoryList.dart';

import 'package:droneyourfood/Tools.dart';

class CategoryListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final textColor = Color(0xFFCFD3D8);

    return Scaffold(
        appBar: Tools.genAppBar(context, "Category List"),
        body: Column(
          children: [
            Container(
                alignment: Alignment.centerLeft,
                padding: new EdgeInsets.all(10.0),
                child: Text(
                  "Category List",
                  textAlign: TextAlign.left,
                  style: TextStyle(
                      height: 2,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: textColor),
                )),
            Expanded(child: CategoryListWidget())
          ],
        ));
  }
}
// ProductListWidget()
