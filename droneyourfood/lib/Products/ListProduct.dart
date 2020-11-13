import 'package:flutter/material.dart';
import 'ProductWidget.dart';

class ProductListScreen extends StatelessWidget {
  final String category;

  ProductListScreen(this.category);

  @override
  Widget build(BuildContext context) {
    final textColor = Color(0xFFCFD3D8);
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'Food List',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ),
        body: Column(
          children: [
            Container(
                alignment: Alignment.centerLeft,
                padding: new EdgeInsets.all(10.0),
                child: Text(
                  this.category,
                  textAlign: TextAlign.left,
                  style: TextStyle(
                      height: 2,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: textColor),
                )),
            Expanded(child: ProductListWidget(this.category))
          ],
        ));
  }
}
// ProductListWidget()
