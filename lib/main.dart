import 'package:flutter/material.dart';
import 'package:kerd/screen/register/login.dart';
import 'package:kerd/screen/register/register.dart';

void main() {
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
        "/": (context) => loginScreen(),
        "/register": (context) => registerScreen(),
      },
    );
  }
}
