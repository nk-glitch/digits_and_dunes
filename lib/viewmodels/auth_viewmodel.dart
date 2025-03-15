import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:digits_and_dunes/services/player_service.dart';

class AuthViewModel extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? _user;
  String? _errorMessage;

  User? get user => _user;
  String? get errorMessage => _errorMessage;

  AuthViewModel() {
    _auth.authStateChanges().listen((user) {
      _user = user;
      notifyListeners();
    });
  }

  Future<String?> login(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      _errorMessage = null;
      notifyListeners();
      return null;
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      return _errorMessage;
    }
  }

  Future<User?> signUp(String email, String password, String name) async {
    try {
      final UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      
      // Initialize player data in Firestore
      await PlayerService().createPlayer(
        userCredential.user!.uid,
        name,
        email,
      );
      
      _user = userCredential.user;
      notifyListeners();
      return _user;
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      return null;
    }
  }

  Future<void> logout() async {
    await _auth.signOut();
  }
}
