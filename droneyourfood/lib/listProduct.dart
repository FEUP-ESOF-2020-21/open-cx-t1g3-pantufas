import 'package:flutter/material.dart';
import 'ProductWidget.dart';

class ProductListScreen extends StatelessWidget {
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
                  "Food list category",
                  textAlign: TextAlign.left,
                  style:
                      TextStyle(fontWeight: FontWeight.bold, color: textColor),
                )),
            Expanded(child: ProductListWidget())
          ],
        ));
  }
}
// ProductListWidget()
