import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:droneyourfood/Authentication/Authentication.dart';
import 'package:droneyourfood/Tools.dart';

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
    final double appBarHeight = MediaQuery.of(context).size.height -
        MediaQuery.of(context).padding.top -
        kToolbarHeight;
    return Scaffold(
        appBar: AppBar(title: Text(getUsername())),
        body: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: appBarHeight),
            child: IntrinsicHeight(
              child: Column(
                // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: header(context) +
                    [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.shopping_cart_outlined),
                              Text(
                                " 10",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Text(
                                " orders",
                                style: TextStyle(fontWeight: FontWeight.w300),
                              ),
                            ],
                          ),
                          Text("·",
                              style: TextStyle(fontWeight: FontWeight.w900)),
                          Row(
                            children: [
                              Icon(Icons.star_outline),
                              Text(
                                " 50",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Text(
                                " rates",
                                style: TextStyle(fontWeight: FontWeight.w300),
                              ),
                            ],
                          )
                        ],
                      ),
                    ] +
                    footer(context),
              ),
            ),
          ),
        ));
  }

  Widget userAvatar(BuildContext context) {
    final Size s = MediaQuery.of(context).size;
    double avatarRad;
    if (s.height > s.width)
      avatarRad = s.width * 0.2;
    else
      avatarRad = s.height * 0.15;

    Widget avatarPic;
    if (user.photoURL == null) {
      // user has no pfp
      final initials = getUsername()[0];
      avatarPic = CircleAvatar(
        radius: avatarRad,
        backgroundColor: Colors.green.shade200,
        child: Text(initials, style: TextStyle(fontSize: avatarRad)),
      );
    }
    avatarPic = CircleAvatar(
      radius: avatarRad,
      backgroundColor: Theme.of(context).backgroundColor,
      backgroundImage: NetworkImage("https://i.imgur.com/4vwF28a.jpg"),
    );

    return Container(
      width: avatarRad * 2,
      height: avatarRad * 2,
      child: Stack(
        children: <Widget>[
          avatarPic,
          new Align(
            alignment: Alignment.bottomRight,
            child: FloatingActionButton(
              mini: true,
              child: Icon(Icons.image),
              onPressed: () {
                print("cucu");
              },
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> header(BuildContext context) {
    return [
      SizedBox(height: 10),
      userAvatar(context),
      SizedBox(height: 8),
      Text(getUsername(),
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
      Text(user.email),
      Spacer(),
    ];
  }

  Widget signoutButton(BuildContext context) {
    return ElevatedButton(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all<Color>(Colors.red),
        ),
        child: Text("Sign out"),
        onPressed: () {
          signout(context);
        });
  }

  List<Widget> footer(BuildContext context) {
    return [
      Spacer(),
      Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          signoutButton(context),
          Text(
            "UID: " + user.uid,
            style: TextStyle(color: Colors.grey, fontSize: 12),
          ),
        ],
      )
    ];
  }

  void signout(BuildContext context) async {
    Tools.signout(context);

    Tools.navigatorPushAsRoot(
      context,
      MaterialPageRoute(
        builder: (context) => SignIn(),
      ),
    );
  }
}
