import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'Product.dart';
import 'dart:convert';

class ProductListScreen extends StatelessWidget {
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

    Future<String> loadFile(String fileName) async {
        return await rootBundle.loadString(fileName);
    }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('First Screen'),
      ),
      body: Center(child: Column(children : <Widget>[
            RaisedButton(
              color: Colors.red,
              child: Text('Go Back'),
              onPressed: () {
                //Use`Navigator` widget to pop oir go back to previous route / screen
                Navigator.pop(context);
              }
            ),
            FlatButton(
                child: Text('Bebeu', style: TextStyle(fontSize: 20.0),),
                color: Colors.blueAccent,
                textColor: Colors.white,
                onPressed: () {
                    getProducts("resources/products.json").then((products) {
                        for(Product product in products) {
                            print(product);
                        }
                    });
                }
            ),

        ]))
    );
  }
}
