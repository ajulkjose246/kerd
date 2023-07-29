import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class profileScreen extends StatefulWidget {
  const profileScreen({super.key});

  @override
  State<profileScreen> createState() => _profileScreenState();
}

class _profileScreenState extends State<profileScreen> {
  late User? _currentUser;

  @override
  void initState() {
    super.initState();
    checkCurrentUser();
  }

  void usrLogout() async {
    FirebaseAuth.instance.signOut();
    await clearUserData();
    Navigator.pushNamedAndRemoveUntil(context, "/auth", (route) => false);
  }

  void checkCurrentUser() {
    User? user = FirebaseAuth.instance.currentUser;
    setState(() {
      _currentUser = user;
    });
  }

  Future<void> clearUserData() async {
    try {
      User? currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser != null) {
        CollectionReference userCards =
            FirebaseFirestore.instance.collection("cards");
        QuerySnapshot snapshot =
            await userCards.where("user", isEqualTo: currentUser.email).get();
        for (DocumentSnapshot doc in snapshot.docs) {
          await doc.reference.delete();
        }
      }
    } catch (e) {
      print("Error clearing user data: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16, left: 10, right: 10),
      child: Column(
        children: [
          Container(
            height: 140,
            width: double.infinity,
            decoration: ShapeDecoration(
              color: Color.fromRGBO(38, 38, 38, 1),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 10),
                  child: CircleAvatar(
                    radius: 40,
                    backgroundImage: NetworkImage(
                        "https://cdn2.iconfinder.com/data/icons/avatars-99/62/avatar-370-456322-512.png"),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 10),
                  child: Text(
                    _currentUser?.email ?? "",
                    style: TextStyle(color: Colors.white, fontSize: 17),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 15,
          ),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.red),
                  ),
                  onPressed: () {
                    usrLogout();
                  },
                  child: Text(
                    "Logout",
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
