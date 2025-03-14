import 'package:flutter/material.dart';
import 'package:animations/animations.dart';

class LevelMapScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.pink.shade100, Colors.purple.shade100],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
          ),

          // Scrollable Level Path
          Positioned.fill(
            child: SingleChildScrollView(
              child: Column(
                children: List.generate(10, (index) => LevelNode(level: 10 - index)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class LevelNode extends StatelessWidget {
  final int level;
  final bool isCompleted;
  final bool isCurrent;

  LevelNode({
    required this.level,
    this.isCompleted = false,
    this.isCurrent = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20.0),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Animated Level Path Circle
          OpenContainer(
            closedShape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(35),
            ),
            transitionType: ContainerTransitionType.fadeThrough,
            closedColor: isCurrent ? Colors.purpleAccent : Colors.pinkAccent,
            openColor: Colors.white,
            closedBuilder: (context, action) => GestureDetector(
              onTap: action,
              child: Container(
                width: 70,
                height: 70,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 3),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 6,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    "$level",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
            openBuilder: (context, action) => LevelDetailScreen(level: level),
          ),

          // Crown for completed levels
          if (isCompleted)
            Positioned(
              top: -10,
              child: Icon(Icons.emoji_events, color: Colors.yellow, size: 30),
            ),
        ],
      ),
    );
  }
}

class LevelDetailScreen extends StatelessWidget {
  final int level;

  LevelDetailScreen({required this.level});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Level $level")),
      body: Center(
        child: Text("Details for Level $level", style: TextStyle(fontSize: 24)),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: LevelMapScreen(),
  ));
}
