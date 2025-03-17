import 'package:flutter/material.dart';
import 'package:animations/animations.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import '../viewmodels/auth_viewmodel.dart';
import 'level_detail_screen.dart';

class LevelMapScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    print("Building LevelMapScreen"); // Debugging statement
    return Scaffold(
      body: Stack(
        children: [
          // Background
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.pink.shade200, Colors.purple.shade300],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
          ),

          // Centered Level Path
          Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(10, (index) {
                  print("Creating LevelNode for level: ${10 - index}"); // Debugging statement
                  return LevelNode(level: 10 - index);
                }),
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

  LevelNode({required this.level});

  @override
  Widget build(BuildContext context) {
    print("Building LevelNode for level: $level"); // Debugging statement
    final authViewModel = Provider.of<AuthViewModel>(context);
    final currentUserId = authViewModel.user!.uid;

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
            closedColor: Colors.pinkAccent,
            openColor: Colors.white,
            closedBuilder: (context, action) => GestureDetector(
              onTap: action,
              child: Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 3),
                ),
                child: Center(
                  child: Text(
                    "$level",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
            openBuilder: (context, action) => LevelDetailScreen(level: level),
          ),

          // Display friends with 0 stars for this level
          FutureBuilder<QuerySnapshot>(
            future: FirebaseFirestore.instance
                .collection('friendships')
                .where('users', arrayContains: currentUserId)
                .get(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                print("No data found for friendships"); // Debugging statement
                return const SizedBox.shrink();
              }

              List<Widget> friendWidgets = [];
              for (var doc in snapshot.data!.docs) {
                List<String> users = List<String>.from(doc['users']);
                String friendId = users.firstWhere((id) => id != currentUserId);

                // Check if the friend has 0 stars for the current level
                friendWidgets.add(FutureBuilder<DocumentSnapshot>(
                  future: FirebaseFirestore.instance.collection('players').doc(friendId).get(),
                  builder: (context, friendSnapshot) {
                    if (!friendSnapshot.hasData || !friendSnapshot.data!.exists) {
                      print("Friend data not found for ID: $friendId"); // Debugging statement
                      return const SizedBox.shrink();
                    }

                    final friendData = friendSnapshot.data!.data() as Map<String, dynamic>;
                    final levelStars = Map<String, dynamic>.from(friendData['levelStars'] ?? {});
                    String key = '0-$level'; // Assuming level 1 is represented as '0-0'

                    if ((levelStars[key] ?? 0) == 0) {
                      return Positioned(
                        top: 0,
                        left: 0,
                        child: CircleAvatar(
                          backgroundImage: friendData['profilePicUrl'] != null
                              ? NetworkImage(friendData['profilePicUrl'])
                              : const AssetImage('assets/default_profile_pic.jpg') as ImageProvider,
                          radius: 15,
                        ),
                      );
                    }
                    return const SizedBox.shrink();
                  },
                ));
              }

              return Stack(children: friendWidgets);
            },
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
