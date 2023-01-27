import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:provider/provider.dart';
import 'package:test_firebase_autu/viewmodel/login_viewmodel.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  @override
  void initState() {
    super.initState();
    initialization();
  }

  void initialization() async {
    // await Firebase.initializeApp();
    // FlutterNativeSplash.remove();
  }

  @override
  Widget build(BuildContext context) {
    var loginViewModel = context.watch<LoginViewModel>();

    return Scaffold(
      appBar: AppBar(
        title: Text("Login app"),
      ),
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ElevatedButton(
              onPressed: () {
                loginViewModel.emailandpasswordLogin(context);
              },
              child: Text("email/password")),
          ElevatedButton(
              onPressed: () {
                loginViewModel.googleLogin(context);
              },
              child: Text("Google")),
          ElevatedButton(
              onPressed: () {
                loginViewModel.facebookLogin(context);
              },
              child: Text("Facebook")),
          ElevatedButton(
              onPressed: () {
                loginViewModel.lineLogin(context);
              },
              child: Text("Line")),
          ElevatedButton(
              onPressed: () {
                loginViewModel.anonymousLogin(context);
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
