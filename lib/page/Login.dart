import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/Authentication.dart';

class Login extends StatelessWidget {
  Login({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ElevatedButton(
              onPressed: () {
                context.read<Authentication>().emailandpasswordLogin(context);
              },
              child: Text("email/password")),
          ElevatedButton(
              onPressed: () {
                context.read<Authentication>().googleLogin(context);
              },
              child: Text("Google")),
          ElevatedButton(
              onPressed: () {
                context.read<Authentication>().facebookLogin(context);
              },
              child: Text("Facebook")),
          ElevatedButton(
              onPressed: () {
                context.read<Authentication>().lineLogin(context);
              },
              child: Text("Line")),
          ElevatedButton(
              onPressed: () {
                context.read<Authentication>().anonymousLogin(context);
              },
              child: Text("Anonymous")),
          ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, "/LoginWithPhone");
              },
              child: Text("Phone")),
        ],
      ),
    );
  }
}
