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
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text(
          'Choose Your Adventure',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            shadows: [
              Shadow(
                offset: Offset(1, 1),
                blurRadius: 3,
                color: Colors.black45,
              ),
            ],
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.home, color: Colors.white),
          onPressed: () => Navigator.pushReplacementNamed(context, '/home'),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.orange.shade300,
              Colors.deepOrange.shade600,
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
            List<bool> worldsUnlocked = List<bool>.from(data['worldsUnlocked'] ?? [true, false, false, false]);

            return SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(left: 8, bottom: 16),
                      child: Text(
                        'Your Journey Awaits...',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white70,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    Expanded(
                      child: GridView.count(
                        crossAxisCount: 1,
                        childAspectRatio: 2,
                        mainAxisSpacing: 16,
                        children: [
                          _buildWorldCard(
                            context, 
                            1, 
                            Colors.orange.shade400,
                            worldsUnlocked[0], 
                            'Desert Mirage',
                            'A vast desert where mysteries and mathematics intertwine.',
                            Icons.landscape,
                          ),
                          _buildWorldCard(
                            context, 
                            2, 
                            Colors.teal.shade400,
                            worldsUnlocked[1], 
                            'Oasis Haven',
                            'A lush oasis where numbers flow like water.',
                            Icons.park,
                          ),
                          _buildWorldCard(
                            context, 
                            3, 
                            Colors.amber.shade600,
                            worldsUnlocked[2], 
                            'Pyramid Peaks',
                            'Ancient pyramids hold the secrets of mathematics.',
                            Icons.account_balance,
                          ),
                          _buildWorldCard(
                            context, 
                            4, 
                            Colors.deepPurple.shade400,
                            worldsUnlocked[3], 
                            'Ancient Ruins',
                            'Discover the mathematical legacy of a lost civilization.',
                            Icons.temple_buddhist,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildWorldCard(
    BuildContext context, 
    int worldNumber, 
    Color color, 
    bool isUnlocked, 
    String worldName,
    String description,
    IconData icon,
  ) {
    return Card(
      elevation: isUnlocked ? 8 : 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: InkWell(
        onTap: isUnlocked 
          ? () => Navigator.pushNamed(context, '/world$worldNumber')
          : () => ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Complete the previous world to unlock!'),
                duration: Duration(seconds: 2),
              ),
            ),
        borderRadius: BorderRadius.circular(20),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                isUnlocked ? color : Colors.grey.shade400,
                isUnlocked ? color.withOpacity(0.7) : Colors.grey.shade600,
              ],
            ),
            boxShadow: isUnlocked ? [
              BoxShadow(
                color: color.withOpacity(0.5),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ] : null,
          ),
          child: Stack(
            children: [
              if (!isUnlocked)
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.black26,
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            children: [
                              Text(
                                'World $worldNumber:',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: isUnlocked ? Colors.white70 : Colors.white38,
                                ),
                              ),
                              const SizedBox(width: 8),
                              if (!isUnlocked)
                                const Icon(
                                  Icons.lock,
                                  color: Colors.white38,
                                  size: 16,
                                ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            worldName,
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: isUnlocked ? Colors.white : Colors.white60,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            description,
                            style: TextStyle(
                              fontSize: 13,
                              height: 1.2,
                              color: isUnlocked ? Colors.white70 : Colors.white38,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      flex: 1,
                      child: Icon(
                        icon,
                        size: 48,
                        color: isUnlocked ? Colors.white.withOpacity(0.9) : Colors.white24,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
