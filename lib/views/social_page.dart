import 'package:flutter/material.dart';
import 'friends_tab.dart';
import 'leaderboards_tab.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../viewmodels/auth_viewmodel.dart';

class SocialPage extends StatelessWidget {
  const SocialPage({super.key});

  @override
  Widget build(BuildContext context) {
    final authViewModel = Provider.of<AuthViewModel>(context);
    final currentUserId = authViewModel.user?.uid;

    // Check if the user is logged in
    if (currentUserId == null) {
      // Redirect to login page or show a message
      return Scaffold(
        appBar: AppBar(title: const Text('Social')),
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

    return DefaultTabController(
      length: 2,
      child: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('players')
            .doc(currentUserId)
            .snapshots(),
        builder: (context, snapshot) {
          String userName = 'Loading...';
          if (snapshot.hasData && snapshot.data!.exists) {
            final userData = snapshot.data!.data() as Map<String, dynamic>;
            userName = userData['name'] ?? 'User';
          }

          return Scaffold(
            appBar: AppBar(
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Social'),
                  Text(
                    userName,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ],
              ),
              bottom: const TabBar(
                tabs: [
                  Tab(text: 'Friends'),
                  Tab(text: 'Leaderboards'),
                ],
              ),
            ),
            body: const TabBarView(
              children: [
                FriendsTab(),
                LeaderboardsTab(),
              ],
            ),
          );
        },
      ),
    );
  }
} 