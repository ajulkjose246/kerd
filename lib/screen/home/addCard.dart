import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';

class addCardScreen extends StatefulWidget {
  const addCardScreen({super.key});

  @override
  State<addCardScreen> createState() => _addCardScreenState();
}

final user = FirebaseAuth.instance.currentUser;
final CollectionReference cards =
    FirebaseFirestore.instance.collection("cards");
TextEditingController cardNumber = TextEditingController();
TextEditingController cardName = TextEditingController();
TextEditingController cardHolder = TextEditingController();
TextEditingController cardExp = TextEditingController();
TextEditingController cardPin = TextEditingController();
TextEditingController cardCvv = TextEditingController();

class _addCardScreenState extends State<addCardScreen> {
  @override
  Widget build(BuildContext context) {
    void addCard() {
      final data = {
        'cardExp': cardExp.text,
        'cardName': cardName.text,
        'cardHolder': cardHolder.text,
        'cardNumber': cardNumber.text,
        'cardPin': cardPin.text,
        'cardCvv': cardCvv.text,
        'user': user!.email,
      };
      cards.add(data).then((_) {
        // Insertion successful
        print('Data inserted successfully');
        Fluttertoast.showToast(
            msg: "Card Added successful",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.green,
            textColor: Colors.white,
            fontSize: 10.0);
        Navigator.pushNamed(context, '/auth');
      }).catchError((error) {
        // Insertion failed
        print('Error inserting data: $error');
        Fluttertoast.showToast(
            msg: "Card Added Failed",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 10.0);
      });
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text("Add Card"),
      ),
      body: ListView(children: [
        Center(
            child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Text(
            "Enter Card Details",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
          ),
        )),
        Padding(
          padding: const EdgeInsets.all(10),
          child: TextField(
            controller: cardName,
            keyboardType: TextInputType.text,
            decoration: const InputDecoration(
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                    width: 2,
                    color: Colors.green), // Replace with your desired color
              ),
              labelText: 'Card Name',
              labelStyle: TextStyle(color: Colors.green),
              border: OutlineInputBorder(),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(10),
          child: TextField(
            controller: cardNumber,
            keyboardType: TextInputType.number,
            maxLength: 16,
            decoration: const InputDecoration(
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                    width: 2,
                    color: Colors.green), // Replace with your desired color
              ),
              labelText: 'Card Number',
              labelStyle: TextStyle(color: Colors.green),
              border: OutlineInputBorder(),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(10),
          child: TextField(
            controller: cardHolder,
            keyboardType: TextInputType.text,
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z ]')),
            ],
            decoration: const InputDecoration(
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                    width: 2,
                    color: Colors.green), // Replace with your desired color
              ),
              labelText: 'Cardholder Name',
              labelStyle: TextStyle(color: Colors.green),
              border: OutlineInputBorder(),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(10),
          child: TextField(
            controller: cardExp,
            keyboardType: TextInputType.datetime,
            decoration: const InputDecoration(
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                    width: 2,
                    color: Colors.green), // Replace with your desired color
              ),
              labelText: 'Expiry Date',
              labelStyle: TextStyle(color: Colors.green),
              border: OutlineInputBorder(),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(10),
          child: TextField(
            controller: cardPin,
            keyboardType: TextInputType.number,
            maxLength: 6,
            decoration: const InputDecoration(
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                    width: 2,
                    color: Colors.green), // Replace with your desired color
              ),
              labelText: 'Card Pin',
              labelStyle: TextStyle(color: Colors.green),
              border: OutlineInputBorder(),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(10),
          child: TextField(
            controller: cardCvv,
            keyboardType: TextInputType.number,
            maxLength: 4,
            decoration: const InputDecoration(
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                    width: 2,
                    color: Colors.green), // Replace with your desired color
              ),
              labelText: 'CVV',
              labelStyle: TextStyle(color: Colors.green),
              border: OutlineInputBorder(),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(15.0),
          child: ElevatedButton(
            onPressed: () {
              addCard();
            },
            child: Text("Add Card"),
            style: ButtonStyle(
                backgroundColor: MaterialStatePropertyAll(Colors.green)),
          ),
        ),
      ]),
    );
  }
}
