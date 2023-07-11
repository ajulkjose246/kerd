import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kerd/screen/home/addCard.dart';
import 'package:kerd/screen/home/cardType.dart';
import 'package:fluttertoast/fluttertoast.dart';

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

  void copyContent(String content) {
    Clipboard.setData(ClipboardData(text: content));
    Fluttertoast.showToast(
      msg: "Copied to clipboard",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.green,
      textColor: Colors.white,
      fontSize: 10.0,
    );
  }

  final CollectionReference cards =
      FirebaseFirestore.instance.collection("cards");

  void cardDelete(id) {
    cards.doc(id).delete();
    Navigator.pushNamed(context, '/auth');
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
                  return GestureDetector(
                    onLongPress: () {
                      showDialog(
                        context: context,
                        builder: (_) => AlertDialog(
                          title: Text("Card Options"),
                          // content: Text("Long press options for the card"),
                          actions: [
                            ElevatedButton(
                                style: ButtonStyle(
                                    backgroundColor:
                                        MaterialStatePropertyAll(Colors.red)),
                                onPressed: () {
                                  cardDelete(cardData.id);
                                },
                                child: Text("Delete")),
                            // ElevatedButton(
                            //     onPressed: () {}, child: Text("Edit")),
                          ],
                        ),
                      );
                    },
                    child: Container(
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
                              tileMode: TileMode.clamp,
                            ),
                          ),
                          padding: EdgeInsets.all(16),
                          width: 400,
                          height: 220,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
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
                                    style:
                                        TextStyle(fontWeight: FontWeight.w500),
                                  )
                                ],
                              ),
                              SizedBox(height: 1),
                              Image.network(
                                height: 50, // Set the desired height
                                "https://firebasestorage.googleapis.com/v0/b/kerd-app.appspot.com/o/atm.png?alt=media&token=5f37b555-00ff-42a6-830a-5379f1fb4538",
                              ),
                              Row(
                                children: [
                                  Text(
                                    cardData['cardNumber'],
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      copyContent(cardData['cardNumber']);
                                    },
                                    icon: Icon(
                                      Icons.copy,
                                      size: 25,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 1),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Cardholder Name',
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.grey,
                                        ),
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            cardData['cardHolder'],
                                            style: TextStyle(
                                              fontSize: 16,
                                            ),
                                          ),
                                          IconButton(
                                            onPressed: () {
                                              copyContent(
                                                  cardData['cardHolder']);
                                            },
                                            icon: Icon(
                                              Icons.copy,
                                              size: 20,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Expiry Date',
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.grey,
                                        ),
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            cardData['cardExp'],
                                            style: TextStyle(
                                              fontSize: 16,
                                            ),
                                          ),
                                          IconButton(
                                            onPressed: () {
                                              copyContent(cardData['cardExp']);
                                            },
                                            icon: Icon(
                                              Icons.copy,
                                              size: 20,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
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
