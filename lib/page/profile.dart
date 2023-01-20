import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_line_sdk/flutter_line_sdk.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:test_firebase_autu/main.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart' as fbauth;

import '../provider/Authentication.dart';

class Profile extends StatelessWidget {
  //login /ano
  const Profile({Key? key}) : super(key: key);

  // Profile({super.key, required this.user});
  // var user;
  @override
  Widget build(BuildContext context) {
    //log color

    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          Text(context.watch<Authentication>().userdata.toString()),
          ElevatedButton(
              onPressed: () {
                context.read<Authentication>().signOut(context);
              },
              child: Text("signOut")),
        ],
      ),
    );
  }
}
