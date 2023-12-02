// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';

// class FirebaseAuthService {
//   FirebaseAuth _auth = FirebaseAuth.instance;

//   Future<User?> signInWithEmailAndPassword(String email, String password) async {

//     try {
//       UserCredential credential =await _auth.signInWithEmailAndPassword(email: email, password: password);
//       return credential.user;
//     } on FirebaseAuthException catch (e) {
//       if (e.code == 'user-not-found' || e.code == 'wrong-password') {
//         showToast(message: 'Invalid email or password.');
//         ScaffoldMessenger.of(context).showSnackBar(snackBar)
//       } else {
//         showToast(message: 'An error occurred: ${e.code}');
//       }

//     }
//     return null;

//   }
// }
