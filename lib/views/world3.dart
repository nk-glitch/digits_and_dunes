import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/level_node.dart';
import '../viewmodels/auth_viewmodel.dart';
import '../services/player_service.dart';
import '../services/firebase_service.dart';
import '../views/level_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class World3Page extends StatelessWidget {
  const World3Page({super.key});

  static const int worldIndex = 2;

  Stream<List<String>> _getFriendIds(String userId) {
    return FirebaseFirestore.instance
        .collection('friendships')
        .where('users', arrayContains: userId)
        .snapshots()
        .map((snapshot) {
          List<String> friendIds = [];
          for (var doc in snapshot.docs) {
            List<String> users = List<String>.from(doc['users']);
            friendIds.add(users.firstWhere((id) => id != userId));
          }
          print('Found friends in friendships: $friendIds');
          return friendIds;
        });
  }

  Future<Map<int, List<FriendInfo>>> _loadFriendsProgress(
    List<QueryDocumentSnapshot> friends,
    FirebaseService firebaseService,
  ) async {
    print('Loading friends progress... Number of friends: ${friends.length}');
    Map<int, List<FriendInfo>> friendsByLevel = {};
    
    for (var doc in friends) {
      Map<String, dynamic> friendData = doc.data() as Map<String, dynamic>;
      String friendName = friendData['name'] ?? 'Unknown';
      print('Loading progress for friend: $friendName');
      
      // Get the friend's level from their levelStars
      Map<String, dynamic> levelStars = Map<String, dynamic>.from(friendData['levelStars'] ?? {});
      
      // Check if friend has completed all levels in world 2
      bool hasUnlockedWorld = true;  // Start true, set to false if any level is incomplete
      for (int i = 0; i < 10; i++) {
        String key = '1-$i';  // Check each level in world 2
        if (!levelStars.containsKey(key) || levelStars[key] == 0) {
          hasUnlockedWorld = false;
          break;
        }
      }
      
      if (!hasUnlockedWorld) {
        print('Friend $friendName has not completed all levels in world 2');
        continue;  // Skip this friend if they haven't completed world 2
      }
      
      int highestLevel = 1;
      
      // Find the highest level they've played in this world
      for (var key in levelStars.keys) {
        if (key.startsWith('$worldIndex-')) {
          int level = int.parse(key.split('-')[1]) + 1;
          if (levelStars[key] > 0 && level > highestLevel) {
            highestLevel = level;
          }
        }
      }
      
      print('Friend $friendName is at level $highestLevel in world 3');
      
      if (highestLevel >= 1 && highestLevel <= 10) {
        friendsByLevel[highestLevel] = [
          ...(friendsByLevel[highestLevel] ?? []),
          FriendInfo(
            username: friendName,
            photoUrl: 'https://ui-avatars.com/api/?name=$friendName',
          ),
        ];
      }
    }
    
    print('Friends by level in world 3: $friendsByLevel');
    return friendsByLevel;
  }

  @override
  Widget build(BuildContext context) {
    final authViewModel = Provider.of<AuthViewModel>(context);
    final firebaseService = FirebaseService();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Pyramid Peaks"),
        backgroundColor: Colors.amber,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.amber.shade200, Colors.amber.shade700],
          ),
        ),
        child: StreamBuilder<DocumentSnapshot>(
          stream: FirebaseFirestore.instance
              .collection('players')
              .doc(authViewModel.user!.uid)
              .snapshots(),
          builder: (context, playerSnapshot) {
            if (!playerSnapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }

            return StreamBuilder<List<String>>(
              stream: _getFriendIds(authViewModel.user!.uid),
              builder: (context, friendIdsSnapshot) {
                if (!friendIdsSnapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                List<String> friendIds = friendIdsSnapshot.data!;
                print('Found ${friendIds.length} friend IDs: $friendIds');

                Map<String, dynamic> playerData = 
                    playerSnapshot.data!.data() as Map<String, dynamic>;
                Map<String, dynamic> levelStars = 
                    Map<String, dynamic>.from(playerData['levelStars'] ?? {});
                print('Level stars: $levelStars');
                
                List<int> stars = List.generate(10, (level) {
                  String key = '$worldIndex-$level';
                  return levelStars[key] ?? 0;
                });

                return StreamBuilder<QuerySnapshot>(
                  stream: friendIds.isEmpty 
                      ? FirebaseFirestore.instance
                          .collection('players')
                          .where(FieldPath.documentId, whereIn: ['dummy_id'])
                          .snapshots()
                      : FirebaseFirestore.instance
                          .collection('players')
                          .where(FieldPath.documentId, whereIn: friendIds)
                          .snapshots(),
                  builder: (context, friendsSnapshot) {
                    if (friendsSnapshot.hasError) {
                      print('Error loading friends: ${friendsSnapshot.error}');
                      return const Center(
                        child: Text(
                          'Error loading friends',
                          style: TextStyle(color: Colors.white),
                        ),
                      );
                    }

                    return FutureBuilder<Map<int, List<FriendInfo>>>(
                      future: friendsSnapshot.hasData && friendsSnapshot.data!.docs.isNotEmpty
                          ? _loadFriendsProgress(friendsSnapshot.data!.docs, firebaseService)
                          : Future.value({}),
                      builder: (context, friendsProgressSnapshot) {
                        final friendsByLevel = friendsProgressSnapshot.data ?? {};
                        final isLoadingFriends = 
                            friendsProgressSnapshot.connectionState == ConnectionState.waiting;

                        return Stack(
                          children: [
                            SingleChildScrollView(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(vertical: 20.0),
                                child: Column(
                                  children: List.generate(10, (index) {
                                    int levelNumber = 10 - index;
                                    bool isLocked = levelNumber > 1 && (stars[levelNumber - 2] == 0);
                                    
                                    return Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        if (isLoadingFriends)
                                          const SizedBox(width: 100, child: Center(
                                            child: SizedBox(
                                              width: 20,
                                              height: 20,
                                              child: CircularProgressIndicator(
                                                strokeWidth: 2,
                                                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                              ),
                                            ),
                                          )),
                                        Expanded(
                                          child: LevelNode(
                                            level: levelNumber,
                                            stars: stars[levelNumber - 1],
                                            difficulty: _getDifficulty(levelNumber),
                                            isLocked: isLocked,
                                            friends: friendsByLevel[levelNumber] ?? [],
                                            onTap: () {
                                              if (!isLocked) {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) => LevelPage(
                                                      worldIndex: worldIndex,
                                                      level: levelNumber,
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
                                  }).toList(),
                                ),
                              ),
                            ),
                            if (friendsProgressSnapshot.hasError)
                              Positioned(
                                bottom: 20,
                                left: 0,
                                right: 0,
                                child: Center(
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 8,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.red.withOpacity(0.8),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: const Text(
                                      'Error loading friends',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        );
                      },
                    );
                  },
                );
              },
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
