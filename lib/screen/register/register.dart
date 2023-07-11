import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:kerd/screen/home/addCard.dart';

class registerScreen extends StatefulWidget {
  const registerScreen({super.key});

  @override
  State<registerScreen> createState() => _registerScreenState();
}

TextEditingController UEmail = TextEditingController();
TextEditingController UPwd = TextEditingController();
TextEditingController UCPwd = TextEditingController();

class _registerScreenState extends State<registerScreen> {
  @override
  Widget build(BuildContext context) {
    void createUser() async {
      if (UPwd.text == UCPwd.text) {
        try {
          UserCredential userCredential =
              await FirebaseAuth.instance.createUserWithEmailAndPassword(
            email: UEmail.text,
            password: UPwd.text,
          );

          // Registration successful
          User? user = userCredential.user;
          if (user != null) {
            // Handle successful registration
            Fluttertoast.showToast(
              msg: "Registration successful",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.green,
              textColor: Colors.white,
              fontSize: 10.0,
            );
            Navigator.pushNamed(context, '/auth');
          } else {
            // Handle unsuccessful registration
            Fluttertoast.showToast(
              msg: "Registration failed",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.red,
              textColor: Colors.white,
              fontSize: 10.0,
            );
          }
        } catch (e) {
          // Handle any errors that occurred during registration
          String errorMessage = "Registration error";

          // Check the specific error type and customize the error message accordingly
          if (e is FirebaseAuthException) {
            switch (e.code) {
              case 'email-already-in-use':
                errorMessage = "Email already in use";
                break;
              case 'weak-password':
                errorMessage = "Weak password";
                break;
              // Add more cases for other error codes if needed
            }
          }

          Fluttertoast.showToast(
            msg: errorMessage,
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 10.0,
          );
        }
      } else {
        Fluttertoast.showToast(
          msg: "Passwords do not match",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 10.0,
        );
      }
    }

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: ListView(
          children: [
            // const SizedBox(height: 10),
            const Center(
              child: Text(
                'Register Now',
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.w900),
              ),
            ),
            Image.network(
              "https://firebasestorage.googleapis.com/v0/b/kerd-app.appspot.com/o/register.png?alt=media&token=67c6243e-f4e5-446a-a05c-cd97f8df6531",
              // width: 10,
              height: 270,
            ),
            // const SizedBox(height: 30),
            TextField(
              controller: UEmail,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                      width: 2,
                      color: Colors.green), // Replace with your desired color
                ),
                labelText: 'Email Id',
                labelStyle: TextStyle(color: Colors.green),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: UPwd,
              keyboardType: TextInputType.visiblePassword,
              decoration: const InputDecoration(
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                      width: 2,
                      color: Colors.green), // Replace with your desired color
                ),
                labelText: 'Password',
                labelStyle: TextStyle(color: Colors.green),
                border: OutlineInputBorder(),
              ),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            TextField(
              controller: UCPwd,
              keyboardType: TextInputType.visiblePassword,
              decoration: InputDecoration(
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                      width: 2,
                      color: Colors.green), // Replace with your desired color
                ),
                labelText: 'Confirm Password',
                labelStyle: TextStyle(color: Colors.green),
                border: OutlineInputBorder(),
              ),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ButtonStyle(
                  backgroundColor: MaterialStatePropertyAll(Colors.green)),
              onPressed: () {
                createUser();
              },
              child: const Text('SignUp'),
            ),
            // const SizedBox(height: 5),
            TextButton(
              onPressed: () {
                Navigator.pushNamed(context, '/login');
              },
              child: const Text(
                'Already have an account?',
                style: TextStyle(color: Colors.green),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
