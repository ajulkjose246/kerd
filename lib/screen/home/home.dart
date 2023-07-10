import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:kerd/screen/home/addCard.dart';
import 'package:kerd/screen/home/cardType.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late User? _currentUser;

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

  void usrLogout() {
    FirebaseAuth.instance.signOut();
    checkCurrentUser();
  }

  void addCard() {
    if (_currentUser != null) {
      print("card Added");
      Navigator.pushNamed(context, '/addCard');
    } else {
      Navigator.pushNamed(context, '/auth');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        leading: Icon(Icons.credit_card),
        title: Text("KERD"),
        actions: _currentUser != null
            ? [
                IconButton(
                  onPressed: usrLogout,
                  icon: Icon(Icons.exit_to_app),
                ),
              ]
            : [
                IconButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/auth');
                  },
                  icon: Icon(Icons.login),
                ),
              ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: addCard,
        child: Icon(Icons.add_card),
        backgroundColor: Colors.green,
        shape: CircleBorder(side: BorderSide(width: 2)),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection("cards").snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final cards = snapshot.data!.docs;
            return ListView.builder(
              itemCount: cards.length,
              itemBuilder: (context, index) {
                final cardData = cards[index];
                if (cardData['user'] == user!.email) {
                  String cardType = getCardType(cardData['cardNumber']);
                  return Container(
                    padding: const EdgeInsets.all(10.0),
                    child: Card(
                      color: Colors.orangeAccent,
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Container(
                        decoration: ShapeDecoration(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          gradient: LinearGradient(
                              colors: [
                                const Color(0xfffcdf8a),
                                const Color(0xfff38381),
                              ],
                              begin: const FractionalOffset(0.0, 0.0),
                              end: const FractionalOffset(1.0, 0.0),
                              stops: [0.0, 1.0],
                              tileMode: TileMode.clamp),
                        ),
                        padding: EdgeInsets.all(16),
                        width: 400,
                        height: 180,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  cardData['cardName'],
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                Text(
                                  cardType,
                                  style: TextStyle(fontWeight: FontWeight.w500),
                                )
                              ],
                            ),
                            SizedBox(height: 16),
                            Text(
                              cardData['cardNumber'],
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            ),
                            SizedBox(height: 16),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Cardholder Name',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey,
                                      ),
                                    ),
                                    Text(
                                      cardData['cardHolder'],
                                      style: TextStyle(
                                        fontSize: 16,
                                      ),
                                    ),
                                  ],
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Expiry Date',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey,
                                      ),
                                    ),
                                    Text(
                                      cardData['cardExp'],
                                      style: TextStyle(
                                        fontSize: 16,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }
              },
            );
          }
          return Container();
        },
      ),
    );
  }
}
