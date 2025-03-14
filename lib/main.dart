import 'package:digits_and_dunes/views/world_selection_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'views/home_page.dart';
import 'views/login_page.dart';
import 'views/sign_up_page.dart';
import 'views/credits_page.dart';
import 'views/treasure_room_page.dart';
import 'views/settings_page.dart';
import 'viewmodels/auth_viewmodel.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart'; // If using FlutterFire CLI


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform, // Only if using FlutterFire CLI
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AuthViewModel(),
      child: Consumer<AuthViewModel>(
        builder: (context, authViewModel, child) {
          return MaterialApp(
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
            },
          );
        },
      ),
    );
  }
}