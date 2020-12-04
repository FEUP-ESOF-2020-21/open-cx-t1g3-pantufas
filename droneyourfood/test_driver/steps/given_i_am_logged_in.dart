import 'package:flutter_driver/flutter_driver.dart';
import 'package:flutter_gherkin/flutter_gherkin.dart';
import 'package:gherkin/gherkin.dart';

StepDefinitionGeneric GivenIAmLoggedInStep() {
  return given<FlutterWorld>(
    'I am logged in',
    (context) async {
      final emailLocator = find.byValueKey("emailInput");
      await FlutterDriverUtils.enterText(
          context.world.driver, emailLocator, "nachosuwu@protonmail.com");

      final passLocator = find.byValueKey("passInput");
      await FlutterDriverUtils.enterText(
          context.world.driver, passLocator, "nachosnomnom");

      final buttonLocator = find.byValueKey("loginButton");
      await FlutterDriverUtils.tap(context.world.driver, buttonLocator);
    },
  );
}

