import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:provider/provider.dart';
import 'package:test_firebase_autu/routes/navigate%20.dart';
import 'package:test_firebase_autu/view/login/login.dart';
import 'package:test_firebase_autu/viewmodel/login_viewmodel.dart';

//pring red line flutter
Future main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  await Firebase.initializeApp();
  FlutterNativeSplash.remove();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LoginViewModel()),
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
