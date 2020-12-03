import 'package:flutter_gherkin/flutter_gherkin.dart';
import 'package:gherkin/gherkin.dart';
import 'package:firebase_auth/firebase_auth.dart';

StepDefinitionGeneric GivenIAmLoggedInStep(){
  return given<FlutterWorld>(
    'I am logged in',
    (context) async {
      FirebaseAuth.instance.signInWithEmailAndPassword(email: 'nachos@gmail.com', password: 'nachosnomnom'); 
    }
  );
}