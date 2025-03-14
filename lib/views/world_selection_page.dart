import 'package:flutter/material.dart';

class WorldSelectionPage extends StatelessWidget {
  const WorldSelectionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Select a World')),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Choose Your Adventure!",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: GridView.count(
                  crossAxisCount: 2, // 2 columns
                  shrinkWrap: true, // Prevents scroll issues
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  children: [
                    _buildWorldButton(context, 'World 1', '/world1'),
                    _buildWorldButton(context, 'World 2', '/world2'),
                    _buildWorldButton(context, 'World 3', '/world3'),
                    _buildWorldButton(context, 'World 4', '/world4'),
                  ],
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacementNamed(context, '/home');
                },
                child: const Text('Back to Home'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWorldButton(BuildContext context, String title, String route) {
    return ElevatedButton(
      onPressed: () {
        Navigator.pushNamed(context, route);
      },
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.all(24),
        textStyle: const TextStyle(fontSize: 18),
      ),
      child: Text(title),
    );
  }
}
