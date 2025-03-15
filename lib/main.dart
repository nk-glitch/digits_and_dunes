import 'package:digits_and_dunes/views/world_selection_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart'; // If using FlutterFire CLI

import 'views/home_page.dart';
import 'views/login_page.dart';
import 'views/sign_up_page.dart';
import 'views/credits_page.dart';
import 'views/treasure_room_page.dart';
import 'views/settings_page.dart';
import 'views/level_map_screen.dart';
import 'views/world1.dart';
import 'views/world2.dart';
import 'views/world3.dart';
import 'views/world4.dart';
import 'views/social_page.dart';

import 'viewmodels/auth_viewmodel.dart';
import 'viewmodels/question_viewmodel.dart';

void _testFirebase() async {
  try {
    final FirebaseFirestore db = FirebaseFirestore.instance;
    await db.collection('test').doc('test').set({'test': 'test'});
    print('Firebase connection successful!');
  } catch (e) {
    print('Firebase error: $e');
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform, // Only if using FlutterFire CLI
  );
  _testFirebase();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AuthViewModel()),
      ],
      child: MaterialApp(
        title: 'Digits and Dunes',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const HomePage(),
        routes: {
          '/login': (context) => const LoginPage(),
          '/signup': (context) => const SignUpPage(),
          '/home': (context) => const HomePage(),
          '/credits': (context) => const CreditsPage(),
          '/treasure_room': (context) => const TreasureRoomPage(),
          '/settings': (context) => const SettingsPage(),
          '/world_select': (context) => const WorldSelectionPage(),
          '/level_map': (context) => LevelMapScreen(),
          '/world1': (context) => World1Page(),
          '/world2': (context) => World2Page(),
          '/world3': (context) => World3Page(),
          '/world4': (context) => World4Page(),
          '/social': (context) => const SocialPage(),
        },
      ),
    );
  }
}