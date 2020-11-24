import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:droneyourfood/Products/Product.dart';
import 'package:droneyourfood/Products/ProductWidget.dart';

class ProductListWidget extends StatelessWidget {
  final DocumentReference category; // null => list all

  ProductListWidget(this.category);

  Future<List<Product>> getProductsFromFirebase() async {
    Future<QuerySnapshot> qShot;

    if (this.category == null) {
      qShot = FirebaseFirestore.instance.collection('products').get();
    } else {
      qShot = FirebaseFirestore.instance
          .collection('products')
          .where("category", isEqualTo: this.category)
          .get();
    }

    return qShot.then((QuerySnapshot qShot) {
      return qShot.docs
          .map((doc) => Product(doc["name"], doc["image"], doc["category"],
              doc["price"], doc["ref"]))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getProductsFromFirebase(),
      builder: (context, productPromise) {
        if (productPromise.connectionState == ConnectionState.done) {
          return Column(
            children: [
              Expanded(
                  child: ListView.builder(
                itemCount: productPromise.data.length,
                itemBuilder: (context, index) {
                  Product product = productPromise.data[index];
                  return ProductWidget(product);
                },
              ))
            ],
          );
        } else if (productPromise.connectionState == ConnectionState.waiting) {
          return Text(
            "Loading...",
            textAlign: TextAlign.center,
          );
        } else {
          return Text(
            "Died...",
            textAlign: TextAlign.center,
          );
        }
      },
    );
  }
}
