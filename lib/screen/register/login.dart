import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class loginScreen extends StatefulWidget {
  const loginScreen({super.key});

  @override
  State<loginScreen> createState() => _loginScreenState();
}

class _loginScreenState extends State<loginScreen> {
  @override
  Widget build(BuildContext context) {
    TextEditingController usrEmail = TextEditingController();
    TextEditingController usrPwd = TextEditingController();
    void loginUser() async {
      try {
        UserCredential userCredential =
            await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: usrEmail.text,
          password: usrPwd.text,
        );

        // User login successful
        User? user = userCredential.user;
        if (user != null) {
          // Handle successful login
          Fluttertoast.showToast(
              msg: "Login successful",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.green,
              textColor: Colors.white,
              fontSize: 10.0);
        } else {
          // Handle unsuccessful login
          Fluttertoast.showToast(
              msg: "Login failed!",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.red,
              textColor: Colors.white,
              fontSize: 10.0);
        }
      } on FirebaseAuthException catch (e) {
        if (e.code == 'user-not-found') {
          // Handle user not found error
          Fluttertoast.showToast(
              msg: "User not found",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.red,
              textColor: Colors.white,
              fontSize: 10.0);
        } else {
          // Handle other FirebaseAuthException errors
          Fluttertoast.showToast(
              msg: "Login error: ${e.code}",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.red,
              textColor: Colors.white,
              fontSize: 10.0);
        }
      } catch (e) {
        // Handle other errors during login
        Fluttertoast.showToast(
            msg: "Login error: $e'",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 10.0);
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
                'Login Now',
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.w900),
              ),
            ),
            Image.network(
              "https://firebasestorage.googleapis.com/v0/b/kerd-app.appspot.com/o/Login.png?alt=media&token=ce759398-c685-4a68-9270-35c2a70c8a8f",
              height: 270,
            ),

            // const SizedBox(height: 30),
            TextField(
              controller: usrEmail,
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
              controller: usrPwd,
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
            ElevatedButton(
              style: ButtonStyle(
                  backgroundColor: MaterialStatePropertyAll(Colors.green)),
              onPressed: () {
                loginUser();
              },
              child: const Text('Login'),
            ),
            // const SizedBox(height: 5),
            TextButton(
              onPressed: () {
                // TODO: Implement forgot password logic here
              },
              child: const Text(
                'Forgot Password?',
                style: TextStyle(color: Colors.green),
              ),
            ),
            // const SizedBox(height: 5),
            TextButton(
              onPressed: () {
                Navigator.pushNamed(context, '/register');
              },
              child: const Text('Create New Account',
                  style: TextStyle(color: Colors.green)),
            ),
          ],
        ),
      ),
    );
  }
}
