import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mockito/mockito.dart';

import 'package:droneyourfood/Profile/Profile.dart';

class UserMock extends Mock implements User {}

Future<List<Map<String, int>>> purchaseHistPromise() {
  var res = List<Map<String, int>>();
  res.add({
    'date': DateTime(2020, 12, 2, 12, 12).millisecondsSinceEpoch,
    'price': 1200
  });
  res.add({
    'date': DateTime(2019, 11, 3, 9, 0).millisecondsSinceEpoch,
    'price': 100
  });
  res.add({
    'date': DateTime(2018, 3, 20, 23, 50).millisecondsSinceEpoch,
    'price': 500
  });

  var completer = new Completer<List<Map<String, int>>>();
  completer.complete(res);
  return completer.future;
}

main() {
  var userMock = UserMock();
  when(userMock.displayName).thenReturn("Bazinga");
  when(userMock.uid).thenReturn("User UID Test");
  when(userMock.email).thenReturn("User Email Test");
  when(userMock.photoURL).thenReturn(null);

  group("Profile", () {
    testWidgets("User profile Widget", (WidgetTester tester) async {
      await tester.pumpWidget(
          MaterialApp(home: Scaffold(body: ProfilePage.fromUser(userMock))));

      final usernameFinder = find.byKey(Key("UsernameText"));
      expect(usernameFinder, findsOneWidget);
      final usernameText = usernameFinder.evaluate().first.widget as Text;
      expect(usernameText.data, "Bazinga");

      final uidFinder = find.byKey(Key("UserUIDText"));
      expect(uidFinder, findsOneWidget);
      final uidText = uidFinder.evaluate().first.widget as Text;
      expect(uidText.data, "UID: User UID Test");

      final emailFinder = find.byKey(Key("UserEmailText"));
      expect(emailFinder, findsOneWidget);
      final emailText = emailFinder.evaluate().first.widget as Text;
      expect(emailText.data, "User Email Test");

      final photoFinder = find.byKey(
          Key("UserPhotoBText")); // username for testing starts with B(azinga)
      expect(photoFinder, findsOneWidget);
    });

    testWidgets("Purchase History Screen", (WidgetTester tester) async {
      final fut = purchaseHistPromise();

      final widget = MaterialApp(home: Scaffold(body: PurchaseHistScreen(fut)));
      // Wait for widget to build with promise
      await tester.pumpFrames(widget, Duration(seconds: 10));
      await tester.pumpWidget(widget);

      final purchasesFinder = find.byType(ListTile);
      expect(purchasesFinder, findsNWidgets(3));

      final firstPurchase =
          purchasesFinder.at(0).evaluate().first.widget as ListTile;
      expect((firstPurchase.title as Text).data, "2020-12-02 12:12");
      expect((firstPurchase.subtitle as Text).data, "12.0€");
      final secondPurchase =
          purchasesFinder.at(1).evaluate().first.widget as ListTile;
      expect((secondPurchase.title as Text).data, "2019-11-03 09:00");
      expect((secondPurchase.subtitle as Text).data, "1.0€");
      final thirdPurchase =
          purchasesFinder.at(2).evaluate().first.widget as ListTile;
      expect((thirdPurchase.title as Text).data, "2018-03-20 23:50");
      expect((thirdPurchase.subtitle as Text).data, "5.0€");
    });
  });
}
