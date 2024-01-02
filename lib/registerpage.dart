import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  var buttonDisabled = false;

  @override
  void initState() {
    super.initState();
    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      Navigator.pushNamed(context, '/');
    }
  }

  void register() async {
    if (_usernameController.text.isEmpty || _passwordController.text.isEmpty) {
      SnackBar snackBar = const SnackBar(
        content: Text('Please fill in all fields'),
        duration: Duration(seconds: 2),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      return;
    }

    // show loading circle
    showDialog(
      context: context,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );

    // disable button
    setState(() {
      buttonDisabled = true;
    });

    try {
      // create user with email and password
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _usernameController.text, password: _passwordController.text);

      // show success message
      SnackBar snackBar = const SnackBar(
        content: Text('Account created successfully'),
        duration: Duration(seconds: 2),
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }

      // navigate to home page
      if (mounted) {
        Navigator.pushNamed(context, '/');
      }
    } on FirebaseAuthException catch (e) {
      String errMsg = '';

      if (e.code == 'invalid-email') {
        errMsg = 'Please enter a valid email address';
      } else if (e.code == 'weak-password') {
        errMsg = 'Please enter a stronger password';
      } else if (e.code == 'email-already-in-use') {
        errMsg = 'Email already in use';
      } else {
        errMsg = 'Something went wrong';
      }

      // show error message
      SnackBar snackBar = SnackBar(
        content: Text(errMsg),
        duration: const Duration(seconds: 2),
      );
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    } finally {
      // hide loading circle
      if (mounted && Navigator.of(context).canPop()) {
        // the if condition avoids popping the login page itself when spammed.
        Navigator.of(context).pop();
      }

      // enable button
      setState(() {
        buttonDisabled = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SizedBox(
          width: 400,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  'Register',
                  style: TextStyle(fontSize: 30),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Username',
                  ),
                  controller: _usernameController,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  obscureText: true,
                  autocorrect: false,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Password',
                  ),
                  controller: _passwordController,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.pushNamed(context, '/');
                      },
                      child: const Text("Sign in"),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  onPressed: register,
                  child: const Text('Register'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
