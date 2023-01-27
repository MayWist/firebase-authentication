import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart' as fbauth;
import 'package:flutter_line_sdk/flutter_line_sdk.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginViewModel extends ChangeNotifier {
  FirebaseAuth auth = FirebaseAuth.instance;
  final googleSignIn = GoogleSignIn(
    scopes: [
      'email',
      'https://www.googleapis.com/auth/contacts.readonly',
    ],
  );
  bool _otpVisibility = false;
  String _verificationID = "";
  String _logintype = "";
  var _userdata = null;

  bool get otpVisibility => _otpVisibility;
  String get verificationID => _verificationID;
  String get logintype => _logintype;
  get userdata => _userdata.toString();

  set otpVisibility(bool otpVisibility) {
    _otpVisibility = otpVisibility;
  }

  set verificationID(String verificationID) {
    _verificationID = verificationID;
  }

  set logintype(String logintype) {
    _logintype = logintype;
  }

  set userdata(userdata) {
    _userdata = userdata;
  }

  Future googleLogin(context) async {
    GoogleSignInAccount? userdata;
    final googleUser = await googleSignIn.signIn();
    if (googleUser == null) return;
    userdata = googleUser;

    final googleAuth = await googleUser.authentication;

    final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken, idToken: googleAuth.idToken);

    await FirebaseAuth.instance.signInWithCredential(credential);
    logintype = "google";
    notifyListeners();
    NavToProfile(context);
  }

  Future facebookLogin(context) async {
    try {
      final fbauth.LoginResult loginResult =
          await fbauth.FacebookAuth.instance.login();

      final OAuthCredential facebookAuthCredential =
          FacebookAuthProvider.credential(loginResult.accessToken!.token);
      await FirebaseAuth.instance.signInWithCredential(facebookAuthCredential);
      logintype = "facebook";
      userdata = await fbauth.FacebookAuth.instance.getUserData();
      ;
      notifyListeners();
      NavToProfile(context);
    } on FirebaseException catch (e) {
      print(e);
    }
  }

  Future anonymousLogin(context) async {
    try {
      logintype = "anonymous";
      userdata = await FirebaseAuth.instance.signInAnonymously();
      notifyListeners();
      NavToProfile(context);
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
    await LineSDK.instance.setup("${1657807795}");
    try {
      final result = await LineSDK.instance
          .login(scopes: ["profile", "openid", "email"]).then((value) async {
        logintype = "line";
        userdata = await LineSDK.instance.getProfile();
        notifyListeners();
        NavToProfile(context);
      });
    } on PlatformException catch (e) {
      print(e);
    }
  }

  Future emailandpasswordLogin(context) async {
    final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    await firebaseAuth.signInWithEmailAndPassword(
        email: "testuser@gmail.com", password: "123456");

    logintype = "email";
    userdata = FirebaseAuth.instance.currentUser!;
    notifyListeners();
    NavToProfile(context);
  }

  Future loginWithPhone(phone_number) async {
    auth.verifyPhoneNumber(
      phoneNumber: phone_number,
      verificationCompleted: (PhoneAuthCredential credential) {},
      verificationFailed: (FirebaseAuthException e) {
        print(e.message);
      },
      codeSent: (String verificationId, int? resendToken) {
        otpVisibility = true;
        verificationID = verificationId;
        notifyListeners();
      },
      codeAutoRetrievalTimeout: (String verificationId) {},
    );
  }

  Future verifyOTP(context, otp) async {
    PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationID, smsCode: otp);

    var user = await auth.signInWithCredential(credential);
    print("login in successfully verificationCompleted");
    logintype = "phone";
    userdata = user;
    notifyListeners();
    NavToProfile(context);
  }

  Future signOut(context) async {
    switch (logintype) {
      case "google":
        await FirebaseAuth.instance.signOut();
        await googleSignIn.disconnect();
        break;
      case "facebook":
        await FirebaseAuth.instance.signOut();
        await fbauth.FacebookAuth.instance.logOut();
        break;
      case "line":
        LineSDK.instance.setup("${1657807795}");
        await LineSDK.instance.logout();
        break;
      case "phone":
        await FirebaseAuth.instance.signOut();
        break;
      case "email":
        await FirebaseAuth.instance.signOut();
        break;
      case "anonymous":
        await FirebaseAuth.instance.signOut();
        break;
      default:
        await FirebaseAuth.instance.signOut();
    }
    notifyListeners();
    Navigator.pushNamedAndRemoveUntil(context, "/Profile", (route) => false);
  }

  void NavToProfile(context) {
    Navigator.pushNamedAndRemoveUntil(context, "/Profile", (route) => false);
  }
}
