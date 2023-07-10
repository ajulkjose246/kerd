import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late User? _currentUser;

  @override
  Widget build(BuildContext context) {
    void checkCurrentUser() {
      User? user = FirebaseAuth.instance.currentUser;
      setState(() {
        _currentUser = user;
      });
    }

    setState(() {
      checkCurrentUser();
    });

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
          onPressed: () {
            addCard();
          },
          child: Icon(Icons.add_card),
          backgroundColor: Colors.green,
          shape: CircleBorder(side: BorderSide(width: 2)),
        ),
        body: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Container(
                  padding: EdgeInsets.all(16),
                  width: 300,
                  height: 180,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Card Number',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          Icon(
                            Icons.credit_card,
                            size: 32,
                          ),
                        ],
                      ),
                      SizedBox(height: 16),
                      Text(
                        '1234 5678 9012 3456',
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
                                'John Doe',
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
                                '12/24',
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
            )
          ],
        ));
  }
}
