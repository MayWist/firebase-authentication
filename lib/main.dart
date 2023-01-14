import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart' as fbauth;
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_line_sdk/flutter_line_sdk.dart';
import 'package:test_firebase_autu/phonelogin.dart';
import 'package:test_firebase_autu/profile.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ElevatedButton(
                onPressed: () {
                  emailandpasswordLogin(context);
                },
                child: Text("email/password")),
            ElevatedButton(
                onPressed: () {
                  googleLogin(context);
                },
                child: Text("Google")),
            ElevatedButton(
                onPressed: () {
                  facebookLogin(context);
                },
                child: Text("Facebook")),
            // ElevatedButton(
            //     onPressed: () {
            //       twitterLoging(context);
            //     },
            //     child: Text("Twitter")),
            ElevatedButton(
                onPressed: () {
                  lineLogin(context);
                },
                child: Text("Line")),
            ElevatedButton(
                onPressed: () {
                  anonymousLogin(context);
                },
                child: Text("Anonymous")),
            ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => LoginWithPhone()));
                },
                child: Text("Phone")),
          ],
        ),
      ),
    );
  }
}
//wait for api key
// Future twitterLoging(context) async {
// }

Future googleLogin(context) async {
  final googleSignIn = GoogleSignIn();
  GoogleSignInAccount? userdata;
  final googleUser = await googleSignIn.signIn();
  if (googleUser == null) return;
  userdata = googleUser;

  final googleAuth = await googleUser.authentication;

  final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken, idToken: googleAuth.idToken);

  await FirebaseAuth.instance.signInWithCredential(credential).then((value) {
    gotoprofile(context, userdata);
  });
}

Future facebookLogin(context) async {
  try {
    final fbauth.LoginResult loginResult =
        await fbauth.FacebookAuth.instance.login();
    final userdata = await fbauth.FacebookAuth.instance.getUserData();
    final OAuthCredential facebookAuthCredential =
        FacebookAuthProvider.credential(loginResult.accessToken!.token);
    await FirebaseAuth.instance.signInWithCredential(facebookAuthCredential);
    gotoprofile(context, userdata);
  } on FirebaseException catch (e) {
    print(e);
  }
}

Future anonymousLogin(context) async {
  try {
    final userCredential = await FirebaseAuth.instance.signInAnonymously();
    print("Signed in with temporary account.");
    gotoprofile(context, userCredential);
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

Future lineLogin(context) async {
  LineSDK.instance.setup("${1657807795}").then((_) {
    print("LineSDK Prepared");
  });
  try {
    final result = await LineSDK.instance
        .login(scopes: ["profile", "openid", "email"]).then((value) async {
      final user = await LineSDK.instance.getProfile();
      var userdata = user.displayName + "/" + user.userId;
      gotoprofile(context, userdata);
    });
  } on PlatformException catch (e) {
    print(e);
  }
}

Future emailandpasswordLogin(context) async {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  firebaseAuth
      .signInWithEmailAndPassword(
          email: "testuser@gmail.com", password: "123456")
      .then((value) {
    print("login succeed");
    var userdata = FirebaseAuth.instance.currentUser!;
    gotoprofile(context, userdata);
  });
}

gotoprofile(context, user) {
  Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => Profile(
            user: user,
          )));
}