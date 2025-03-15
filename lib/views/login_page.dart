import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/auth_viewmodel.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  String? _error;

  @override
  Widget build(BuildContext context) {
    final authViewModel = Provider.of<AuthViewModel>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            if (_error != null)
              Text(
                _error!,
                style: const TextStyle(color: Colors.red),
              ),
            const SizedBox(height: 20),
            
            ElevatedButton.icon(
              onPressed: () async {
                String? error = await authViewModel.login(
                  _emailController.text,
                  _passwordController.text,
                );

                if (error == null) {
                  Navigator.pushReplacementNamed(context, '/world_select'); // Redirect to World Select
                } else {
                  setState(() => _error = error); // Keep error handling
                }
              },
              icon: const Icon(Icons.login, color: Colors.white),
              label: const Text('Login'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1877F2), // Facebook blue
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
            ),

            const SizedBox(height: 20),
            
            ElevatedButton.icon(
              onPressed: () async {
                final user = await authViewModel.signInWithFacebook();
                if (user != null && mounted) {
                  Navigator.pushReplacementNamed(context, '/home');
                }
              },
              icon: const Icon(Icons.facebook, color: Colors.white),
              label: const Text('Continue with Facebook'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1877F2), // Facebook blue
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
            ),

            TextButton(
              onPressed: () => Navigator.pushNamed(context, '/signup'),
              child: const Text("Don't have an account? Sign Up"),
            ),
          ],
        ),
      ),
    );
  }
}
