import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:droneyourfood/Products/Product.dart';
import 'package:flutter/material.dart';

class ShoppingCart {
  static final ShoppingCart _instance = ShoppingCart._internal();
  Map<Product, int> items;

  factory ShoppingCart() {
    // TODO get shit from firebase
    return _instance;
  }

  ShoppingCart._internal() {
    this.items = new Map(); // :(
  }

  Widget getButton(BuildContext context) {
    return IconButton(
      icon: Image(
        image: AssetImage('resources/shopping_cart.png'),
      ),
      onPressed: () {
        Navigator.of(context)
            .push(MaterialPageRoute<Null>(builder: (BuildContext context) {
          return new ShoppingScreen(this);
        }));
      },
    );
  }

  addItem(Product prod, int quant) {
    items[prod] = quant;
  }

  rmItem(Product prod) {
    items.remove(prod);
  }
}

class ShoppingScreen extends StatelessWidget {
  final ShoppingCart shoppingCart;

  ShoppingScreen(this.shoppingCart);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'Shopping List',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ),
        body: Column(
          children: [Expanded(child: ShoppingListWidget(this.shoppingCart))],
        ));
  }
}

class ShoppingItem extends StatelessWidget {
  final Product prod;
  final int quant;

  ShoppingItem(this.prod, this.quant);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [Text(prod.name), Text(quant.toString())],
    );
  }
}

class ShoppingListWidget extends StatelessWidget {
  final ShoppingCart shoppingCart;

  ShoppingListWidget(this.shoppingCart);

  List<ShoppingItem> getShoppingItems() {
    List<ShoppingItem> shopItems = new List();
    this.shoppingCart.items.forEach((prod, quant) {
      shopItems.add(new ShoppingItem(prod, quant));
    });
    return shopItems;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: this.getShoppingItems(),
    );
  }
}
