import 'package:flutter/material.dart';
import 'CategoryList.dart';

import 'package:droneyourfood/Shopping/Shopping.dart';

class CategoryListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final textColor = Color(0xFFCFD3D8);

    return Scaffold(
        appBar: AppBar(
          title: Row(
            children: [
              Expanded(
                child: Text("Category List"),
              ),
              Expanded(
                  child: Align(
                      alignment: Alignment.centerRight,
                      child: ShoppingCart.instance.getButton(context)))
            ],
          ),
        ),
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
