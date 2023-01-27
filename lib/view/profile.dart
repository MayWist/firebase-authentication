import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../viewmodel/login_viewmodel.dart';

class Profile extends StatelessWidget {
  //login /ano
  const Profile({Key? key}) : super(key: key);

  // Profile({super.key, required this.user});
  // var user;
  @override
  Widget build(BuildContext context) {
    var loginViewModel = context.watch<LoginViewModel>();

    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
        automaticallyImplyLeading: false,
      ),
      body: Column(
        children: [
          Text(loginViewModel.userdata),
          ElevatedButton(
              onPressed: () {
                loginViewModel.signOut(context);
              },
              child: Text("signOut")),
        ],
      ),
    );
  }
}
