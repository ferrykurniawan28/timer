// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:timer/mainscreen.dart';

FirebaseAuth _auth = FirebaseAuth.instance;

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> form = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _password = TextEditingController();
  bool isAuthenticating = false;

  Map<String, String> roles = {
    'aeo.director@aeo.com': 'admin',
    'aeo.speech@aeo.com': 'speech',
    'aeo.storytelling@aeo.com': 'stortel',
    'aeo.newscasting@aeo.com': 'newscast',
    'aeo.spellingbee@aeo.com': 'spellbe',
    'aeo.debate@aeo.com': 'debate'
  };

  void _submit() async {
    final isValid = form.currentState!.validate();
    if (isValid) {
      if (!isValid) {
        return;
      }
      form.currentState!.save();
      try {
        setState(() {
          isAuthenticating = true;
        });
        final credential = await _auth.signInWithEmailAndPassword(
          email: _email.text,
          password: _password.text,
        );
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => MainScreenMobile(
              role: roles[_email.text].toString(),
            ),
          ),
        );
        // return credential.user;
      } on FirebaseAuthException catch (error) {
        if (error.code == 'user-not-found') {}
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(error.message ?? 'Error: ${error.code}'),
          ),
        );
      }
      setState(() {
        isAuthenticating = false;
      });
    }
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Login',
              style: GoogleFonts.lato(
                fontSize: 50,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(
              height: 50,
            ),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(18.0),
                child: SizedBox(
                  width: (width < 400) ? width : 400,
                  height: 235,
                  child: Form(
                    key: form,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        TextFormField(
                          keyboardType: TextInputType.emailAddress,
                          controller: _email,
                          validator: (String? value) {
                            if (value == null ||
                                value.isEmpty ||
                                !value.contains('@')) {
                              return 'Please enter your email';
                            }
                            return null;
                          },
                          decoration: const InputDecoration(
                            labelText: 'Email',
                            border: OutlineInputBorder(),
                          ),
                        ),
                        TextFormField(
                          obscureText: true,
                          controller: _password,
                          validator: (String? value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your password';
                            }
                            return null;
                          },
                          decoration: const InputDecoration(
                            labelText: 'Password',
                            border: OutlineInputBorder(),
                          ),
                        ),
                        if (isAuthenticating) const CircularProgressIndicator(),
                        if (!isAuthenticating)
                          ElevatedButton(
                            onPressed: _submit,
                            child: Text(
                              'Login',
                              style: GoogleFonts.lato(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
