import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/auth_viewmodel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TreasureRoomPage extends StatelessWidget {
  const TreasureRoomPage({super.key});

  @override
  Widget build(BuildContext context) {
    final authViewModel = Provider.of<AuthViewModel>(context);

    // Check if the user is logged in
    if (authViewModel.user == null) {
      // Redirect to login page or show a message
      return Scaffold(
        appBar: AppBar(
          title: const Text('Treasure Room'),
          backgroundColor: Colors.amber[700],
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('You need to be logged in to access this page.'),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/login'); // Redirect to login
                },
                child: const Text('Login'),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Treasure Room'),
        backgroundColor: Colors.amber[700],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.amber[200]!,
              Colors.amber[700]!,
            ],
          ),
        ),
        child: StreamBuilder<DocumentSnapshot>(
          stream: FirebaseFirestore.instance
              .collection('players')
              .doc(authViewModel.user!.uid)
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }

            Map<String, dynamic> data = snapshot.data!.data() as Map<String, dynamic>;
            List<bool> trophiesEarned = List<bool>.from(data['trophiesEarned'] ?? [false, false, false, false]);

            return GridView.count(
              crossAxisCount: 2,
              padding: const EdgeInsets.all(16),
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              childAspectRatio: 0.85,
              children: [
                _buildTrophy(
                  context,
                  "Desert Master",
                  "World 1",
                  Colors.blue,
                  trophiesEarned[0],
                  Icons.terrain,
                ),
                _buildTrophy(
                  context,
                  "Oasis Champion",
                  "World 2",
                  Colors.green,
                  trophiesEarned[1],
                  Icons.park,
                ),
                _buildTrophy(
                  context,
                  "Pyramid Conqueror",
                  "World 3",
                  Colors.orange,
                  trophiesEarned[2],
                  Icons.account_balance,
                ),
                _buildTrophy(
                  context,
                  "Ancient Legend",
                  "World 4",
                  Colors.purple,
                  trophiesEarned[3],
                  Icons.temple_buddhist,
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildTrophy(BuildContext context, String title, String world, 
      Color color, bool isEarned, IconData trophyIcon) {
    return Card(
      elevation: isEarned ? 8 : 2,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: isEarned 
                ? [color.withOpacity(0.7), color]
                : [Colors.grey[300]!, Colors.grey[400]!],
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: LayoutBuilder(
            builder: (context, constraints) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: constraints.maxHeight * 0.5,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Icon(
                          Icons.emoji_events,
                          size: constraints.maxHeight * 0.45,
                          color: isEarned ? Colors.amber : Colors.grey[500],
                        ),
                        Positioned(
                          top: constraints.maxHeight * 0.15,
                          child: Icon(
                            trophyIcon,
                            size: constraints.maxHeight * 0.15,
                            color: isEarned ? color : Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      title,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: isEarned ? Colors.white : Colors.grey[600],
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    world,
                    style: TextStyle(
                      fontSize: 14,
                      color: isEarned ? Colors.white70 : Colors.grey[500],
                    ),
                  ),
                  if (isEarned)
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(Icons.star, color: Colors.amber, size: 14),
                          Icon(Icons.star, color: Colors.amber, size: 14),
                          Icon(Icons.star, color: Colors.amber, size: 14),
                        ],
                      ),
                    ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
