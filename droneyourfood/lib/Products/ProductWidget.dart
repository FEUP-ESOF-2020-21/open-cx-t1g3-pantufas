import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'Product.dart';

class ProductListWidget extends StatelessWidget {
  final String category;

  ProductListWidget(String category) : this.category = category;

  // Future<String> loadFile(String fileName) async {
  //   return await rootBundle.loadString(fileName);
  // }
  //
  // Future<List<Product>> getProducts(String fileName) async {
  //   List<Product> list = new List();
  //   String fileContent = await loadFile(fileName);
  //   final Map<String, dynamic> json = jsonDecode(fileContent);
  //
  //   if (json != null) {
  //     dynamic productJson = json['products'];
  //
  //     if (this.category == "All") {
  //       productJson.forEach((element) {
  //         list.add(Product.fromJson(element));
  //       });
  //     } else {
  //       productJson.forEach((element) {
  //         Product aux = Product.fromJson(element);
  //         if (aux.categories.contains(this.category)) {
  //           list.add(aux);
  //         }
  //       });
  //     }
  //   }
  //
  //   return list;
  // }

  Future<List<Product>> getProductsFromFirebase() async {
    QuerySnapshot qShot;

    if (this.category == "All") {
      qShot = await FirebaseFirestore.instance.collection('products').get();
    } else {
      qShot = await FirebaseFirestore.instance
          .collection('products')
          .where("category", isEqualTo: this.category)
          .get();
    }
    return qShot.docs
        .map((doc) => Product(doc["name"], doc["image"], doc["category"]))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getProductsFromFirebase(),
      builder: (context, productPromise) {
        if (productPromise.connectionState == ConnectionState.done) {
          return Column(
            children: <Widget>[
              Expanded(
                  child: ListView.builder(
                itemCount: productPromise.data.length,
                itemBuilder: (context, index) {
                  Product product = productPromise.data[index];
                  return ProductWidgetText(product);
                },
              ))
            ],
          );
        } else {
          return Text("Loading...");
        }
      },
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
