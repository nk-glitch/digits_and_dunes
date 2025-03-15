import 'package:flutter/material.dart';
import '../views/level_page.dart';

class LevelNode extends StatelessWidget {
  final int level;
  final int stars;
  final String difficulty;
  final VoidCallback onTap;
  final bool isLocked;

  const LevelNode({
    Key? key,
    required this.level,
    required this.stars,
    required this.difficulty,
    required this.onTap,
    this.isLocked = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20.0),
      child: Column(
        children: [
          GestureDetector(
            onTap: isLocked ? null : onTap,
            child: Container(
              width: 70,
              height: 70,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isLocked ? Colors.grey : Colors.blue,
                border: Border.all(color: Colors.white, width: 3),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 6,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: Center(
                child: isLocked 
                  ? const Icon(Icons.lock, color: Colors.white)
                  : Text(
                      level.toString(),
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          // Stars row
          Row(
            mainAxisSize: MainAxisSize.min,
            children: List.generate(3, (index) {
              return Icon(
                Icons.star,
                size: 24,
                color: index < stars ? Colors.amber : Colors.grey[800],
              );
            }),
          ),
          Text(
            difficulty,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.white70,
            ),
          ),
        ],
      ),
    );
  }
}
