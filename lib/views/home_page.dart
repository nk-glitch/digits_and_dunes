import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/player_service.dart';
import '../models/player.dart';
import '../viewmodels/auth_viewmodel.dart';
import 'social_page.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';


class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final PlayerService _playerService = PlayerService();
  Player? _player;

  @override
  void initState() {
    super.initState();
    // _loadPlayerData();
  }

  // Future<void> _loadPlayerData() async {
  //   final authViewModel = Provider.of<AuthViewModel>(context, listen: false);
  //   final user = authViewModel.user;
  //
  //   if (user != null) {
  //     try {
  //       Player? player = await _playerService.getPlayer(user.uid);
  //       if (player != null) {
  //         setState(() {
  //           _player = player;
  //         });
  //       }
  //     } catch (e) {
  //       print('Error fetching player: $e');
  //     }
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    final authViewModel = Provider.of<AuthViewModel>(context);
    final user = authViewModel.user;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Digits and Dunes'),
        actions: [
          if (user != null)
            IconButton(
              icon: const Icon(Icons.logout),
              onPressed: () {
                authViewModel.logout();
                Navigator.pushReplacementNamed(context, '/login');
              },
            ),
          IconButton(
            icon: const Icon(Icons.people),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const SocialPage()),
            ),
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.orange.shade200, Colors.orange.shade700],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (user == null)
                const Text(
                  'Please log in to see your player data.',
                  style: TextStyle(fontSize: 18, color: Colors.red),
                )
              else
                const Text(
                  'Welcome back!',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
                ),
              const SizedBox(height: 20),
              _buildCardButton(context, 'Play', Icons.play_arrow, () {
                if (user != null) {
                  Navigator.pushNamed(context, '/world_select');
                } else {
                  Navigator.pushNamed(context, '/login');
                }
              }),
              _buildCardButton(context, 'Credits', Icons.star, () {
                Navigator.pushNamed(context, '/credits');
              }),
              _buildCardButton(context, 'Treasure Room', FontAwesomeIcons.trophy, () {
                Navigator.pushNamed(context, '/treasure_room');
              }),
              // _buildCardButton(context, 'Settings', Icons.settings, () {
              //   Navigator.pushNamed(context, '/settings');
              // }),
              _buildCardButton(context, 'Instructions', Icons.help, () {
                Navigator.pushNamed(context, '/instructions');
              }),
              _buildCardButton(context, 'Social', Icons.people, () {
                Navigator.pushNamed(context, '/social');
              }),

              const SizedBox(height: 20),
              if (user != null)
                Align(
                  alignment: Alignment.bottomLeft,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      'Logged in as: ${user.displayName ?? user.email}',
                      style: const TextStyle(fontSize: 16, color: Colors.white70),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCardButton(BuildContext context, String title, IconData icon, VoidCallback onPressed) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      elevation: 5,
      child: InkWell(
        onTap: onPressed,
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            gradient: LinearGradient(
              colors: [Colors.blue.shade300, Colors.blue.shade600],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: Colors.white),
              const SizedBox(width: 10),
              Text(
                title,
                style: const TextStyle(fontSize: 20, color: Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
