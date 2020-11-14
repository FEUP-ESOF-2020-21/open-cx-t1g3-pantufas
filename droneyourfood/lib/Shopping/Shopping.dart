import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:droneyourfood/Products/Product.dart';
import 'package:flutter/material.dart';

class ShoppingCart {
  static final ShoppingCart _instance = ShoppingCart._internal();
  Map<Product, int> items;

  factory ShoppingCart() {
    return _instance;
  }

  ShoppingCart._internal() {
    this.items = new Map(); // :(
    getCartFromFirebase();
  }

  void getCartFromFirebase() async {
    QuerySnapshot qShot;
    qShot = await FirebaseFirestore.instance.collection('products').get();
    qShot.docs
        .map((doc) =>
            Product(doc["name"], doc["image"], doc["category"], doc["price"]))
        .toList()
        .forEach((prod) {
      this.items[prod] = 1;
    });
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
      return new ShoppingScreen(this);
    }));
  }

  addItem(Product prod, int quant) {
    items[prod] = quant;
  }

  rmItem(Product prod) {
    items.remove(prod);
  }

  rmEmptyItems() {
    // remove items with 0 in quantity from cart
    items.removeWhere((prod, quant) => quant == 0);
  }

  incrementItem(Product prod) {
    items[prod] += 1;
  }

  decrementItem(Product prod) {
    if (items[prod] > 0) items[prod] -= 1;
  }

  int operator [](Product prod) => this.items[prod];
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

class ShoppingItem extends StatefulWidget {
  final _ShoppingListWidgetState parentState;
  final ShoppingCart shoppingCart;
  final Product prod;

  ShoppingItem(this.shoppingCart, this.prod, this.parentState);

  @override
  _ShoppingItemState createState() => _ShoppingItemState();

  String getPrice() {
    return prod.getPrice(shoppingCart[prod]).toString() + "€";
  }
}

class _ShoppingItemState extends State<ShoppingItem> {
  Widget getDecorated(Color color, Widget child) {
    /*
     *  Returns content of shopping cart list decoration (box/bg/colors)
     */
    return Container(
      decoration: BoxDecoration(
          color: color, borderRadius: BorderRadius.all(Radius.circular(12.0))),
      padding: new EdgeInsets.all(8.0),
      margin: new EdgeInsets.all(8.0),
      child: child,
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
            Container(
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
                      widget.shoppingCart[widget.prod].toString(),
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
    print("removing 1 from prod: " + widget.prod.name);
    setState(() {
      widget.shoppingCart.decrementItem(widget.prod);
    });
    print("removed 1 from prod: " + widget.prod.name);
  }

  void incrementItem() {
    print("adding 1 to prod: " + widget.prod.name);
    setState(() {
      widget.shoppingCart.incrementItem(widget.prod);
    });
    print("added 1 to prod: " + widget.prod.name);
  }

  void rmItem() {
    print("Deleting prod: " + widget.prod.name);
    widget.parentState.setState(() {
      widget.shoppingCart.rmItem(widget.prod);
    });
    print("Deleted prod: " + widget.prod.name);
  }

  void rmItemDD(DismissDirection dd) {
    rmItem();
  }
}

class ShoppingListWidget extends StatefulWidget {
  final ShoppingCart shoppingCart;

  ShoppingListWidget(this.shoppingCart);

  @override
  _ShoppingListWidgetState createState() => _ShoppingListWidgetState();
}

class _ShoppingListWidgetState extends State<ShoppingListWidget> {
  List<ShoppingItem> getShoppingItems() {
    List<ShoppingItem> shopItems = new List();
    widget.shoppingCart.items.forEach((prod, quant) {
      shopItems.add(new ShoppingItem(widget.shoppingCart, prod, this));
    });
    return shopItems;
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Expanded(
          child: ListView(
        children: this.getShoppingItems(),
      ))
    ]);
  }

  @override
  void dispose() {
    // cleanup shopping cart
    widget.shoppingCart.rmEmptyItems();
    // backup shopping cart

    super.dispose();
  }
}
