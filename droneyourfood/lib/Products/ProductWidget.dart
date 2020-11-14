import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:droneyourfood/Shopping/Shopping.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'Product.dart';

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

class ProductWidget extends StatelessWidget {
  final Product product;

  ProductWidget(this.product);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(product.name),
      leading: Image(image: AssetImage('resources/logo.png')),
      onTap: () {
        ShoppingCart.instance.addItem(this.product, 1);
      },
    );

    // return Container(
    // decoration: BoxDecoration(
    // color: Theme.of(context).primaryColor,
    // borderRadius: BorderRadius.all(Radius.circular(12.0))),
    // padding: EdgeInsets.all(8.0),
    // margin: EdgeInsets.all(8.0),
    // child: Row(
    // children: [
    // Expanded(
    // child: SizedBox(
    // width: 80.0,
    // height: 80.0,
    // child: Image(
    // image: AssetImage('resources/logo.png'),
    // alignment: Alignment.centerLeft,
    // ))),
    // Expanded(
    // child: Text(
    // this.product.name,
    // textAlign: TextAlign.right,
    // style: TextStyle(color: Color(0xFFCFD3D8), fontSize: 30),
    // ))
    // ],
    // ));
  }
}
