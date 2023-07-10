import 'package:flutter/material.dart';

class addCardScreen extends StatefulWidget {
  const addCardScreen({super.key});

  @override
  State<addCardScreen> createState() => _addCardScreenState();
}

class _addCardScreenState extends State<addCardScreen> {
  @override
  Widget build(BuildContext context) {
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
          padding: const EdgeInsets.all(15),
          child: TextField(
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
          padding: const EdgeInsets.all(15),
          child: TextField(
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
          padding: const EdgeInsets.all(15),
          child: TextField(
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
          padding: const EdgeInsets.all(15.0),
          child: ElevatedButton(
            onPressed: () {},
            child: Text("Add Card"),
            style: ButtonStyle(
                backgroundColor: MaterialStatePropertyAll(Colors.green)),
          ),
        )
      ]),
    );
  }
}
