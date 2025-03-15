import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/level_node.dart';
import '../viewmodels/auth_viewmodel.dart';
import '../services/player_service.dart';
import '../views/level_page.dart';

class World1Page extends StatelessWidget {
  const World1Page({super.key});

  static const int worldIndex = 0;

  @override
  Widget build(BuildContext context) {
    final authViewModel = Provider.of<AuthViewModel>(context);
    final playerService = PlayerService();

    return Scaffold(
      appBar: AppBar(
        title: const Text("World 1"),
        backgroundColor: Colors.blue,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.blue.shade200, Colors.blue.shade700],
          ),
        ),
        child: FutureBuilder<List<int>>(
          future: playerService.getWorldStars(authViewModel.user!.uid, worldIndex),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }

            final stars = snapshot.data!;
            
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 20.0),
                child: Column(
                  children: List.generate(10, (index) {
                    // Calculate if level should be locked
                    bool isLocked = index > 0 && stars[index - 1] == 0;
                    
                    return LevelNode(
                      level: index + 1,
                      stars: stars[index],
                      difficulty: _getDifficulty(index + 1),
                      isLocked: isLocked,
                      onTap: () {
                        if (!isLocked) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => LevelPage(
                                worldIndex: worldIndex,
                                level: index + 1,
                              ),
                            ),
                          );
                        }
                      },
                    );
                  }).reversed.toList(), // Reverse to show level 1 at bottom
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  String _getDifficulty(int level) {
    if (level <= 3) return "Easy";
    if (level <= 7) return "Medium";
    return "Hard";
  }
}
