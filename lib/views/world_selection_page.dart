import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/auth_viewmodel.dart';
import '../services/player_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class WorldSelectionPage extends StatelessWidget {
  const WorldSelectionPage({super.key});

  @override
  Widget build(BuildContext context) {
    final authViewModel = Provider.of<AuthViewModel>(context);
    final playerService = PlayerService();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Select World'),
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('players')
            .doc(authViewModel.user!.uid)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          Map<String, dynamic> data = snapshot.data!.data() as Map<String, dynamic>;
          List<bool> worldsUnlocked = List<bool>.from(data['worldsUnlocked'] ?? [true, false, false, false]);

          return GridView.count(
            crossAxisCount: 2,
            padding: const EdgeInsets.all(16),
            children: [
              _buildWorldCard(context, 1, Colors.blue, worldsUnlocked[0]),
              _buildWorldCard(context, 2, Colors.green, worldsUnlocked[1]),
              _buildWorldCard(context, 3, Colors.orange, worldsUnlocked[2]),
              _buildWorldCard(context, 4, Colors.purple, worldsUnlocked[3]),
            ],
          );
        },
      ),
    );
  }

  Widget _buildWorldCard(BuildContext context, int worldNumber, Color color, bool isUnlocked) {
    return Card(
      child: InkWell(
        onTap: isUnlocked ? () {
          Navigator.pushNamed(context, '/world$worldNumber');
        } : null,
        child: Container(
          decoration: BoxDecoration(
            color: isUnlocked ? color : Colors.grey,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'World $worldNumber',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: isUnlocked ? Colors.white : Colors.white60,
                    ),
                  ),
                ],
              ),
              if (!isUnlocked)
                const Icon(
                  Icons.lock,
                  size: 48,
                  color: Colors.white70,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
