import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:kerd/screen/home/home.dart';
import 'package:kerd/screen/register/login.dart';

class authScreen extends StatefulWidget {
  const authScreen({super.key});

  @override
  State<authScreen> createState() => _authScreenState();
}

class _authScreenState extends State<authScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return HomeScreen();
          } else {
            return loginScreen();
          }
        },
      ),
    );
  }
}
