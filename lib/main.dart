import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:medical_book/LoginScreen.dart';
import 'package:medical_book/firebase_options.dart';

import 'HomePage.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginPage(),
    );
  }
}

