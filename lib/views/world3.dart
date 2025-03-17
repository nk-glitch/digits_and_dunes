import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/level_node.dart';
import '../viewmodels/auth_viewmodel.dart';
import '../services/player_service.dart';
import '../views/level_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class World3Page extends StatelessWidget {
  const World3Page({super.key});

  static const int worldIndex = 2;

  @override
  Widget build(BuildContext context) {
    final authViewModel = Provider.of<AuthViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("World 3"),
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
        child: StreamBuilder<DocumentSnapshot>(
          stream: FirebaseFirestore.instance
              .collection('players')
              .doc(authViewModel.user!.uid)
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }

            Map<String, dynamic> data = snapshot.data!.data() as Map<String, dynamic>;
            Map<String, dynamic> levelStars = Map<String, dynamic>.from(data['levelStars'] ?? {});

            List<int> stars = List.generate(10, (level) {
              String key = '$worldIndex-$level';
              return levelStars[key] ?? 0;
            });

            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 20.0),
                child: Column(
                  children: List.generate(10, (index) {
                    bool isLocked = index > 0 && stars[index - 1] == 0;

                    return Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: LevelNode(
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
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Complete the previous level first!'),
                                    duration: Duration(seconds: 2),
                                  ),
                                );
                              }
                            },
                          ),
                        ),
                      ],
                    );
                  }).reversed.toList(),
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
