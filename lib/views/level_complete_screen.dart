import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/auth_viewmodel.dart';
import '../services/player_service.dart';

class LevelCompleteScreen extends StatelessWidget {
  final double accuracy;
  final int stars;
  final int level;
  final int worldIndex;

  const LevelCompleteScreen({
    Key? key,
    required this.accuracy,
    required this.stars,
    required this.level,
    required this.worldIndex,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authViewModel = Provider.of<AuthViewModel>(context);
    final playerService = PlayerService();

    // Save stars when the screen is shown
    WidgetsBinding.instance.addPostFrameCallback((_) {
      playerService.updateLevelStars(
        authViewModel.user!.uid,
        worldIndex,
        level - 1, // Convert to 0-based index
        stars,
      );
    });

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