import 'package:flutter/material.dart';

class InstructionsPage extends StatelessWidget {
  const InstructionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Instructions'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Game Instructions',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            const Text(
              '1. Play Button: Takes you to the world select page where you can choose to play in any unlocked world.',
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 10),
            const Text(
              '2. World Map: Play and unlock levels starting from the very first one! Earn stars based on your accuracy. Getting 3 stars on every level in a world earns you a special trophy. You can see what level friends currently are on aswell.',
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 10),
            const Text(
              '3. Social Tab: Complete levels to unlock new worlds.',
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 10),
            const Text(
              '4. Trophies: Earn trophies for completing all levels in a world.',
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Back to Home'),
            ),
          ],
        ),
      ),
    );
  }
}