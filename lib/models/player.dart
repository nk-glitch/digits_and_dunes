import 'package:cloud_firestore/cloud_firestore.dart';

class Player {
  final String id;
  final String name;
  final String email;
  final List<List<int>> levelStars; // Stars for each level in each world
  final List<bool> worldsUnlocked;
  final List<bool> trophiesEarned;

  Player({
    required this.id,
    required this.name,
    required this.email,
    List<List<int>>? levelStars,
    List<bool>? worldsUnlocked,
    List<bool>? trophiesEarned,
  }) : 
    // Initialize with 4 worlds, 10 levels each, 0 stars initially
    levelStars = levelStars ?? List.generate(4, (_) => List.filled(10, 0)),
    // Initially only first world is unlocked
    worldsUnlocked = worldsUnlocked ?? List.generate(4, (index) => index == 0),
    // No trophies earned initially
    trophiesEarned = trophiesEarned ?? List.filled(4, false);

  // Check if player deserves trophy for a world
  void checkTrophy(int worldIndex) {
    if (worldIndex < 0 || worldIndex >= levelStars.length) return;
    
    // Need all 3 stars in all levels of the world to get trophy
    bool allThreeStars = levelStars[worldIndex].every((stars) => stars == 3);
    trophiesEarned[worldIndex] = allThreeStars;
  }

  // Convert to Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'levelStars': levelStars,
      'worldsUnlocked': worldsUnlocked,
      'trophiesEarned': trophiesEarned,
    };
  }

  // Create from Firestore document
  factory Player.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    
    // Convert the nested arrays from Firestore
    List<List<int>> stars = (data['levelStars'] as List)
        .map((world) => (world as List).map((stars) => stars as int).toList())
        .toList();

    return Player(
      id: doc.id,
      name: data['name'] ?? '',
      email: data['email'] ?? '',
      levelStars: stars,
      worldsUnlocked: (data['worldsUnlocked'] as List).map((e) => e as bool).toList(),
      trophiesEarned: (data['trophiesEarned'] as List).map((e) => e as bool).toList(),
    );
  }

  // Method to display player data (for debugging or testing purposes)
  @override
  String toString() {
    return 'Player(id: $id, name: $name, email: $email, levelStars: $levelStars, worldsUnlocked: $worldsUnlocked, trophiesEarned: $trophiesEarned)';
  }
}
