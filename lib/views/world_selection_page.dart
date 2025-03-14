import 'package:flutter/material.dart';

class WorldSelectionPage extends StatelessWidget {
  const WorldSelectionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Select a World')),
      body: SafeArea(  // Ensures content does not overlap system bars
        child: SingleChildScrollView( // Prevents pixel overflow
          child: Column(
            children: [
              const Text("Choose Your Adventure!", style: TextStyle(fontSize: 24)),
              const SizedBox(height: 20),
              const SizedBox(height: 20),
              const SizedBox(height: 20),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/home');
                },
                child: const Text('Back to Home'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
