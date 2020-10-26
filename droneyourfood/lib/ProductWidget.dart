import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'Product.dart';
import 'dart:convert';

class ProductListWidget extends StatelessWidget {
  Future<String> loadFile(String fileName) async {
    return await rootBundle.loadString(fileName);
  }

  Future<List<Product>> getProducts(String fileName) async {
    List<Product> list = new List();
    String fileContent = await loadFile(fileName);
    final Map<String, dynamic> json = jsonDecode(fileContent);

    if (json != null) {
      dynamic productJson = json['products'];
      productJson.forEach((element) {
        list.add(Product.fromJson(element));
      });
    }
    return list;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      builder: (context, productPromise) {
        if (productPromise.connectionState == ConnectionState.none &&
            productPromise.hasData == null) {
          //print('project snapshot data is: ${projectSnap.data}');
          return Container();
        }
        return Column(
          children: <Widget>[
            Expanded(child:
            ListView.builder(
              itemCount: productPromise.data.length,
              itemBuilder: (context, index) {
                Product product = productPromise.data[index];
                return Text(product.name);
              },
            )
            )
          ],
        );
      },
      future: getProducts("resources/products.json"),
    );
  }
}

class ProductWidgetText extends StatelessWidget {
    @override
    Widget build(BuildContext context) {
        return Container(
            margin: new EdgeInsets.all(8.0),
            child: new Text('nada')
        );
    }
}
