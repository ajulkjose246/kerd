import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class authScreen extends StatefulWidget {
  @override
  State<authScreen> createState() => _authScreenState();
}

class _authScreenState extends State<authScreen> {
  @override
  void initState() {
    super.initState();
    checkUser();
  }

  void checkUser() async {
    await Future.delayed(Duration(seconds: 5));
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      Navigator.pushNamedAndRemoveUntil(context, "/", (route) => false);
    } else {
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "KERD",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              "Downloading Data ....",
              style: TextStyle(fontSize: 15),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 10),
              child: CircularProgressIndicator(),
            )
          ],
        ),
      ),
    );
  }
}
