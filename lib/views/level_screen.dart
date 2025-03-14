import 'package:flutter/material.dart';

class LevelScreen extends StatelessWidget {
  final int level;

  LevelScreen({required this.level});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Level $level")),
      body: Center(
        child: Text(
          "Gameplay for Level $level",
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
