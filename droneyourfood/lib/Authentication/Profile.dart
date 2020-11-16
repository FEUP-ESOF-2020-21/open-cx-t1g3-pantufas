import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:droneyourfood/Authentication/Authentication.dart';

class ProfileButton extends StatelessWidget {
  void openProfile(BuildContext context) {
    Navigator.of(context)
        .push(MaterialPageRoute<Null>(builder: (BuildContext context) {
      return ProfilePage();
    }));
  }

  @override
  Widget build(BuildContext context) {
    // pantufa n é fat >:(
    return IconButton(
      icon: Icon(Icons.person),
      onPressed: () {
        openProfile(context);
      },
    );
  }
}

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  User user = FirebaseAuth.instance.currentUser;

  String getUsername() {
    if (user == null || user.displayName == null)
      return "Anonymous";
    else
      return user.displayName;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            getUsername(),
          ),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Name: " + getUsername()),
              Text("Email: " + user.email),
              Text("Creation time: " + user.metadata.creationTime.toString()),
              Text("Last sign in: " + user.metadata.lastSignInTime.toString()),
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all<Color>(Colors.red),
                      ),
                      child: Text("Sign out"),
                      onPressed: () {
                        signout(context);
                      }),
                  Text(
                    "UID: " + user.uid,
                    style: TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                ],
              ),
            ],
          ),
        ));
  }

  void signout(BuildContext context) async {
    debugPrint("Sign-out");
    await FirebaseAuth.instance.signOut();

    AuthState.navigatorPopAll(context);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SignIn(),
      ),
    );
  }
}
