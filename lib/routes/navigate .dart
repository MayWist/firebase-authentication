import 'package:flutter/material.dart';
import 'package:test_firebase_autu/page/Login.dart';
import 'package:test_firebase_autu/page/phonelogin.dart';
import 'package:test_firebase_autu/page/profile.dart';

class Navigate {
  static Map<String, Widget Function(BuildContext)> routes = {
    '/Login': (BuildContext context) => Login(),
    '/LoginWithPhone': (BuildContext context) => LoginWithPhone(),
    '/Profile': (BuildContext context) => Profile(),
  };
}
