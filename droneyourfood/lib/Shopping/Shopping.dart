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
    QuerySnapshot qShot =
        await FirebaseFirestore.instance.collection('users').get();
    qShot.docs.forEach((doc) {
      doc["items"].forEach((item) async {
        DocumentSnapshot dShot = await item.get();
        Map<String, dynamic> d = dShot.data();
        this.items[Product(d["name"], d["image"], d["category"], d["price"])] =
            1;
      });
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

  void addItem(Product prod, int quant) {
    items[prod] = quant;
  }

  void rmItem(Product prod) {
    items.remove(prod);
  }

  void rmEmptyItems() {
    // remove items with 0 in quantity from cart
    items.removeWhere((prod, quant) => quant == 0);
  }

  void incrementItem(Product prod) {
    items[prod] += 1;
  }

  void decrementItem(Product prod) {
    if (items[prod] > 0) items[prod] -= 1;
  }

  int getTotalPrice() {
    int ret = 0;
    items.forEach((prod, quant) {
      ret += prod.getPrice(quant);
    });
    return ret;
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
            'Shopping Cart',
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
    return (prod.getPrice(shoppingCart[prod]) / 100.0).toString() + "€";
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
    debugPrint("removing 1 from prod: " + widget.prod.name);
    setState(() {
      widget.shoppingCart.decrementItem(widget.prod);
    });
    widget.parentState.setState(() {});
  }

  void incrementItem() {
    debugPrint("adding 1 to prod: " + widget.prod.name);
    setState(() {
      widget.shoppingCart.incrementItem(widget.prod);
    });
    widget.parentState.setState(() {});
  }

  void rmItem() {
    debugPrint("Deleting prod: " + widget.prod.name);
    widget.parentState.setState(() {
      widget.shoppingCart.rmItem(widget.prod);
    });
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
  String getTotalPrice() {
    double totPrice = widget.shoppingCart.getTotalPrice() / 100.0;
    if (totPrice == 0.0)
      return "Your cart is empty.";
    else
      return "Total cost: " + totPrice.toString() + "€";
  }

  List<ShoppingItem> getShoppingItems() {
    List<ShoppingItem> shopItems = new List();
    widget.shoppingCart.items.forEach((prod, quant) {
      shopItems.add(new ShoppingItem(widget.shoppingCart, prod, this));
    });
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
          onPressed: () {
            debugPrint("TODO: CHECKOUT processes");
          },
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
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
  }

  @override
  void dispose() {
    // cleanup shopping cart
    widget.shoppingCart.rmEmptyItems();
    // backup shopping cart

    super.dispose();
  }
}
