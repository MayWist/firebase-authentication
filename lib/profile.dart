import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_line_sdk/flutter_line_sdk.dart';

class Profile extends StatelessWidget {
  Profile({super.key, required this.user});
  var user;
  @override
  Widget build(BuildContext context) {
    print(user.toString());
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          Text(user.toString()),
          ElevatedButton(
              onPressed: () {
                signOut(context);
              },
              child: Text("signOut")),
        ],
      ),
    );
  }

  Future signOut(context) async {
    await FirebaseAuth.instance.signOut();
    if (FirebaseAuth.instance.currentUser == null) {
      print("Firebase AuthsignOut");
      print(FirebaseAuth.instance.currentUser);
    }

    try {
      await LineSDK.instance.logout();
      print("line logout");
    } on PlatformException catch (e) {
      print(e.message);
    }
    Navigator.of(context).pop(context);
  }
}
