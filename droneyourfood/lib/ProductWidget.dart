import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'Product.dart';
import 'dart:convert';

class ProductsWidget extends StatefulWidget {
    @override
    _ProductsWidgetState createState() => _ProductsWidgetState();
}

class _ProductsWidgetState extends State<ProductsWidget> {
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
        List<Widget> widgets = new List();

        getProducts("resources/products.json").then((products) {
            for(Product product in products) {
                widgets.add(new ProductWidgetText());
            }
        });

        return Column(
            children: widgets
        );
    }
}

class ProductWidgetText extends StatelessWidget {
    @override
    Widget build(BuildContext context) {
        return Container(
        margin: new EdgeInsets.all(8.0),
        child:ListBody(
        children: <Widget>[
          Row(
            children: <Widget>[
              Container(
                width: 200,
                padding: EdgeInsets.fromLTRB(5, 5, 5, 0),
                  child: new Text('nada'),
                ),
            ],
          )
        ],
      ),
    );
    }

}
