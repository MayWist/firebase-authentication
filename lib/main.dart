import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:test_firebase_autu/page/Login.dart';
import 'package:test_firebase_autu/page/phonelogin.dart';
import 'package:test_firebase_autu/page/profile.dart';
import 'package:test_firebase_autu/provider/Authentication.dart';
import 'package:test_firebase_autu/routes/navigate%20.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  // runApp(const MyApp());

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => Authentication()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Test Friebase Auth",
      theme: ThemeData.dark(),
      home: Login(),
      routes: Navigate.routes,
    );
  }
}
