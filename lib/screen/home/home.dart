import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'cardType.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

final user = FirebaseAuth.instance.currentUser;

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late User? _currentUser;
  late AnimationController _animationController;
  late Animation<double> _animation;
  int _swipedCardIndex = -1;

  @override
  void initState() {
    super.initState();
    checkCurrentUser();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );
    _animation = Tween<double>(begin: 0, end: 1).animate(_animationController);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
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
    Navigator.pushNamedAndRemoveUntil(context, "/auth", (route) => false);
  }

  void addCard() {
    print("card Added");
    Navigator.pushNamed(context, '/addCard');
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
    Navigator.pop(context, '/auth');
  }

  void flipCard(int index) {
    if (_swipedCardIndex == index) {
      _animationController.reverse();
      _swipedCardIndex = -1;
    } else {
      _animationController.forward();
      _swipedCardIndex = index;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.green,
          leading: Icon(Icons.credit_card),
          title: Text("KERD"),
          actions: [
            IconButton(
              onPressed: usrLogout,
              icon: Icon(Icons.exit_to_app),
            ),
          ]),
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
                if (_currentUser != null) {
                  if (cardData['user'] == user!.email) {
                    String cardType = getCardType(cardData['cardNumber']);
                    return GestureDetector(
                      onHorizontalDragEnd: (details) {
                        if (details.primaryVelocity! < 0) {
                          flipCard(index);
                        }
                      },
                      onLongPress: () {
                        showDialog(
                          context: context,
                          builder: (_) => AlertDialog(
                            title: Text("Card Options"),
                            actions: [
                              ElevatedButton(
                                  style: ButtonStyle(
                                      backgroundColor: MaterialStatePropertyAll(
                                          Colors.green)),
                                  onPressed: () {
                                    flipCard(index);
                                    Navigator.pop(context);
                                  },
                                  child: Text("Swipe")),
                              ElevatedButton(
                                  style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStatePropertyAll(Colors.red)),
                                  onPressed: () {
                                    cardDelete(cardData.id);
                                    Navigator.pop(context);
                                  },
                                  child: Text("Delete")),
                              ElevatedButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                    Navigator.pushNamed(context, "/editCard",
                                        arguments: {
                                          "cardName": cardData['cardName'],
                                          "cardCvv": cardData['cardCvv'],
                                          "cardExp": cardData['cardExp'],
                                          "cardHolder": cardData['cardHolder'],
                                          "cardNumber": cardData['cardNumber'],
                                          "cardPin": cardData['cardPin'],
                                          "UId": cardData.id,
                                        });
                                  },
                                  child: Text("Edit")),
                            ],
                          ),
                        );
                      },
                      child: AnimatedBuilder(
                        animation: _animation,
                        builder: (context, child) {
                          final value = _animation.value;
                          final frontOpacity =
                              _swipedCardIndex == index ? 1.0 - value : 1.0;
                          final backOpacity =
                              _swipedCardIndex == index ? value : 0.0;
                          return Container(
                            padding: const EdgeInsets.all(10.0),
                            child: Stack(
                              children: [
                                Opacity(
                                  opacity: frontOpacity,
                                  child: buildFrontCard(cardData, cardType),
                                ),
                                Opacity(
                                  opacity: backOpacity,
                                  child: buildBackCard(cardData),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    );
                  }
                }
                return Container();
              },
            );
          }
          return Container();
        },
      ),
    );
  }

  Widget buildFrontCard(cardData, cardType) {
    return Container(
      decoration: ShapeDecoration(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        gradient: const LinearGradient(
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
                          copyContent(cardData['cardHolder']);
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
                crossAxisAlignment: CrossAxisAlignment.start,
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
    );
  }

  Widget buildBackCard(cardData) {
    return AnimatedOpacity(
      opacity: _swipedCardIndex >= 0 ? 1.0 : 0.0,
      duration: Duration(milliseconds: 500),
      child: Container(
        decoration: ShapeDecoration(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          gradient: LinearGradient(
            colors: [
              const Color(0xfff38381),
              const Color(0xfffcdf8a),
            ],
            begin: const FractionalOffset(0.0, 0.0),
            end: const FractionalOffset(1.0, 0.0),
            stops: [0.0, 1.0],
            tileMode: TileMode.clamp,
          ),
        ),
        padding: EdgeInsets.only(top: 20),
        width: 400,
        height: 220,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 40,
              color: Colors.black,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 16, right: 16, top: 16),
              child: Row(
                children: [
                  Text(
                    "CVV : " + cardData['cardCvv'],
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      copyContent(cardData['cardCvv']);
                    },
                    icon: Icon(Icons.copy),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 16, right: 16),
              child: Row(
                children: [
                  Text(
                    "PIN : " + cardData['cardPin'],
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      copyContent(cardData['cardPin']);
                    },
                    icon: Icon(Icons.copy),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
