import 'package:firebase_core/firebase_core.dart';
import 'package:firebasematerial/view/contact.dart';
import 'package:firebasematerial/view/dashboard.dart';
import 'package:firebasematerial/view/home.dart';
import 'package:firebasematerial/view/login.dart';
import 'package:firebasematerial/view/register.dart';
import 'package:flutter/material.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Firebasematerial',
      initialRoute: '/',
      routes: {
        '/': (context) => const Home(),
        '/register': (context) => Register(),
        '/login': (context) => Login(),
        '/dashboard': (context) => const Dashboard(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}
