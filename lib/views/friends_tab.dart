import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import '../viewmodels/auth_viewmodel.dart';

class FriendsTab extends StatefulWidget {
  const FriendsTab({super.key});

  @override
  State<FriendsTab> createState() => _FriendsTabState();
}

class _FriendsTabState extends State<FriendsTab> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final authViewModel = Provider.of<AuthViewModel>(context);
    final currentUserId = authViewModel.user!.uid;

    return Column(
      children: [
        // Search Bar
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Search players...',
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16),
            ),
            onChanged: (value) {
              setState(() {
                _searchQuery = value.toLowerCase();
              });
            },
          ),
        ),

        // Friend Requests Section
        StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('friendRequests')
              .where('receiverId', isEqualTo: currentUserId)
              .where('status', isEqualTo: 'pending')
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return const SizedBox.shrink();
            }

            return Expanded(
              flex: 1,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      'Friend Requests',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        final request = snapshot.data!.docs[index];
                        return FutureBuilder<DocumentSnapshot>(
                          future: FirebaseFirestore.instance
                              .collection('players')
                              .doc(request['senderId'])
                              .get(),
                          builder: (context, senderSnapshot) {
                            if (!senderSnapshot.hasData || !senderSnapshot.data!.exists) {
                              return const SizedBox.shrink();
                            }
                            
                            final senderData = senderSnapshot.data!.data() as Map<String, dynamic>;
                            
                            return ListTile(
                              leading: const CircleAvatar(
                                child: Icon(Icons.person),
                              ),
                              title: Text(senderData['name'] ?? 'Unknown'),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.check, color: Colors.green),
                                    onPressed: () => _acceptFriendRequest(request.id),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.close, color: Colors.red),
                                    onPressed: () => _declineFriendRequest(request.id),
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        ),

        // Search Results or Friends List
        Expanded(
          flex: 2,
          child: _searchQuery.isEmpty
              ? _buildFriendsList(currentUserId)
              : _buildSearchResults(currentUserId),
        ),
      ],
    );
  }

  Widget _buildFriendsList(String currentUserId) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Friends Header
        const Padding(
          padding: EdgeInsets.all(8.0),
          child: Text(
            'Friends',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        
        // Friends List
        Expanded(
          child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('friendships')
                .where('users', arrayContains: currentUserId)
                .snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }

              if (snapshot.data!.docs.isEmpty) {
                return const Center(
                  child: Text(
                    'No friends yet',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 16,
                    ),
                  ),
                );
              }

              return ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  final friendship = snapshot.data!.docs[index];
                  final friendData = friendship.data() as Map<String, dynamic>;
                  final List<String> users = List<String>.from(friendData['users']);
                  final friendId = users.firstWhere((id) => id != currentUserId);

                  return FutureBuilder<DocumentSnapshot>(
                    future: FirebaseFirestore.instance
                        .collection('players')
                        .doc(friendId)
                        .get(),
                    builder: (context, friendSnapshot) {
                      if (!friendSnapshot.hasData || !friendSnapshot.data!.exists) {
                        return const SizedBox.shrink();
                      }

                      final friendInfo = friendSnapshot.data!.data() as Map<String, dynamic>;

                      return ListTile(
                        leading: const CircleAvatar(
                          child: Icon(Icons.person),
                        ),
                        title: Text(friendInfo['name'] ?? 'Unknown'),
                        trailing: IconButton(
                          icon: const Icon(Icons.person_remove),
                          onPressed: () => _removeFriend(friendship.id),
                        ),
                      );
                    },
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildSearchResults(String currentUserId) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('players')
          .where('name', isGreaterThanOrEqualTo: _searchQuery)
          .where('name', isLessThan: _searchQuery + 'z')
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        return ListView.builder(
          itemCount: snapshot.data!.docs.length,
          itemBuilder: (context, index) {
            final player = snapshot.data!.docs[index];
            if (!player.exists) return const SizedBox.shrink();
            
            final playerData = player.data() as Map<String, dynamic>;
            final playerId = player.id;

            if (playerId == currentUserId) return const SizedBox.shrink();

            return FutureBuilder<List<bool>>(
              future: Future.wait([
                _checkFriendshipStatus(currentUserId, playerId),
                _checkExistingFriendRequest(currentUserId, playerId),
              ]),
              builder: (context, statusSnapshot) {
                if (!statusSnapshot.hasData) {
                  return ListTile(
                    leading: const CircleAvatar(child: Icon(Icons.person)),
                    title: Text(playerData['name'] ?? 'Unknown'),
                    trailing: const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  );
                }

                final isFriend = statusSnapshot.data![0];
                final requestSent = statusSnapshot.data![1];

                return ListTile(
                  leading: const CircleAvatar(child: Icon(Icons.person)),
                  title: Text(playerData['name'] ?? 'Unknown'),
                  trailing: isFriend
                      ? const Icon(Icons.check_circle, color: Colors.green)
                      : requestSent
                          ? const Icon(Icons.pending, color: Colors.grey)
                          : IconButton(
                              icon: const Icon(Icons.person_add),
                              onPressed: () => _sendFriendRequest(currentUserId, playerId),
                            ),
                );
              },
            );
          },
        );
      },
    );
  }

  Future<bool> _checkFriendshipStatus(String userId1, String userId2) async {
    final doc = await FirebaseFirestore.instance
        .collection('friendships')
        .doc(_generateFriendshipId(userId1, userId2))
        .get();
    return doc.exists;
  }

  String _generateFriendshipId(String userId1, String userId2) {
    final sortedIds = [userId1, userId2]..sort();
    return '${sortedIds[0]}_${sortedIds[1]}';
  }

  Future<bool> _checkExistingFriendRequest(String senderId, String receiverId) async {
    final requests = await FirebaseFirestore.instance
        .collection('friendRequests')
        .where('senderId', isEqualTo: senderId)
        .where('receiverId', isEqualTo: receiverId)
        .where('status', isEqualTo: 'pending')
        .get();
    
    return requests.docs.isNotEmpty;
  }

  Future<void> _sendFriendRequest(String senderId, String receiverId) async {
    try {
      // Check if request already exists
      final requestExists = await _checkExistingFriendRequest(senderId, receiverId);
      
      if (requestExists) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Already Sent Request to Player!'),
            duration: Duration(seconds: 2),
          ),
        );
        return;
      }

      // Check if they're already friends
      final areFriends = await _checkFriendshipStatus(senderId, receiverId);
      if (areFriends) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Already Friends with Player!'),
            duration: Duration(seconds: 2),
          ),
        );
        return;
      }

      // If neither friends nor request exists, send new request
      await FirebaseFirestore.instance.collection('friendRequests').add({
        'senderId': senderId,
        'receiverId': receiverId,
        'status': 'pending',
        'timestamp': FieldValue.serverTimestamp(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Friend Request Sent!'),
          duration: Duration(seconds: 2),
        ),
      );
    } catch (e) {
      print('Error sending friend request: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Error sending friend request'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  Future<void> _acceptFriendRequest(String requestId) async {
    try {
      final request = await FirebaseFirestore.instance
          .collection('friendRequests')
          .doc(requestId)
          .get();
      final data = request.data() as Map<String, dynamic>;

      // Create friendship document with proper array format
      await FirebaseFirestore.instance
          .collection('friendships')
          .doc(_generateFriendshipId(data['senderId'], data['receiverId']))
          .set({
            'users': [data['senderId'], data['receiverId']], // This creates a proper array
            'timestamp': FieldValue.serverTimestamp(),
          });

      // Delete the request
      await FirebaseFirestore.instance
          .collection('friendRequests')
          .doc(requestId)
          .delete();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Friend request accepted!')),
      );
    } catch (e) {
      print('Error accepting friend request: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error accepting friend request')),
      );
    }
  }

  Future<void> _declineFriendRequest(String requestId) async {
    await FirebaseFirestore.instance
        .collection('friendRequests')
        .doc(requestId)
        .delete();
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Friend request declined')),
    );
  }

  int _calculateTotalStars(Map<String, dynamic> playerData) {
    final levelStars = Map<String, dynamic>.from(playerData['levelStars'] ?? {});
    return levelStars.values.fold(0, (sum, stars) => sum + (stars as int));
  }

  Future<void> _removeFriend(String friendshipId) async {
    try {
      await FirebaseFirestore.instance
          .collection('friendships')
          .doc(friendshipId)
          .delete();
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Friend removed')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error removing friend')),
      );
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
} 