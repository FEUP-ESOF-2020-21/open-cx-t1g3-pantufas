import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';

import 'package:droneyourfood/Products/ListProduct.dart';

class CategoryListWidget extends StatelessWidget {
  Future<String> loadFile(String fileName) async {
    return await rootBundle.loadString(fileName);
  }

  Future<List<String>> getCategories(String fileName) async {
    List<String> list = new List();
    String fileContent = await loadFile(fileName);
    final Map<String, dynamic> json = jsonDecode(fileContent);

    if (json != null) {
      dynamic productJson = json['categories'];
      productJson.forEach((element) {
        list.add(element);
      });
    }
    return list;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: getCategories("resources/products.json"),
        builder: (context, categoryPromise) {
          if (categoryPromise.connectionState == ConnectionState.none &&
              categoryPromise.hasData == null) {
            return Container();
          }
          return Column(
            children: <Widget>[
              Expanded(
                  child: ListView.builder(
                itemCount: categoryPromise.data == null
                    ? 0
                    : categoryPromise.data.length,
                itemBuilder: (context, index) {
                  String c = categoryPromise.data[index];
                  return CategoryListItem(c);
                },
              ))
            ],
          );
        });
  }
}

class CategoryListItem extends StatelessWidget {
  final String category;

  CategoryListItem(String category) : this.category = category;

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () {
          Navigator.of(context)
              .push(MaterialPageRoute<Null>(builder: (BuildContext context) {
            return new ProductListScreen(this.category);
          }));
        },
        child: Container(
            decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: BorderRadius.all(Radius.circular(12.0))),
            padding: new EdgeInsets.all(8.0),
            margin: new EdgeInsets.all(8.0),
            child: new Row(
              children: <Widget>[
                Expanded(
                    child: Text(
                  this.category,
                  textAlign: TextAlign.right,
                  style: TextStyle(color: Color(0xFFCFD3D8), fontSize: 30),
                ))
              ],
            )));
  }
}
