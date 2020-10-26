import 'package:flutter/material.dart';
import 'ProductWidget.dart';

class ProductListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('First Screen'),
      ),
      body: Center(child: Column(children : <Widget>[
            RaisedButton(
              color: Colors.red,
              child: Text('Go Back'),
              onPressed: () {
                //Use`Navigator` widget to pop oir go back to previous route / screen
                Navigator.pop(context);
              }
            ),
            ProductsWidget(),
            FlatButton(
                child: Text('Bebeu', style: TextStyle(fontSize: 20.0),),
                color: Colors.blueAccent,
                textColor: Colors.white,
                onPressed: () {
                    ProductsWidget().createState();
                }
            ),

        ]))
    );
  }
}
