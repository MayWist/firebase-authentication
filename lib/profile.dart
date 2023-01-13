import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_line_sdk/flutter_line_sdk.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:test_firebase_autu/main.dart';

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
    print("singout func");
    await Firebase.initializeApp().then((value) async {
      await FirebaseAuth.instance.signOut();
      print("user =  " + FirebaseAuth.instance.currentUser.toString());
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => MyApp(),
          ),
          (route) => false);
    });
    final googleSignIn = GoogleSignIn();
    await googleSignIn.disconnect();
    try {
      LineSDK.instance.setup("${1657807795}").then((_) {
        print("LineSDK Prepared");
      });
      await LineSDK.instance.logout();
      print("line logout");
    } on PlatformException catch (e) {
      print(e.message);
    }
  }
}
