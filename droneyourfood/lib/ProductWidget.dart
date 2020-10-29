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
          return Container();
        }
        return Column(
          children: <Widget>[
            Expanded(
                child: ListView.builder(
              itemCount:
                  productPromise.data == null ? 0 : productPromise.data.length,
              itemBuilder: (context, index) {
                Product product = productPromise.data[index];
                return ProductWidgetText(product);
              },
            ))
          ],
        );
      },
      future: getProducts("resources/products.json"),
    );
  }
}

class ProductWidgetText extends StatelessWidget {
  final Product product;

  ProductWidgetText(Product product) : product = product;

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
            borderRadius: BorderRadius.all(Radius.circular(12.0))),
        padding: new EdgeInsets.all(8.0),
        margin: new EdgeInsets.all(8.0),
        child: new Row(
          children: <Widget>[
            Expanded(
                child: SizedBox(
                    width: 80.0,
                    height: 80.0,
                    child: Image(
                      image: AssetImage('resources/logo.png'),
                      alignment: Alignment.centerLeft,
                    ))),
            Expanded(
                child: Text(
              this.product.name,
              textAlign: TextAlign.right,
              style: TextStyle(color: Color(0xFFCFD3D8), fontSize: 30),
            ))
          ],
        ));
  }
}
