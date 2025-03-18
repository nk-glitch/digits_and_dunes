import 'package:flutter/material.dart';
import '../views/level_page.dart';
import 'dart:math';

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
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // Friends
          if (friends.isNotEmpty)
            Positioned(
              right: 220,
              top: 0,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: friends.map((friend) {
                  return Container(
                    margin: const EdgeInsets.symmetric(vertical: 2),
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: Colors.black26,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 24,
                          height: 24,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.blue[400],
                            border: Border.all(
                              color: Colors.white,
                              width: 1.5,
                            ),
                          ),
                          child: Center(
                            child: friend.photoUrl.isNotEmpty
                                ? ClipOval(
                                    child: Image.network(
                                      friend.photoUrl,
                                      width: 24,
                                      height: 24,
                                      fit: BoxFit.cover,
                                    ),
                                  )
                                : Text(
                                    _getInitials(friend.username),
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          friend.username,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            shadows: [
                              Shadow(
                                offset: Offset(1, 1),
                                blurRadius: 2,
                                color: Colors.black45,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
          
          // Level node
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
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
          ),
        ],
      ),
    );
  }

  String _getInitials(String username) {
    final parts = username.split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return username.substring(0, min(2, username.length)).toUpperCase();
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
