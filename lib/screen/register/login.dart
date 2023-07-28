import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:quickalert/quickalert.dart';

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
          // ignore: use_build_context_synchronously
          QuickAlert.show(
            context: context,
            type: QuickAlertType.success,
            text: 'Login Successfull!',
          ).then((value) {
            Navigator.pushNamedAndRemoveUntil(
                context, "/auth", (route) => false);
          });
        } else {
          // ignore: use_build_context_synchronously
          QuickAlert.show(
            context: context,
            type: QuickAlertType.error,
            text: 'Login Failed!',
          );
        }
      } on FirebaseAuthException catch (e) {
        if (e.code == 'user-not-found') {
          QuickAlert.show(
            context: context,
            type: QuickAlertType.error,
            text: 'User not flund',
          );
        } else {
          QuickAlert.show(
            context: context,
            type: QuickAlertType.error,
            text: "Login error: ${e.code}",
          );
        }
      } catch (e) {
        QuickAlert.show(
          context: context,
          type: QuickAlertType.error,
          text: "Login error: $e'",
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
