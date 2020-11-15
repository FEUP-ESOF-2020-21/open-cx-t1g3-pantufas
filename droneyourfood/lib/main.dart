import 'package:droneyourfood/Shopping/Shopping.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:droneyourfood/Category/CategoryListScreen.dart';
import 'package:droneyourfood/Products/ListProduct.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  final swatch = const MaterialColor(0xFF202124, const <int, Color>{
    50: const Color(0xFF32674C),
    100: const Color(0xFFCFD3D8),
    200: const Color(0xFFABAFB1),
    300: const Color(0xFF929597),
    400: const Color(0xFF6D7172),
    500: const Color(0xFF4E5254),
    600: const Color(0xFF3c4042),
    700: const Color(0xFF202124),
    800: const Color(0xFF1D1D1D),
    900: const Color(0xFF121212),
  });

  @override
  Widget build(BuildContext context) {
    final Future<FirebaseApp> _initialization = Firebase.initializeApp();

    return FutureBuilder(
      // Initialize FlutterFire:
      future: _initialization,
      builder: (context, snapshot) {
        // Check for errors
        // if (snapshot.hasError) {
        //   return SomethingWentWrong();
        // }

        // Once complete, show your application
        if (snapshot.connectionState == ConnectionState.done) {
          return MaterialApp(
            title: 'Drone your food',
            theme: ThemeData(
              brightness: Brightness.dark,
              primaryColor: swatch.shade800,
              accentColor: swatch.shade800,
              primarySwatch: swatch,
              colorScheme: ColorScheme.fromSwatch(
                  primarySwatch: swatch,
                  primaryColorDark: swatch.shade800,
                  accentColor: swatch.shade50,
                  cardColor: swatch.shade500,
                  backgroundColor: swatch.shade800,
                  brightness: Brightness.dark),
              scaffoldBackgroundColor: swatch.shade900,
            ),
            home: MyHomePage(title: 'Drone your food'),
          );
        }
        // Otherwise, show something whilst waiting for initialization to complete
        // return Loading();
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Row(
          children: [
            Expanded(
              child: Text(
                widget.title,
                textAlign: TextAlign.left,
              ),
            ),
            Expanded(
                child: Align(
                    alignment: Alignment.centerRight,
                    child: ShoppingCart().getButton(context)))
          ],
        ),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.resolveWith<Color>(
                    (Set<MaterialState> states) {
                      if (!states.contains(MaterialState.pressed))
                        return Colors.red;
                      return Colors.red
                          .withOpacity(0.8); // Use the component's default.
                    },
                  ),
                ),
                child: Text('List Products'),
                onPressed: () {
                  //Use`Navigator` widget to pop oir go back to previous route / screen
                  Navigator.of(context).push(
                      MaterialPageRoute<Null>(builder: (BuildContext context) {
                    return new ProductListScreen(null);
                  }));
                }),
            ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.resolveWith<Color>(
                    (Set<MaterialState> states) {
                      if (!states.contains(MaterialState.pressed))
                        return Colors.orange;
                      return Colors.orange
                          .withOpacity(0.8); // Use the component's default.
                    },
                  ),
                ),
                child: Text('List Categories'),
                onPressed: () {
                  //Use`Navigator` widget to pop oir go back to previous route / screen
                  Navigator.of(context).push(
                      MaterialPageRoute<Null>(builder: (BuildContext context) {
                    return new CategoryListScreen();
                  }));
                })
          ],
        ),
      ),
    );
  }
}
