import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/player_service.dart';
import '../models/player.dart';
import '../viewmodels/auth_viewmodel.dart';
import 'social_page.dart';


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
    _loadPlayerData();
  }

  Future<void> _loadPlayerData() async {
    final authViewModel = Provider.of<AuthViewModel>(context, listen: false);
    final user = authViewModel.user;

    if (user != null) {
      try {
        Player? player = await _playerService.getPlayer(user.uid);
        if (player != null) {
          setState(() {
            _player = player;
          });
        }
      } catch (e) {
        print('Error fetching player: $e');
      }
    }
  }

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
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (_player != null)
              Text(
                'Welcome, ${_player!.name}!',
                style: const TextStyle(fontSize: 24),
              )
            else if (user != null)
              const CircularProgressIndicator()
            else
              const Text(
                'Not logged in',
                style: TextStyle(fontSize: 18, color: Colors.red),
              ),
            ElevatedButton(
              onPressed: () {
                if (user != null) {
                  Navigator.pushNamed(context, '/world_select');
                } else {
                  Navigator.pushNamed(context, '/login');
                }
              },
              child: const Text('Play'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/credits');
              },
              child: const Text('Credits'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/treasure_room');
              },
              child: const Text('Treasure Room'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/settings');
              },
              child: const Text('Settings'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SocialPage()),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue[700],
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.people),
                  SizedBox(width: 8),
                  Text('Social'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
