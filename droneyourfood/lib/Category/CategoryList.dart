import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:droneyourfood/Products/ListProduct.dart';

class CategoryListWidget extends StatelessWidget {
  // Future<String> loadFile(String fileName) async {
  //   return await rootBundle.loadString(fileName);
  // }
  //
  // Future<List<String>> getCategories(String fileName) async {
  //   List<String> list = new List();
  //   String fileContent = await loadFile(fileName);
  //   final Map<String, dynamic> json = jsonDecode(fileContent);
  //
  //   if (json != null) {
  //     dynamic productJson = json['categories'];
  //     productJson.forEach((element) {
  //       list.add(element);
  //     });
  //   }
  //   return list;
  // }

  Future<List<String>> getCategoriesFromFirebase() async {
    QuerySnapshot qShot =
        await FirebaseFirestore.instance.collection('categories').get();

    return qShot.docs.map((doc) => doc["name"].toString()).toList();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: getCategoriesFromFirebase(),
        builder: (context, categoryPromise) {
          if (categoryPromise.connectionState == ConnectionState.done) {
            return Column(
              children: <Widget>[
                Expanded(
                    child: ListView.builder(
                  itemCount: categoryPromise.data.length,
                  itemBuilder: (context, index) {
                    String c = categoryPromise.data[index];
                    return CategoryListItem(c);
                  },
                ))
              ],
            );
          } else if (categoryPromise.connectionState ==
              ConnectionState.waiting) {
            return Text("Loading...");
          } else {
            return Text("Died...");
          }
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
