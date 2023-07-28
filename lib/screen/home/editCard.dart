import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:quickalert/quickalert.dart';

class editCardScreen extends StatefulWidget {
  const editCardScreen({super.key});

  @override
  State<editCardScreen> createState() => _editCardScreenState();
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

class _editCardScreenState extends State<editCardScreen> {
  @override
  Widget build(BuildContext context) {
    final argu = ModalRoute.of(context)!.settings.arguments as Map;
    cardNumber.text = argu['cardNumber'];
    cardName.text = argu['cardName'];
    cardHolder.text = argu['cardHolder'];
    cardExp.text = argu['cardExp'];
    cardPin.text = argu['cardPin'];
    cardCvv.text = argu['cardCvv'];

    final uid = argu['UId'];

    void editCard(UId) {
      final data = {
        'cardExp': cardExp.text,
        'cardName': cardName.text,
        'cardHolder': cardHolder.text,
        'cardNumber': cardNumber.text,
        'cardPin': cardPin.text,
        'cardCvv': cardCvv.text,
        'user': user!.email,
      };
      cards.doc(UId).update(data).then((_) {
        // Insertion successful
        print('Data inserted successfully');
        QuickAlert.show(
          context: context,
          type: QuickAlertType.success,
          text: "Card Edited successful",
        ).then((value) {
          Navigator.pushNamedAndRemoveUntil(context, "/", (route) => false);
        });
      }).catchError((error) {
        // Insertion failed
        print('Error inserting data: $error');
        QuickAlert.show(
          context: context,
          type: QuickAlertType.error,
          text: "Card Edited Failed",
        );
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
              editCard(uid);
            },
            child: Text("Update Card"),
            style: ButtonStyle(
                backgroundColor: MaterialStatePropertyAll(Colors.green)),
          ),
        ),
      ]),
    );
  }
}
