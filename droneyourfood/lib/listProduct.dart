import 'package:flutter/material.dart';
import 'ProductWidget.dart';

class ProductListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Food List'),
      ),
      body: ProductListWidget()
    );
  }
}
