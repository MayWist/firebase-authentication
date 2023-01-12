import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart' as fbauth;
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_line_sdk/flutter_line_sdk.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  // final Future<FirebaseApp> firebase = Firebase.initializeApp();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Home(),
    );
  }
}

class Home extends StatelessWidget {
  Home({Key? key}) : super(key: key);
  TextEditingController phoneController = TextEditingController();
  TextEditingController smsController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Column(children: [
          ElevatedButton(
              onPressed: emailandpasswordLogin, child: Text("email/password")),
          ElevatedButton(onPressed: googleLogin, child: Text("Google")),
          ElevatedButton(onPressed: facebookLogin, child: Text("Facebook")),
          ElevatedButton(onPressed: twitterLoging, child: Text("Twitter")),
          ElevatedButton(onPressed: lineLogin, child: Text("Line")),
          ElevatedButton(onPressed: anonymousLogin, child: Text("Anonymous")),
          ElevatedButton(onPressed: phoneLogin, child: Text("Phone")),
          TextField(
              controller: phoneController,
              keyboardType: TextInputType.numberWithOptions(),
              decoration:
                  InputDecoration.collapsed(hintText: "Phone xx-xxx-xxxx"),
              style: TextStyle(fontSize: 18)),
          TextField(
              controller: smsController,
              keyboardType: TextInputType.numberWithOptions(),
              decoration: InputDecoration.collapsed(hintText: "SMS verify"),
              style: TextStyle(fontSize: 18)),
          ElevatedButton(onPressed: signOut, child: Text("signOut")),
        ]),
      ),
      floatingActionButton: const FloatingActionButton(onPressed: signOut),
    );
  }

  Future phoneLogin() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: '+44 ' + phoneController.text,
      verificationCompleted: (PhoneAuthCredential credential) async {
        var user = await auth.signInWithCredential(credential);
        print("phonelogin");
        print(user);
      },
      verificationFailed: (FirebaseAuthException e) {
        if (e.code == 'invalid-phone-number') {
          print('The provided phone number is not valid.');
        }
      },
      codeSent: (String verificationId, int? resendToken) async {
        String smsCode = smsController.text;

        PhoneAuthCredential credential = PhoneAuthProvider.credential(
            verificationId: verificationId, smsCode: smsCode);

        await auth.signInWithCredential(credential);
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        print("timeout");
      },
    );
  }
}

Future signOut() async {
  await FirebaseAuth.instance.signOut();

  if (FirebaseAuth.instance.currentUser == null) {
    print("signOut");
    print(FirebaseAuth.instance.currentUser);
  }
  if (LineSDK.instance != null) {
    try {
      await LineSDK.instance.logout();
    } on PlatformException catch (e) {
      print(e.message);
    }
  }
}

Future twitterLoging() async {}

Future googleLogin() async {
  final googleSignIn = GoogleSignIn();
  GoogleSignInAccount? _user;
  final googleUser = await googleSignIn.signIn();
  if (googleUser == null) return;
  _user = googleUser;

  final googleAuth = await googleUser.authentication;

  final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken, idToken: googleAuth.idToken);

  await FirebaseAuth.instance.signInWithCredential(credential).then((value) {
    print("login google");
    print(_user!.email);
  });
}

Future facebookLogin() async {
  try {
    final fbauth.LoginResult loginResult =
        await fbauth.FacebookAuth.instance.login();
    final userdata = await fbauth.FacebookAuth.instance.getUserData();
    final OAuthCredential facebookAuthCredential =
        FacebookAuthProvider.credential(loginResult.accessToken!.token);
    await FirebaseAuth.instance.signInWithCredential(facebookAuthCredential);
    print("facebookLogin");
    print(userdata['email']);
  } on FirebaseException catch (e) {
    print(e);
  }
}

Future anonymousLogin() async {
  try {
    final userCredential = await FirebaseAuth.instance.signInAnonymously();
    print("Signed in with temporary account.");
  } on FirebaseAuthException catch (e) {
    switch (e.code) {
      case "operation-not-allowed":
        print("Anonymous auth hasn't been enabled for this project.");
        break;
      default:
        print("Unknown error.");
    }
  }
}

Future lineLogin() async {
  LineSDK.instance.setup("${1657807795}").then((_) {
    print("LineSDK Prepared");
  });
  try {
    final result = await LineSDK.instance
        .login(scopes: ["profile", "openid", "email"]).then((value) async {
      final user = await LineSDK.instance.getProfile();
      print(user.displayName);
      print(user.toString());
    });
  } on PlatformException catch (e) {
    print(e);
  }
}

Future emailandpasswordLogin() async {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  firebaseAuth
      .signInWithEmailAndPassword(
          email: "testuser@gmail.com", password: "123456")
      .then((value) {
    print("login succeed");
    var user = FirebaseAuth.instance.currentUser!;
    print("email: ${user.email}");
  });
}
