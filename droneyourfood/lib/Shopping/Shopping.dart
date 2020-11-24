import 'dart:async';
import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:droneyourfood/Products/Product.dart';
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
      return new ShoppingScreen();
    }));
  }
}

class ShoppingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Shopping Cart',
        ),
      ),
      body: ShoppingListWidget(),
    );
  }
}

class ShoppingItem extends StatefulWidget {
  final _ShoppingListWidgetState parentState;
  final Product prod;

  ShoppingItem(this.prod, this.parentState);

  @override
  _ShoppingItemState createState() => _ShoppingItemState();

  String getPrice() {
    return (prod.getPrice(1) / 100.0).toString() +
        "€ x " +
        ShoppingCart.instance[prod].toString() +
        " = " +
        (prod.getPrice(ShoppingCart.instance[prod]) / 100.0).toString() +
        "€";
  }
}

class _ShoppingItemState extends State<ShoppingItem> {
  Widget getDecorated(Color color, Widget child) {
    /*
     *  Returns content of shopping cart list decoration (box/bg/colors)
     */
    // TODO this is a shitty workaround
    return Container(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.all(Radius.circular(12.0)),
      ),
      padding: EdgeInsets.all(8.0),
      margin: EdgeInsets.all(8.0),
      child: Material(
        color: color,
        child: child,
      ),
    );
  }

  Widget getContent() {
    /*
     *  Returns content of shopping cart list
     */
    return getDecorated(
        Theme.of(context).primaryColor,
        Row(
          /* ITEM */
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
                /* ITEM ICON */
                width: 80.0,
                height: 80.0,
                child: Image(
                  image: AssetImage('resources/logo.png'),
                )),
            Column(
              /* ITEM CONTROLS/INFO */
              children: [
                Text(
                  /* TITLE */
                  widget.prod.name,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8), // space between title & price
                Text(
                  /* PRICE */
                  widget.getPrice(),
                  style: TextStyle(color: Color(0xFFCFD3D8), fontSize: 12),
                ),
                Row(
                  /* QUANTITY CONTROLS */
                  children: [
                    IconButton(
                      /* DECREMENT */
                      icon: Icon(Icons.remove),
                      onPressed: decrementItem,
                    ),
                    Text(
                      /* QUANTITY */
                      ShoppingCart.instance[widget.prod].toString(),
                      style: TextStyle(color: Color(0xFFCFD3D8), fontSize: 14),
                    ),
                    IconButton(
                      /* INCREMENT */
                      icon: Icon(Icons.add),
                      onPressed: incrementItem,
                    ),
                  ],
                )
              ],
            ),
            IconButton(
              /* DELETE */
              icon: Icon(Icons.delete),
              onPressed: rmItem,
            )
          ],
        ));
  }

  @override
  Widget build(BuildContext context) {
    /*
     *  Returns shopping cart item
     */
    return Dismissible(
      key: UniqueKey(),
      onDismissed: rmItemDD,
      direction: DismissDirection.endToStart,
      child: getContent(),
      background: getDecorated(Colors.red, null),
    );
  }

  void decrementItem() {
    debugPrint("removing 1 from prod: " + widget.prod.name);
    setState(() {
      ShoppingCart.instance.decrementItem(widget.prod);
    });
    widget.parentState.setState(() {});
  }

  void incrementItem() {
    debugPrint("adding 1 to prod: " + widget.prod.name);
    setState(() {
      ShoppingCart.instance.incrementItem(widget.prod);
    });
    widget.parentState.setState(() {});
  }

  void rmItem() {
    debugPrint("Deleting prod: " + widget.prod.name);
    widget.parentState.setState(() {
      ShoppingCart.instance.rmItem(widget.prod);
    });
  }

  void rmItemDD(DismissDirection dd) {
    rmItem();
  }
}

class ShoppingListWidget extends StatefulWidget {
  @override
  _ShoppingListWidgetState createState() => _ShoppingListWidgetState();
}

class _ShoppingListWidgetState extends State<ShoppingListWidget> {
  bool isEmpty = false, isInited = false;

  String getTotalPrice() {
    if (this.isEmpty) {
      return "Your cart is empty.";
    } else {
      double totPrice = ShoppingCart.instance.getTotalPrice() / 100.0;
      return "Total cost: " + totPrice.toString() + "€";
    }
  }

  List<ShoppingItem> getShoppingItems() {
    List<ShoppingItem> shopItems = new List();
    ShoppingCart.instance.getItems().forEach((prod, item) {
      shopItems.add(new ShoppingItem(prod, this));
    });
    this.isEmpty = shopItems.isEmpty;

    // update list when querry is done
    if (!isInited) {
      ShoppingCart.instance.notifyWhenLoaded(() {
        setState(() {});
      });
    }

    return shopItems;
  }

  Widget getCheckoutWidget(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          /* TOTAL PRICE OF CART */
          getTotalPrice(),
          style: TextStyle(
              color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
        ),
        ElevatedButton(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.resolveWith<Color>(
              (Set<MaterialState> states) {
                if (!states.contains(MaterialState.pressed))
                  return Colors.red.withOpacity(0.8);
                return Colors.red; // Use the component's default.
              },
            ),
          ),
          child: Text("Checkout"),
          onPressed: this.isEmpty
              ? null
              : () {
                  debugPrint("TODO: CHECKOUT processes");
                },
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget ret =
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Expanded(
          child: ListView(
        children: this.getShoppingItems(),
      )),
      Container(
        decoration:
            BoxDecoration(color: Theme.of(context).primaryColor, boxShadow: [
          BoxShadow(
            color: Colors.black,
            spreadRadius: 1.0,
          ),
        ]),
        padding: EdgeInsets.fromLTRB(20, 30, 20, 30),
        child: getCheckoutWidget(context),
      ),
    ]);

    this.isInited = true;
    return ret;
  }

  @override
  void dispose() {
    // backup shopping cart
    ShoppingCart.instance.updateFirebaseCart();
    super.dispose();
  }
}
