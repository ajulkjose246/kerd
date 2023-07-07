import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    void usrLogout() {
      FirebaseAuth.instance.signOut();
      final user = FirebaseAuth.instance.currentUser!;
      if (user.email!.isEmpty) {
        Navigator.pushNamed(context, '/auth');
      }
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        leading: Icon(Icons.credit_card),
        title: Text("KERD"),
        actions: [
          IconButton(
              onPressed: () {
                usrLogout();
              },
              icon: Icon(Icons.exit_to_app))
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: Icon(Icons.add_card),
        backgroundColor: Colors.green,
        shape: CircleBorder(side: BorderSide(width: 2)),
      ),
    );
  }
}
