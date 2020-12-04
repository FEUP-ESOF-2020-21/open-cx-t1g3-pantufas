import 'dart:async';
import 'package:flutter_gherkin/flutter_gherkin.dart';
import 'package:gherkin/gherkin.dart';
import 'hooks/hook.dart';
import 'steps/given_i_am_logged_in.dart';

Future<void> main() {
  final steps = [GivenIAmLoggedInStep()];

  final config = FlutterTestConfiguration.DEFAULT(
    steps,
    featurePath: 'features//**.feature',
    targetAppPath: 'test_driver/app.dart',
  )
    ..hooks = [MyHook()]
    ..restartAppBetweenScenarios = true
    ..targetAppWorkingDirectory = '../'
    ..targetAppPath = "test_driver/app.dart"
    // ..reporters = [
    // you can include the "StdoutReporter()" without the message
    // level parameter for verbose log information
    // ProgressReporter(),
    // TestRunSummaryReporter(),
    // JsonReporter(path: './report.json')
    // ]
    ..exitAfterTestRun = true; // set to false if debugging to exit cleanly

  return GherkinRunner().execute(config);
}
