import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'Product.dart';

import 'package:droneyourfood/Shopping/Shopping.dart';

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

class ProductWidget extends StatefulWidget {
  final Product product;

  ProductWidget(this.product);

  @override
  _ProductWidgetState createState() => _ProductWidgetState();
}

class _ProductWidgetState extends State<ProductWidget> {
  bool isClicked = false;
  bool isLongClicked = false;
  int howMany2Add = 1;
  bool isAlive = true;

  void addItem() {
    setState(() {
      ShoppingCart.instance.addItem(widget.product, 1);
      this.isClicked = true;
    });

    // restore state after 2 seconds
    Future.delayed(const Duration(seconds: 2), () {
      if (isAlive) {
        setState(() {
          this.isClicked = false;
        });
      }
    });
  }

  void addMultipleItem() {
    setState(() {
      this.isLongClicked = true;
      this.howMany2Add = 1;
    });
  }

  Widget buildClickedState(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: Theme.of(context).primaryColor),
      margin: EdgeInsets.all(8.0),
      padding: EdgeInsets.all(8.0),
      height: 76.0, // 60 + 8 + 8
      child: Center(
          child: Text(
        "Added " + widget.product.name,
        style: TextStyle(
            color: Color(0xFFCFD3D8),
            fontSize: 20,
            fontWeight: FontWeight.bold),
      )),
    );
  }

  Widget buildNormalState(BuildContext context) {
    return Container(
        margin: EdgeInsets.all(8.0),
        child: ElevatedButton(
          style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(
                  Theme.of(context).primaryColor),
              padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                  EdgeInsets.all(8.0))),
          child: getContent(),
          onPressed: addItem,
          onLongPress: addMultipleItem,
        ));
  }

  Widget buildLongClickedState(BuildContext context) {
    return Container(
        decoration: BoxDecoration(color: Theme.of(context).primaryColor),
        margin: EdgeInsets.all(8.0),
        padding: EdgeInsets.all(4.0),
        height: 76.0, // 60 + 8 + 8
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              icon: Icon(Icons.remove),
              onPressed: () {
                setState(() {
                  --this.howMany2Add;
                  if (this.howMany2Add <= 0) this.isLongClicked = false;
                });
              },
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  this.howMany2Add.toString(),
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
                SizedBox(height: 2.0),
                Text(
                  "(" + getPrice() + ")",
                  style: TextStyle(color: Color(0xFFCFD3D8), fontSize: 12),
                ),
              ],
            ),
            IconButton(
              icon: Icon(Icons.add),
              onPressed: () {
                setState(() {
                  ++this.howMany2Add;
                });
              },
            ),
            ElevatedButton(
              style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Colors.green)),
              child: Text("Add"),
              onPressed: () {
                setState(() {
                  ShoppingCart.instance
                      .addItem(widget.product, this.howMany2Add);
                  this.isLongClicked = false;
                });
              },
            ),
            ElevatedButton(
              style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Colors.red)),
              child: Text("Go back"),
              onPressed: () {
                setState(() {
                  this.isLongClicked = false;
                });
              },
            ),
          ],
        ));
  }

  @override
  Widget build(BuildContext context) {
    if (this.isClicked)
      return buildClickedState(context);
    else if (this.isLongClicked)
      return buildLongClickedState(context);
    else
      return buildNormalState(context);
  }

  Widget getContent() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SizedBox(
            width: 60.0,
            height: 60.0,
            child: Image(
              image: AssetImage('resources/logo.png'),
            )),
        Expanded(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
          Text(
            widget.product.name,
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
          SizedBox(height: 2.0),
          Text(
            getPrice(),
            style: TextStyle(color: Color(0xFFCFD3D8), fontSize: 14),
          )
        ]))
      ],
    );
  }

  String getPrice() {
    return (widget.product.getPrice(this.howMany2Add) / 100.0).toString() + "€";
  }

  @override
  void dispose() {
    this.isAlive = false;
    super.dispose();
  }
}
