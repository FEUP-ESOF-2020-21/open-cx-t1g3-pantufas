import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import 'package:droneyourfood/Authentication/Authentication.dart';
import 'package:droneyourfood/Components/ScrollColumn.dart';
import 'package:droneyourfood/Shopping/Shopping.dart';
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
  File _currImage;
  User user = FirebaseAuth.instance.currentUser;
  Future<List<Map<String, int>>> purscHist =
      ShoppingCart.instance.getPurchaseHist();

  String getUsername() {
    if (user == null || user.displayName == null)
      return "Anonymous";
    else
      return user.displayName;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(getUsername())),
      body: ScrollColumn(
        startHeight: Tools.getAppBarHeight(context),
        children: header(context) +
            [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  purchaseHistButton(context),
                  Text("·", style: TextStyle(fontWeight: FontWeight.w900)),
                  rateHistButton(context),
                ],
              ),
            ] +
            footer(context),
      ),
    );
  }

  Widget purchaseHistButton(BuildContext context) {
    return FlatButton.icon(
      color: Theme.of(context).scaffoldBackgroundColor,
      icon: Icon(Icons.shopping_cart_outlined),
      label: Row(
        children: [
          FutureBuilder(
            future: this.purscHist,
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              String ret;
              if (snapshot.hasData)
                ret = snapshot.data.length.toString();
              else if (snapshot.hasError)
                ret = "0";
              else
                ret = "..";

              return Text(ret, style: TextStyle(fontWeight: FontWeight.bold));
            },
          ),
          Text(
            " orders",
            style: TextStyle(fontWeight: FontWeight.w300),
          ),
        ],
      ),
      onPressed: () {
        debugPrint("Open purchase history.");
        Navigator.of(context)
            .push(MaterialPageRoute<Null>(builder: (BuildContext context) {
          return PurchaseHistScreen(this.purscHist);
        }));
      },
    );
  }

  Widget rateHistButton(BuildContext context) {
    return FlatButton.icon(
      color: Theme.of(context).scaffoldBackgroundColor,
      icon: Icon(Icons.star_outline),
      label: Row(
        children: [
          Text(
            " 50", // TODO placeholder
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Text(
            " rates",
            style: TextStyle(fontWeight: FontWeight.w300),
          ),
        ],
      ),
      onPressed: () {
        debugPrint("WIP: rate history button.");
      },
    );
  }

  Widget userAvatar(BuildContext context) {
    final Size s = MediaQuery.of(context).size;
    double avatarRad;
    if (s.height > s.width)
      avatarRad = s.width * 0.2;
    else
      avatarRad = s.height * 0.15;

    Widget avatarPic;
    if (this._currImage != null) {
      avatarPic = CircleAvatar(
        radius: avatarRad,
        backgroundColor: Theme.of(context).backgroundColor,
        backgroundImage: FileImage(this._currImage),
      );
    } else if (user.photoURL == null) {
      // user has no pfp
      final initials = getUsername()[0];
      avatarPic = CircleAvatar(
        radius: avatarRad,
        backgroundColor: Colors.green.shade200,
        child: Text(initials, style: TextStyle(fontSize: avatarRad)),
      );
    } else {
      avatarPic = CircleAvatar(
        radius: avatarRad,
        backgroundColor: Theme.of(context).backgroundColor,
        backgroundImage: NetworkImage(user.photoURL),
      );
    }

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
              onPressed: changePfp,
            ),
          ),
        ],
      ),
    );
  }

  void changePfp() async {
    debugPrint("changePfp: attempting to change profile picture.");

    // choose image
    final PickedFile pickedImage = await ImagePicker()
        .getImage(source: ImageSource.gallery, imageQuality: 100);
    if (pickedImage == null) {
      debugPrint("changePfp: user canceled the pfp change.");
      return;
    }

    try {
      final File image = File(pickedImage.path);

      // upload image
      final String path = "userpfp/" + FirebaseAuth.instance.currentUser.uid;
      await FirebaseStorage.instance.ref(path).putFile(image);

      final Reference urlRef = FirebaseStorage.instance.ref(path);
      final String url = (await urlRef.getDownloadURL()).toString();
      await user.updateProfile(photoURL: url);

      // update pic
      setState(() {
        this._currImage = image;
      });
    } catch (e) {
      debugPrint("changePfp: " + e.toString());
    }
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

class PurchaseHistScreen extends StatelessWidget {
  final Future<List<Map<String, int>>> purscHist;

  PurchaseHistScreen(this.purscHist);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Purchase history")),
      body: FutureBuilder(
        future: this.purscHist,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data.length == 0)
              return Text("You have no purchases.");

            return ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (context, i) {
                return genHistEntry(context, snapshot.data[i]);
              },
            );
          } else if (snapshot.hasError) {
            return Text("You have no purchases.");
          }

          return Text("Loading..");
        },
      ),
    );
  }

  Widget genHistEntry(BuildContext context, Map<String, int> data) {
    final DateTime date =
        DateTime.fromMillisecondsSinceEpoch(data["date"]).toLocal();
    final dateStr = DateFormat("yyyy-MM-dd HH:mm").format(date);

    final String price = (data["price"] / 100.0).toString() + "€";

    return ListTile(
      title: Text(dateStr),
      subtitle: Text(price),
    );
  }
}
