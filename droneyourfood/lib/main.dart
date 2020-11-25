import 'package:droneyourfood/Theme/Theme.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:droneyourfood/Authentication/Signin.dart';
import 'package:droneyourfood/Category/CategoryListScreen.dart';
import 'package:droneyourfood/Products/ProductScreen.dart';
import 'package:droneyourfood/Tools.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Future<FirebaseApp> _initialization = Firebase.initializeApp();
    final MyTheme myTheme = MyTheme();

    return FutureBuilder(
      // Initialize FlutterFire:
      future: _initialization,
      builder: (context, snapshot) {
        // Once complete, show your application
        if (snapshot.connectionState == ConnectionState.done) {
          return MaterialApp(
            title: 'Drone your food',
            theme: myTheme.themeData,
            home: SignIn(),
          );
        }

        // Otherwise, show something whilst waiting for initialization to complete
        return Container();
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  final String title;

  MyHomePage({Key key, this.title}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  MaterialStateProperty<Color> _buttonColorFunction(MaterialColor c) {
    return MaterialStateProperty.resolveWith<Color>(
      (Set<MaterialState> states) {
        if (!states.contains(MaterialState.pressed)) return c;
        return c.withOpacity(0.8); // Use the component's default.
      },
    );
  }

  List<Widget> genButtons(BuildContext context) {
    return [
      ElevatedButton(
          style: ButtonStyle(
            backgroundColor: _buttonColorFunction(Colors.red),
          ),
          child: Text('List Products'),
          onPressed: () {
            //Use`Navigator` widget to pop oir go back to previous route / screen
            Navigator.of(context)
                .push(MaterialPageRoute<Null>(builder: (BuildContext context) {
              return ProductListScreen(null);
            }));
          }),
      ElevatedButton(
          style: ButtonStyle(
            backgroundColor: _buttonColorFunction(Colors.orange),
          ),
          child: Text('List Categories'),
          onPressed: () {
            //Use`Navigator` widget to pop oir go back to previous route / screen
            Navigator.of(context)
                .push(MaterialPageRoute<Null>(builder: (BuildContext context) {
              return CategoryListScreen();
            }));
          })
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Tools.genAppBar(context, widget.title),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: genButtons(context),
        ),
      ),
    );
  }
}
