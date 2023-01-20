import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:test_firebase_autu/page/profile.dart';

import '../provider/Authentication.dart';

class LoginWithPhone extends StatefulWidget {
  const LoginWithPhone({Key? key}) : super(key: key);

  @override
  _LoginWithPhoneState createState() => _LoginWithPhoneState();
}

class _LoginWithPhoneState extends State<LoginWithPhone> {
  TextEditingController phoneController = TextEditingController(text: "+66");
  TextEditingController otpController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    var otpvisible = context.watch<Authentication>().otpVisibility;
    return Scaffold(
      appBar: AppBar(
        title: Text("Login With Phone"),
      ),
      body: Container(
        margin: EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: phoneController,
              decoration: InputDecoration(labelText: "Phone number"),
              keyboardType: TextInputType.phone,
            ),
            Visibility(
              child: TextField(
                controller: otpController,
                decoration: InputDecoration(labelText: "OTP"),
                keyboardType: TextInputType.number,
              ),
              visible: context.watch<Authentication>().otpVisibility,
            ),
            SizedBox(
              height: 10,
            ),
            ElevatedButton(
                onPressed: () {
                  if (otpvisible) {
                    context
                        .read<Authentication>()
                        .verifyOTP(context, otpController.text);
                  } else {
                    context
                        .read<Authentication>()
                        .loginWithPhone(phoneController.text);
                  }
                },
                child: Text(otpvisible ? "Verify" : "Login")),
          ],
        ),
      ),
    );
  }
}
