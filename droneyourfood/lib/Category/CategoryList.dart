import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:droneyourfood/Products/ListProduct.dart';
import 'package:droneyourfood/Category/Category.dart';

class CategoryListWidget extends StatelessWidget {
  Future<List<Category>> getCategoriesFromFirebase() async {
    Future<QuerySnapshot> qShot =
        FirebaseFirestore.instance.collection('categories').get();

    return qShot.then((QuerySnapshot qShot) {
      return qShot.docs
          .map((doc) => Category(doc["name"], doc["ref"]))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: getCategoriesFromFirebase(),
        builder: (context, categoryPromise) {
          if (categoryPromise.connectionState == ConnectionState.done) {
            return Column(
              children: [
                Expanded(
                    child: ListView.builder(
                  itemCount: categoryPromise.data.length,
                  itemBuilder: (context, index) {
                    return CategoryListItem(categoryPromise.data[index]);
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
  final Category category;

  CategoryListItem(this.category);

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
                  this.category.name,
                  textAlign: TextAlign.right,
                  style: TextStyle(color: Color(0xFFCFD3D8), fontSize: 30),
                ))
              ],
            )));
  }
}
