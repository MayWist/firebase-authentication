import 'package:flutter/material.dart';
import 'package:test_firebase_autu/view/login/login.dart';
import 'package:test_firebase_autu/view/login/phonelogin.dart';
import 'package:test_firebase_autu/view/profile.dart';

class Navigate {
  static Map<String, Widget Function(BuildContext)> routes = {
    '/Login': (BuildContext context) => Login(),
    '/LoginWithPhone': (BuildContext context) => LoginWithPhone(),
    '/Profile': (BuildContext context) => Profile(),
  };
}
