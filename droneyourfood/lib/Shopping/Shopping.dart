import 'dart:async';
import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:droneyourfood/Products/Product.dart';
import 'package:droneyourfood/Shopping/ShoppingScreen.dart';
import 'package:droneyourfood/Tools.dart';

// ! fu tiago >:)

class ShoppingCart {
  static final ShoppingCart instance = ShoppingCart._internal();

  HashMap<Product, Map<String, dynamic>> _items;
  Future<DocumentSnapshot> _dShot;
  bool _failed = false, _updated = false;

  factory ShoppingCart() {
    return instance;
  }

  ShoppingCart._internal() {
    clearCart();
    getCartFromFirebase();
  }

  void clearCart() {
    this._items = HashMap(); // :(
  }

  int operator [](Product prod) => this._items[prod]["quant"];

  void getCartFromFirebase() async {
    this._dShot = FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser.uid)
        .get();
    this._dShot.then((doc) {
      // stop here if we don't have a cart
      if (doc.data() == null) {
        debugPrint("Cart is empty.");
        return;
      }

      doc.data()["items"].forEach((item) {
        Future<DocumentSnapshot> dShotProd = item["prod"].get();
        dShotProd.then((prod) {
          Map<String, dynamic> p = prod.data();
          this._items[Product(
                  p["name"], p["image"], p["category"], p["price"], p["ref"])] =
              item;
        }, onError: (dShot) {
          debugPrint("Cart init failed (died).");
          this._failed = true;
        });
      });
    }, onError: (qShot) {
      debugPrint("Cart init failed (died).");
      this._failed = true;
    });
  }

  void notifyWhenLoaded(FutureOr<void> Function() action) {
    this._dShot.whenComplete(action);
  }

  HashMap<Product, Map<String, dynamic>> getItems() {
    if (_failed)
      return HashMap();
    else
      return this._items;
  }

  Future<List<Map<String, int>>> getPurchaseHist() async {
    Future<DocumentSnapshot> dShot = FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser.uid)
        .get();

    return dShot.then((doc) {
      if (doc.data() == null || doc.data()["hist"] == null) {
        debugPrint("getPurchaseHist: no purchase history data.");
        return List();
      }

      // ??????????????????????
      List<Map<String, int>> ret = List();
      doc.data()["hist"].forEach((mapElem) {
        Map<String, int> m = Map();
        mapElem.forEach((k, v) {
          m[k] = v;
        });
        ret.add(m);
      });
      return ret;
    });
  }

  void updateFirebaseCart() {
    _rmEmptyItems(); // cleanup our data
    if (!_updated) // if not updated, do nothing
      return;
    _updated = false;

    // FirebaseAuth.instance.authStateChanges().listen((User user) {
    // if (user == null) {
    // print('User is currently signed out!');
    // } else {
    // print('User is signed in!');
    // }
    // });

    FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser.uid)
        .set({"items": _items.values.toList()});
  }

  void addItem(Product prod, int quant) {
    _updated = true;
    debugPrint("Adding " + quant.toString() + " of " + prod.name);
    if (_items.containsKey(prod))
      _items[prod]["quant"] += quant;
    else
      _items[prod] = {"prod": prod.ref, "quant": quant};
  }

  void rmItem(Product prod) {
    if (_items.remove(prod) != null) _updated = true;
  }

  void _rmEmptyItems() {
    // remove items with 0 in quantity from cart
    _items.removeWhere((prod, item) => item["quant"] == 0);

    _items.values.forEach((v) {
      if (v["quant"] == 0) {
        _updated = true;
        return;
      }
    });
  }

  void checkout() {
    debugPrint("Checking out..");
    if (this._items.isEmpty) {
      debugPrint("checkout: won't checkout because cart is empty");
      return;
    }

    this._updated = false;
    Tools.appendCurrUserInfo("hist", [
      {
        "date": DateTime.now().millisecondsSinceEpoch,
        "price": getTotalPrice(),
      }
    ]); // append this purchase
    clearCart();
    Tools.updateCurrUserInfo({"items": []}); // clear upstream cart
  }

  void incrementItem(Product prod) {
    _updated = true;
    if (_items.containsKey(prod))
      _items[prod]["quant"] += 1;
    else
      _items[prod]["quant"] = 1;
  }

  void decrementItem(Product prod) {
    _updated = true;
    if (_items[prod]["quant"] > 0) _items[prod]["quant"] -= 1;
  }

  int getTotalPrice() {
    int ret = 0;
    _items.forEach((prod, item) {
      ret += prod.getPrice(item["quant"]);
    });
    return ret;
  }

  Widget getButton(BuildContext context) {
    return IconButton(
      icon: Image(
        image: AssetImage('resources/shopping_cart.png'),
      ),
      onPressed: () {
        this.openShoppingPage(context);
      },
    );
  }

  void openShoppingPage(BuildContext context) {
    Navigator.of(context)
        .push(MaterialPageRoute<Null>(builder: (BuildContext context) {
      return ShoppingScreen();
    }));
  }
}
