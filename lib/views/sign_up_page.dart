import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/auth_viewmodel.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  String? _error;
  String? _passwordError;

  void _validatePassword(String password) {
    final authViewModel = Provider.of<AuthViewModel>(context, listen: false);
    setState(() {
      _passwordError = authViewModel.validatePassword(password);
    });
  }

  @override
  Widget build(BuildContext context) {
    final authViewModel = Provider.of<AuthViewModel>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Sign Up')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Name'),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Email'),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(
                labelText: 'Password',
                errorText: _passwordError,
                helperText: 'Must contain uppercase, lowercase, number, and special character',
              ),
              obscureText: true,
              onChanged: _validatePassword,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _confirmPasswordController,
              decoration: const InputDecoration(labelText: 'Confirm Password'),
              obscureText: true,
            ),
            const SizedBox(height: 16),
            if (_error != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: Text(
                  _error!,
                  style: const TextStyle(color: Colors.red),
                ),
              ),
            ElevatedButton(
              onPressed: () async {
                if (_nameController.text.trim().isEmpty) {
                  setState(() => _error = "Please enter your name");
                  return;
                }
                
                if (_passwordController.text != _confirmPasswordController.text) {
                  setState(() => _error = "Passwords do not match");
                  return;
                }

                try {
                  final user = await authViewModel.signUp(
                    _emailController.text.trim(),
                    _passwordController.text,
                    _nameController.text.trim(),
                  );

                  if (user != null && mounted) {
                    Navigator.pushReplacementNamed(context, '/home');
                  } else {
                    setState(() => _error = authViewModel.errorMessage);
                  }
                } catch (e) {
                  setState(() => _error = e.toString());
                }
              },
              child: const Text('Sign Up'),
            ),
            const SizedBox(height: 16),
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
            const SizedBox(height: 16),
            TextButton(
              onPressed: () => Navigator.pushReplacementNamed(context, '/login'),
              child: const Text('Already have an account? Log in'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }
}
