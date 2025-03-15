import 'package:flutter/material.dart';
import '../views/level_page.dart';

class LevelNode extends StatelessWidget {
  final int level;
  final int stars;
  final String difficulty;

  LevelNode({
    required this.level,
    required this.stars,
    required this.difficulty,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20.0),
      child: GestureDetector(
        onTap: () => _showLevelPopup(context),
        child: Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: Colors.purpleAccent,
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
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }

  void _showLevelPopup(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Text("Level $level"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("Difficulty: $difficulty", style: TextStyle(fontSize: 18)),
              SizedBox(height: 10),
              _buildStarDisplay(),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context); // Close the popup
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LevelPage(level: level)),
                  );
                },
                child: Text("Start"),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text("Close"),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildStarDisplay() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(3, (index) {
        return Icon(
          index < stars ? Icons.star : Icons.star_border,
          color: Colors.yellow,
          size: 30,
        );
      }),
    );
  }
}
