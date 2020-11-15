import 'package:flutter/material.dart';
import 'ProductWidget.dart';

import 'package:droneyourfood/Shopping/Shopping.dart';
import 'package:droneyourfood/Category/Category.dart';

class ProductListScreen extends StatelessWidget {
  final textColor = Color(0xFFCFD3D8);
  final Category category;

  ProductListScreen(this.category);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Row(
            children: [
              Expanded(
                child: Text('Food List'),
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
            getTitle(),
            Expanded(
                child: ProductListWidget(
                    this.category == null ? null : this.category.ref))
          ],
        ));
  }

  Widget getTitle() {
    return Container(
        alignment: Alignment.centerLeft,
        padding: new EdgeInsets.all(10.0),
        child: Text(
          this.category == null ? "All" : this.category.name,
          textAlign: TextAlign.left,
          style: TextStyle(
              height: 2,
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: textColor),
        ));
  }
}
// ProductListWidget()
