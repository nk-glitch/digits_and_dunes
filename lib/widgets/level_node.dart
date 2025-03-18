import 'package:flutter/material.dart';
import '../views/level_page.dart';

class LevelNode extends StatelessWidget {
  final int level;
  final int stars;
  final String difficulty;
  final VoidCallback onTap;
  final bool isLocked;
  final List<FriendInfo> friends;

  const LevelNode({
    Key? key,
    required this.level,
    required this.stars,
    required this.difficulty,
    required this.onTap,
    this.isLocked = false,
    this.friends = const [],
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Friends avatars and usernames
          if (friends.isNotEmpty) ...[
            Container(
              width: 100,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: friends.map((friend) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        friend.username,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(width: 4),
                      CircleAvatar(
                        radius: 12,
                        backgroundImage: NetworkImage(friend.photoUrl),
                      ),
                    ],
                  ),
                )).toList(),
              ),
            ),
            const SizedBox(width: 16),
          ],
          // Level node
          Column(
            children: [
              GestureDetector(
                onTap: isLocked ? null : onTap,
                child: Container(
                  width: 70,
                  height: 70,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _getNodeColor(),
                    border: Border.all(
                      color: stars == 3 ? Colors.amber[300]! : Colors.white,
                      width: stars == 3 ? 4 : 3,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: stars == 3 ? Colors.amber.withOpacity(0.5) : Colors.black26,
                        blurRadius: stars == 3 ? 10 : 6,
                        offset: const Offset(0, 3),
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
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.black26,
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(
                    color: stars == 3 ? Colors.amber[300]! : Colors.white30,
                    width: 1,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: List.generate(3, (index) {
                    return Icon(
                      Icons.star,
                      size: 24,
                      color: index < stars 
                          ? (stars == 3 ? Colors.amber[300] : Colors.amber) 
                          : Colors.grey[800],
                    );
                  }),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                difficulty,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.white70,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Color _getNodeColor() {
    if (isLocked) return Colors.grey;
    if (stars == 3) return Colors.amber[700]!;
    return Colors.blue;
  }
}

class FriendInfo {
  final String username;
  final String photoUrl;

  const FriendInfo({
    required this.username,
    required this.photoUrl,
  });
}
