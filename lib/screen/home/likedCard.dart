import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'cardType.dart';

class likedScreen extends StatefulWidget {
  const likedScreen({Key? key}) : super(key: key);

  @override
  State<likedScreen> createState() => _likedScreenState();
}

final user = FirebaseAuth.instance.currentUser;

class _likedScreenState extends State<likedScreen>
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

  void usrLogout() async {
    FirebaseAuth.instance.signOut();
    await clearUserData(); // Call a function to clear user data from Firestore
    checkCurrentUser();
    Navigator.pushNamedAndRemoveUntil(context, "/auth", (route) => false);
  }

// Function to clear user data from Firestore
  Future<void> clearUserData() async {
    try {
      User? currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser != null) {
        // Get a reference to the Firestore collection for user's cards
        CollectionReference userCards =
            FirebaseFirestore.instance.collection("cards");

        // Query and delete all documents where the 'user' field matches the current user's email
        QuerySnapshot snapshot =
            await userCards.where("user", isEqualTo: currentUser.email).get();
        for (DocumentSnapshot doc in snapshot.docs) {
          await doc.reference.delete();
        }
      }
    } catch (e) {
      print("Error clearing user data: $e");
      // Handle any errors that occur during the data clearing process
    }
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

  final CollectionReference likedCards =
      FirebaseFirestore.instance.collection("likedCards");

  void cardDelete(id) {
    cards.doc(id).delete();
    Navigator.pop(context, '/auth');
  }

  Future<void> likeCard(String cardId) async {
    final currentUserEmail = user!.email;
    final querySnapshot = await FirebaseFirestore.instance
        .collection('likedCards')
        .where('cardId', isEqualTo: cardId)
        .where('userId', isEqualTo: currentUserEmail)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      // Card is already liked, so remove it
      final likedCardId = querySnapshot.docs.first.id;
      await FirebaseFirestore.instance
          .collection('likedCards')
          .doc(likedCardId)
          .delete();
    } else {
      // Card is not liked, so add it
      final data = {
        'cardId': cardId,
        'userId': currentUserEmail,
      };
      await FirebaseFirestore.instance.collection('likedCards').add(data);
    }
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
    return StreamBuilder<QuerySnapshot>(
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
                  return StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection("likedCards")
                        .where('cardId', isEqualTo: cardData.id)
                        .where('userId', isEqualTo: user!.email)
                        .snapshots(),
                    builder: (context, likedSnapshot) {
                      if (likedSnapshot.hasData &&
                          likedSnapshot.data!.docs.isNotEmpty) {
                        return GestureDetector(
                          onHorizontalDragEnd: (details) {
                            if (_swipedCardIndex == -1) {
                              if (details.primaryVelocity! < 0) {
                                flipCard(index);
                              }
                            } else {
                              if (details.primaryVelocity! > 0) {
                                flipCard(index);
                              }
                            }
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
                      } else {
                        // Card is not liked, so don't show it
                        return Container();
                      }
                    },
                  );
                }
              }
              return Container();
            },
          );
        }
        return Container();
      },
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
            Color.fromARGB(255, 38, 38, 38),
            Color.fromARGB(255, 9, 9, 9),
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
                    color: Colors.white),
              ),
              Text(
                cardType,
                style:
                    TextStyle(fontWeight: FontWeight.w500, color: Colors.white),
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
                    color: Colors.white),
              ),
              IconButton(
                onPressed: () {
                  copyContent(cardData['cardNumber']);
                },
                icon: Icon(Icons.copy, size: 25, color: Colors.white),
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
                    style: TextStyle(fontSize: 14, color: Colors.white),
                  ),
                  Row(
                    children: [
                      Text(
                        cardData['cardHolder'],
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                      IconButton(
                        onPressed: () {
                          copyContent(cardData['cardHolder']);
                        },
                        icon: Icon(Icons.copy, size: 20, color: Colors.white),
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
                    style: TextStyle(fontSize: 14, color: Colors.white),
                  ),
                  Row(
                    children: [
                      Text(
                        cardData['cardExp'],
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                      IconButton(
                        onPressed: () {
                          copyContent(cardData['cardExp']);
                        },
                        icon: Icon(Icons.copy, size: 20, color: Colors.white),
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
              Color.fromARGB(255, 33, 30, 30),
              Color.fromARGB(255, 9, 9, 9),
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
              color: Colors.white,
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
                        color: Colors.white),
                  ),
                  IconButton(
                    onPressed: () {
                      copyContent(cardData['cardCvv']);
                    },
                    icon: Icon(Icons.copy, color: Colors.white),
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
                        color: Colors.white),
                  ),
                  IconButton(
                    onPressed: () {
                      copyContent(cardData['cardPin']);
                    },
                    icon: Icon(Icons.copy, color: Colors.white),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 16, right: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                      onPressed: () {
                        likeCard(cardData.id);
                      },
                      icon: Icon(
                        Icons.favorite,
                        color: Colors.red,
                      )),
                  IconButton(
                      onPressed: () {
                        Navigator.pushNamed(context, "/editCard", arguments: {
                          "cardName": cardData['cardName'],
                          "cardCvv": cardData['cardCvv'],
                          "cardExp": cardData['cardExp'],
                          "cardHolder": cardData['cardHolder'],
                          "cardNumber": cardData['cardNumber'],
                          "cardPin": cardData['cardPin'],
                          "UId": cardData.id,
                        });
                      },
                      icon: Icon(
                        Icons.edit,
                        color: Colors.blue,
                      )),
                  IconButton(
                      onPressed: () {
                        cardDelete(cardData.id);
                      },
                      icon: Icon(
                        Icons.delete,
                        color: Colors.red,
                      )),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
