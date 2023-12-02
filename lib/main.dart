import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:timer/login.dart';
// import 'package:google_fonts/google_fonts.dart';
import 'package:timer/mainscreen.dart';
import 'package:timer/splashscreen.dart';
// import 'package:timer/mainscreen.dart';
import 'package:timer/timer.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    // name: 'timer-AEO',
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    // roles.dart
    Map<String, String> roles = {
      'aeo.director@aeo.com': 'admin',
      'aeo.speech@aeo.com': 'speech',
      'aeo.storytelling@aeo.com': 'stortel',
      'aeo.newscasting@aeo.com': 'newscast',
      'aeo.spellingbee@aeo.com': 'spellbe',
      'aeo.debate@aeo.com': 'debate'
    };

    return MaterialApp(
      title: 'Timer AEO 2024',
      theme: ThemeData.dark(),
      home: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const SplashScreen();
            }
            if (snapshot.hasData) {
              User? user = snapshot.data as User?;
              String userEmail = user?.email ?? '';
              String userRole = roles[userEmail] ?? ''; // Get role from the map

              return MainScreenMobile(role: userRole);
            } else {
              return const LoginScreen();
            }
          }),
      // initialRoute: '/',
      routes: {
        '/login': (context) => const LoginScreen(),
        '/speech_prep_1': (context) => const Time(
              title: 'Prep room 1',
              field: 'Speech',
              room: 'prep room1',
            ),
        '/speech_prep_2': (context) => const Time(
              title: 'Prep room 2',
              field: 'Speech',
              room: 'Prep room2',
            ),
        '/speech_perform': (context) => const Time(
              title: 'Perform room',
              field: 'Speech',
              room: 'Perform room',
            ),
        '/storytelling_prep_1': (context) => const Time(
              title: 'Prep room 1',
              field: 'Storytelling',
              room: 'Prep room1',
            ),
        '/storytelling_prep_2': (context) => const Time(
              title: 'Prep room 2',
              field: 'Storytelling',
              room: 'Prep room2',
            ),
        '/storytelling_perform': (context) => const Time(
              title: 'Perform room',
              field: 'Storytelling',
              room: 'Perform room',
            ),
        '/newscasting_prep_1': (context) => const Time(
              title: 'Prep rom 1',
              field: 'Newscasting',
              room: 'Prep room1',
            ),
        '/newscasting_prep_2': (context) => const Time(
              title: 'Prep rom 2',
              field: 'Newscasting',
              room: 'Prep room2',
            ),
        '/newscasting_perform': (context) => const Time(
              title: 'Perform room',
              field: 'Newscasting',
              room: 'Perform room',
            ),
        '/spelling_bee_prep_1': (context) => const Time(
              title: 'Prep room 1',
              field: 'Spelling Bee',
              room: 'Prep room1',
            ),
        '/spelling_bee_prep_2': (context) => const Time(
              title: 'Prep room 2',
              field: 'Spelling Bee',
              room: 'Prep room2',
            ),
        '/spelling_bee_perform': (context) => const Time(
              title: 'Perform room',
              field: 'Spelling Bee',
              room: 'Perform room',
            ),
        '/debate_perform': (context) => const Time(
              title: 'Perform room',
              field: 'Debate',
              room: 'Perform room',
            ),
      },
    );
  }
}
