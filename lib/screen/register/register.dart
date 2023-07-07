import 'package:flutter/material.dart';

class registerScreen extends StatefulWidget {
  const registerScreen({super.key});

  @override
  State<registerScreen> createState() => _registerScreenState();
}

class _registerScreenState extends State<registerScreen> {
  @override
  Widget build(BuildContext context) {
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
            const TextField(
              // controller: _emailController,
              decoration: InputDecoration(
                labelText: 'Full Name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            const TextField(
              // controller: _emailController,
              decoration: InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            const TextField(
              // controller: _passwordController,
              decoration: InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(),
              ),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ButtonStyle(
                  backgroundColor: MaterialStatePropertyAll(Colors.green)),
              onPressed: () {
                // TODO: Perform login logic here
                // String email = _emailController.text;
                // String password = _passwordController.text;
                // Perform login validation or API call
              },
              child: const Text('SignUp'),
            ),
            // const SizedBox(height: 5),
            TextButton(
              onPressed: () {
                Navigator.pushNamed(context, '/');
              },
              child: const Text('Already have an account?'),
            ),
          ],
        ),
      ),
    );
  }
}
