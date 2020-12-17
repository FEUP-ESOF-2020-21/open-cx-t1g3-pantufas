import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter_test/flutter_test.dart';

import 'package:droneyourfood/Category/CategoryList.dart';
import 'package:droneyourfood/Category/Category.dart';

Future<List<Category>> categoryPromise() {
  var res = List<Category>();
  res.add(Category("Cat A", null));
  res.add(Category("Cat B", null));
  res.add(Category("Cat C", null));

  var completer = new Completer<List<Category>>();
  completer.complete(res);
  return completer.future;
}

main() {
  testWidgets("Category List Item", (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
        home: Scaffold(body: CategoryListItem(Category("CatTest", null)))));

    // Test Product Name
    final titleFinder = find.text("CatTest");
    expect(titleFinder, findsOneWidget);
  });

  testWidgets("CategoryListScreen", (WidgetTester tester) async {
    final fut = categoryPromise();

    final widget =
        MaterialApp(home: Scaffold(body: CategoryListWidget.fromPromise(fut)));
    // Wait for widget to build with promise
    await tester.pumpFrames(widget, Duration(seconds: 10));
    await tester.pumpWidget(widget);

    final categoryListsFinder = find.byType(CategoryListItem);
    expect(categoryListsFinder, findsNWidgets(3));

    final categoryListA = find.text("Cat A");
    expect(categoryListA, findsOneWidget);
    final categoryListB = find.text("Cat B");
    expect(categoryListB, findsOneWidget);
    final categoryListC = find.text("Cat C");
    expect(categoryListC, findsOneWidget);
  });
}
