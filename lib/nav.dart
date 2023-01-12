import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:test_firebase_autu/profile.dart';

gotoprofile(context, user) {
  Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => Profile(
            user: user,
          )));
}
