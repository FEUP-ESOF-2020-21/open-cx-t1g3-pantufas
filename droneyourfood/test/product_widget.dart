import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:droneyourfood/Products/Product.dart';
import 'package:droneyourfood/Products/ProductWidget.dart';

main() {
  testWidgets("Product Name", (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
        home: Scaffold(
            body: ProductWidget(Product("ProdName", "Img", null, 5, null)))));

    // Test Product Name
    final titleFinder = find.text("ProdName");
    expect(titleFinder, findsOneWidget);
  });

  testWidgets("Add/Remove Single Press", (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
        home: Scaffold(
            body: ProductWidget(Product("ProdName", "Img", null, 5, null)))));

    // Test that Product Count doesnt exist
    final howMany2Add = find.byKey(Key("ToAddCountText"));
    expect(howMany2Add, findsNothing);

    // Enter Long press mode
    final normalButton = find.byKey(Key("NormalStateButton"));
    await tester.longPress(normalButton);

    // Test that Product Count exists
    expect(howMany2Add, findsOneWidget);
    var howMany2AddText = howMany2Add.evaluate().first.widget as Text;
    // Test that Product Count is set to 1
    expect(howMany2AddText.data, "1");
  });
}
