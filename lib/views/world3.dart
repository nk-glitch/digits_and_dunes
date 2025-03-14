import 'package:flutter/material.dart';
import '../widgets/level_node.dart';

class World3Page extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("World 3")),
      body: Stack(
        children: [
          // Background
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.blue.shade200, Colors.blue.shade700],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
          ),

          // Scrollable Level Path
          Positioned.fill(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(vertical: 50),
              child: Column(
                children: [
                  LevelNode(level: 10, stars: 3, difficulty: "Hard"),
                  LevelNode(level: 9, stars: 2, difficulty: "Medium"),
                  LevelNode(level: 8, stars: 1, difficulty: "Easy"),
                  LevelNode(level: 7, stars: 0, difficulty: "Easy"),
                  LevelNode(level: 6, stars: 3, difficulty: "Hard"),
                  LevelNode(level: 5, stars: 2, difficulty: "Medium"),
                  LevelNode(level: 4, stars: 1, difficulty: "Easy"),
                  LevelNode(level: 3, stars: 0, difficulty: "Easy"),
                  LevelNode(level: 2, stars: 3, difficulty: "Hard"),
                  LevelNode(level: 1, stars: 2, difficulty: "Medium"),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
