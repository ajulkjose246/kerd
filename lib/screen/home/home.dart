import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:kerd/screen/home/likedCard.dart';
import 'package:kerd/screen/home/listcard.dart';
import 'package:kerd/screen/home/profile.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

final user = FirebaseAuth.instance.currentUser;

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late User? _currentUser;
  var _currentIndex = 0;

  List homeScreens = const [
    listScreen(),
    likedScreen(),
    profileScreen(),
  ];

  @override
  void initState() {
    super.initState();
    checkCurrentUser();
  }

  void checkCurrentUser() {
    User? user = FirebaseAuth.instance.currentUser;
    setState(() {
      _currentUser = user;
    });
  }

  void addCard() {
    print("card Added");
    Navigator.pushNamed(context, '/addCard');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(230, 234, 237, 1),
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(38, 38, 38, 1),
        leading: Icon(Icons.credit_card),
        title: Text("KERD"),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(10), // You can adjust the radius here
          ),
        ),
      ),
      floatingActionButton: (_currentIndex == 0)
          ? FloatingActionButton(
              onPressed: addCard,
              child: Icon(Icons.add_card),
              backgroundColor: Color.fromRGBO(38, 38, 38, 1),
              shape: const CircleBorder(side: BorderSide(width: 2)),
            )
          : Container(),
      body: homeScreens.elementAt(_currentIndex),
      bottomNavigationBar: SalomonBottomBar(
        // backgroundColor: Color.fromRGBO(38, 38, 38, 1),
        backgroundColor: Colors.white,
        currentIndex: _currentIndex,

        onTap: (i) => setState(() => _currentIndex = i),
        items: [
          /// Home
          SalomonBottomBarItem(
            icon: Icon(Icons.home),
            title: Text("Home"),
            selectedColor: Colors.purple,
          ),

          /// Likes
          SalomonBottomBarItem(
            icon: Icon(Icons.favorite_border),
            title: Text("Liked"),
            selectedColor: Colors.pink,
          ),

          /// Profile
          SalomonBottomBarItem(
            icon: Icon(Icons.person),
            title: Text("Profile"),
            selectedColor: Colors.teal,
          ),
        ],
      ),
    );
  }
}
