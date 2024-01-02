import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

Future isAdmin() async {
  final DatabaseReference ref = FirebaseDatabase.instance.ref('/Admins');
  final User? user = FirebaseAuth.instance.currentUser;

  if (user != null) {
    final snapshot = await ref.child(user.uid).get();
    if (snapshot.exists) {
      final data = snapshot.value;
      if (data != null && data is Map) {
        return true;
      }
    }

    return false;
  }
}
