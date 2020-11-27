import 'package:flutter/material.dart';

import 'package:droneyourfood/Products/Product.dart';
import 'package:droneyourfood/Shopping/Shopping.dart';

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
                  setState(() {
                    ShoppingCart.instance.checkout();
                  });
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
