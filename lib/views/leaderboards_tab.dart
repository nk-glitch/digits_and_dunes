import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import '../viewmodels/auth_viewmodel.dart';

class LeaderboardsTab extends StatelessWidget {
  const LeaderboardsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Column(
        children: [
          const TabBar(
            labelColor: Colors.blue,
            tabs: [
              Tab(text: 'Global'),
              Tab(text: 'Friends'),
            ],
          ),
          Expanded(
            child: TabBarView(
              children: [
                _GlobalLeaderboard(),
                _FriendsLeaderboard(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _GlobalLeaderboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('players')
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        // Calculate total stars for each player
        List<Map<String, dynamic>> playerRankings = [];
        for (var doc in snapshot.data!.docs) {
          final data = doc.data() as Map<String, dynamic>;
          final levelStars = Map<String, dynamic>.from(data['levelStars'] ?? {});
          int totalStars = levelStars.values.fold(0, (sum, stars) => sum + (stars as int));
          
          playerRankings.add({
            'name': data['name'],
            'totalStars': totalStars,
            'id': doc.id,
          });
        }

        // Sort by total stars (descending)
        playerRankings.sort((a, b) => b['totalStars'].compareTo(a['totalStars']));

        return _buildLeaderboardList(playerRankings);
      },
    );
  }
}

class _FriendsLeaderboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final authViewModel = Provider.of<AuthViewModel>(context);
    final currentUserId = authViewModel.user!.uid;

    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('friendships')
          .where('users', arrayContains: currentUserId)
          .snapshots(),
      builder: (context, friendshipSnapshot) {
        if (!friendshipSnapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        // Get list of friend IDs
        Set<String> friendIds = {};
        for (var doc in friendshipSnapshot.data!.docs) {
          List<String> users = List<String>.from(doc['users']);
          friendIds.add(users.firstWhere((id) => id != currentUserId));
        }
        // Add current user to include them in friends leaderboard
        friendIds.add(currentUserId);

        return StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('players')
              .where(FieldPath.documentId, whereIn: 
                  friendIds.isEmpty ? [currentUserId] : friendIds.toList())
              .snapshots(),
          builder: (context, playerSnapshot) {
            if (!playerSnapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }

            List<Map<String, dynamic>> playerRankings = [];
            for (var doc in playerSnapshot.data!.docs) {
              final data = doc.data() as Map<String, dynamic>;
              final levelStars = Map<String, dynamic>.from(data['levelStars'] ?? {});
              int totalStars = levelStars.values.fold(0, (sum, stars) => sum + (stars as int));
              
              playerRankings.add({
                'name': data['name'],
                'totalStars': totalStars,
                'id': doc.id,
              });
            }

            playerRankings.sort((a, b) => b['totalStars'].compareTo(a['totalStars']));

            return _buildLeaderboardList(playerRankings);
          },
        );
      },
    );
  }
}

Widget _buildLeaderboardList(List<Map<String, dynamic>> rankings) {
  return Builder(
    builder: (context) {
      final authViewModel = Provider.of<AuthViewModel>(context);
      final currentUserId = authViewModel.user!.uid;

      return ListView.builder(
        itemCount: rankings.length,
        itemBuilder: (context, index) {
          final player = rankings[index];
          final isCurrentUser = player['id'] == currentUserId;

          return Container(
            decoration: isCurrentUser ? BoxDecoration(
              color: Colors.blue.withOpacity(0.1),
              border: Border.symmetric(
                horizontal: BorderSide(
                  color: Colors.blue.withOpacity(0.3),
                  width: 1,
                ),
              ),
            ) : null,
            child: ListTile(
              leading: CircleAvatar(
                backgroundImage: player['profilePicUrl'] != null 
                    ? NetworkImage(player['profilePicUrl']) 
                    : const AssetImage('assets/default_profile_pic.jpg') as ImageProvider, // Default image if no URL
              ),
              title: Row(
                children: [
                  Text(
                    player['name'],
                    style: TextStyle(
                      fontWeight: isCurrentUser ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                  if (isCurrentUser) 
                    const Padding(
                      padding: EdgeInsets.only(left: 8.0),
                      child: Text(
                        '(You)',
                        style: TextStyle(
                          color: Colors.blue,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                ],
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.star, color: Colors.amber, size: 20),
                  const SizedBox(width: 4),
                  Text(
                    '${player['totalStars']}',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: isCurrentUser ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );
    }
  );
}

Widget _buildRankWidget(int rank) {
  Color backgroundColor;
  Color textColor = Colors.white;
  
  switch (rank) {
    case 1:
      backgroundColor = Colors.amber; // Gold
      break;
    case 2:
      backgroundColor = Colors.grey[300]!; // Silver
      textColor = Colors.black87;
      break;
    case 3:
      backgroundColor = Colors.brown[300]!; // Bronze
      break;
    default:
      backgroundColor = Colors.blue;
  }

  return Container(
    width: 30,
    height: 30,
    decoration: BoxDecoration(
      color: backgroundColor,
      shape: BoxShape.circle,
    ),
    child: Center(
      child: Text(
        '$rank',
        style: TextStyle(
          color: textColor,
          fontWeight: FontWeight.bold,
        ),
      ),
    ),
  );
} 