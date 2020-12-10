import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mockito/mockito.dart';

import 'package:droneyourfood/Profile/Profile.dart';

class UserMock extends Mock implements User {}

main() {
  var userMock = UserMock();
  when(userMock.displayName).thenReturn("Bazinga");
  when(userMock.uid).thenReturn("User UID Test");
  when(userMock.email).thenReturn("User Email Test");
  when(userMock.photoURL).thenReturn(null);

  testWidgets("Purchase History Button", (WidgetTester tester) async {
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
}
