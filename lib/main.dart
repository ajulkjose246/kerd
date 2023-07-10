import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:kerd/screen/home/addCard.dart';
import 'package:kerd/screen/home/home.dart';
import 'package:kerd/screen/register/auth.dart';
import 'package:kerd/screen/register/login.dart';
import 'package:kerd/screen/register/register.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(kerd());
}

class kerd extends StatefulWidget {
  const kerd({super.key});

  @override
  State<kerd> createState() => _kerdState();
}

class _kerdState extends State<kerd> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "KERD",
      routes: {
        "/": (context) => HomeScreen(),
        "/auth": (context) => authScreen(),
        "/login": (context) => loginScreen(),
        "/register": (context) => registerScreen(),
        "/addCard": (context) => addCardScreen(),
      },
      initialRoute: "/auth",
    );
  }
}
