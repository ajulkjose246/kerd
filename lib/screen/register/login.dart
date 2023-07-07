import 'package:flutter/material.dart';

class loginScreen extends StatefulWidget {
  const loginScreen({super.key});

  @override
  State<loginScreen> createState() => _loginScreenState();
}

class _loginScreenState extends State<loginScreen> {
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
                'Login Now',
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.w900),
              ),
            ),
            Image.network(
                "https://firebasestorage.googleapis.com/v0/b/kerd-app.appspot.com/o/Login.png?alt=media&token=ce759398-c685-4a68-9270-35c2a70c8a8f"),
            // const SizedBox(height: 30),
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
              child: const Text('Login'),
            ),
            // const SizedBox(height: 5),
            TextButton(
              onPressed: () {
                // TODO: Implement forgot password logic here
              },
              child: const Text('Forgot Password?'),
            ),
            // const SizedBox(height: 5),
            TextButton(
              onPressed: () {
                Navigator.pushNamed(context, '/register');
              },
              child: const Text('Create New Account'),
            ),
          ],
        ),
      ),
    );
  }
}
