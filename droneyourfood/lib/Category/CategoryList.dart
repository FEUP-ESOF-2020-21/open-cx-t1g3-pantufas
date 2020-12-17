import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:droneyourfood/Products/ProductScreen.dart';
import 'package:droneyourfood/Category/Category.dart';

class CategoryListWidget extends StatelessWidget {
  final Future<List<Category>> _categoryPromise;

  CategoryListWidget() : _categoryPromise = getCategoriesFromFirebase();
  CategoryListWidget.fromPromise(categoryPromise)
      : _categoryPromise = categoryPromise;

  static Future<List<Category>> getCategoriesFromFirebase() async {
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
        future: _categoryPromise,
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
    return Container(
        margin: EdgeInsets.all(8.0),
        child: ElevatedButton(
          style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(
                  Theme.of(context).primaryColor),
              padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                  EdgeInsets.all(8.0))),
          child: SizedBox(
              height: 60.0,
              child: Center(
                child: Text(
                  this.category.name,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                ),
              )),
          onPressed: () {
            goToProdPage(context);
          },
        ));
  }

  void goToProdPage(BuildContext context) {
    Navigator.of(context)
        .push(MaterialPageRoute<Null>(builder: (BuildContext context) {
      return new ProductListScreen(this.category);
    }));
  }
}
