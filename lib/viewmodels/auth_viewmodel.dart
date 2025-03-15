import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:digits_and_dunes/services/player_service.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

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

  // Add password validation
  String? validatePassword(String password) {
    if (password.isEmpty) {
      return 'Password cannot be empty';
    }
    if (password.length < 8) {
      return 'Password must be at least 8 characters';
    }
    if (!password.contains(RegExp(r'[A-Z]'))) {
      return 'Password must contain at least one uppercase letter';
    }
    if (!password.contains(RegExp(r'[a-z]'))) {
      return 'Password must contain at least one lowercase letter';
    }
    if (!password.contains(RegExp(r'[0-9]'))) {
      return 'Password must contain at least one number';
    }
    if (!password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
      return 'Password must contain at least one special character';
    }
    return null;
  }

  Future<User?> signUp(String email, String password, String name) async {
    try {
      // Validate password before attempting signup
      final passwordError = validatePassword(password);
      if (passwordError != null) {
        _errorMessage = passwordError;
        notifyListeners();
        return null;
      }

      final UserCredential userCredential = 
          await _auth.createUserWithEmailAndPassword(
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
    } on FirebaseAuthException catch (e) {
      _errorMessage = _getReadableErrorMessage(e.code);
      notifyListeners();
      return null;
    }
  }

  // Make error messages more user-friendly
  String _getReadableErrorMessage(String errorCode) {
    switch (errorCode) {
      case 'email-already-in-use':
        return 'This email is already registered';
      case 'invalid-email':
        return 'Please enter a valid email address';
      case 'operation-not-allowed':
        return 'Email/password accounts are not enabled';
      case 'weak-password':
        return 'Please enter a stronger password';
      case 'user-disabled':
        return 'This account has been disabled';
      case 'user-not-found':
        return 'No account found with this email';
      case 'wrong-password':
        return 'Incorrect password';
      case 'too-many-requests':
        return 'Too many attempts. Please try again later';
      default:
        return 'An error occurred. Please try again';
    }
  }

  // Add rate limiting for login attempts
  final Map<String, int> _loginAttempts = {};
  final Map<String, DateTime> _lockoutUntil = {};

  Future<bool> _checkRateLimit(String email) {
    final now = DateTime.now();
    
    // Clear lockout if time has passed
    if (_lockoutUntil.containsKey(email) && _lockoutUntil[email]!.isAfter(now)) {
      _errorMessage = 'Account temporarily locked. Try again later';
      notifyListeners();
      return Future.value(false);
    }

    // Reset attempts if no recent attempts
    if (!_loginAttempts.containsKey(email)) {
      _loginAttempts[email] = 1;
      return Future.value(true);
    }

    // Implement exponential backoff
    if (_loginAttempts[email]! >= 5) {
      _lockoutUntil[email] = now.add(const Duration(minutes: 15));
      _loginAttempts[email] = 0;
      _errorMessage = 'Too many attempts. Try again in 15 minutes';
      notifyListeners();
      return Future.value(false);
    }

    _loginAttempts[email] = _loginAttempts[email]! + 1;
    return Future.value(true);
  }

  Future<User?> signIn(String email, String password) async {
    try {
      // Check rate limiting before attempting login
      if (!await _checkRateLimit(email)) {
        return null;
      }

      final UserCredential userCredential = 
          await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      
      // Reset login attempts on successful login
      _loginAttempts.remove(email);
      _lockoutUntil.remove(email);

      _user = userCredential.user;
      notifyListeners();
      return _user;
    } on FirebaseAuthException catch (e) {
      _errorMessage = _getReadableErrorMessage(e.code);
      notifyListeners();
      return null;
    }
  }

  Future<void> logout() async {
    await _auth.signOut();
  }

  Future<User?> signInWithFacebook() async {
    try {
      // Initiate the Facebook login
      final LoginResult result = await FacebookAuth.instance.login();

      // Check if the login was successful
      if (result.status == LoginStatus.success) {
        // User is logged in
        final AccessToken accessToken = result.accessToken!;

        // Retrieve user data
        final userData = await FacebookAuth.instance.getUserData(
          fields: "name,email,picture.width(200)",
        );

        // Create a credential for Firebase
        final credential = FacebookAuthProvider.credential(accessToken.tokenString);

        // Sign in to Firebase with the credential
        final userCredential = await _auth.signInWithCredential(credential);
        
        // Check if the user is new and create player data
        if (userCredential.additionalUserInfo?.isNewUser ?? false) {
          await PlayerService().createPlayer(
            userCredential.user!.uid,
            userData['name'] ?? 'Facebook User',
            userData['email'] ?? '',
            profilePicUrl: userData['picture']?['data']?['url'],
          );
        }

        // Update the user state
        _user = userCredential.user;
        notifyListeners();
        return _user;
      } else {
        // Handle login cancellation or failure
        _errorMessage = result.message;
        notifyListeners();
        return null;
      }
    } catch (e) {
      // Handle any errors during the login process
      _errorMessage = 'Error during Facebook sign in: ${e.toString()}';
      notifyListeners();
      return null;
    }
  }
}
