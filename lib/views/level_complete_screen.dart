import 'package:flutter/material.dart';

class LevelCompleteScreen extends StatelessWidget {
  final double accuracy;
  final int stars;

  const LevelCompleteScreen({
    Key? key,
    required this.accuracy,
    required this.stars,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Level Complete!',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Text(
              'Accuracy: ${(accuracy * 100).toStringAsFixed(1)}%',
              style: const TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(3, (index) {
                return Icon(
                  Icons.star,
                  size: 40,
                  color: index < stars ? Colors.amber : Colors.grey,
                );
              }),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                // Pop twice to go back to world map
                Navigator.of(context)
                  ..pop()
                  ..pop();
              },
              child: const Text('Return to World Map'),
            ),
          ],
        ),
      ),
    );
  }
} 