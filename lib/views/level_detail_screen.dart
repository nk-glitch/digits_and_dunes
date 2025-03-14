import 'package:flutter/material.dart';

class LevelDetailScreen extends StatelessWidget {
  final int level;

  LevelDetailScreen({required this.level});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Level $level")),
      body: Center(
        child: Text(
          "Details for Level $level",
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
