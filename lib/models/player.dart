import 'package:cloud_firestore/cloud_firestore.dart';

class Player {
  final String id;
  final String username;
  final String password; // Will handle encryption later
  int level;
  String world;
  List<List<int>> levelStars; // 2D list to track stars for each world and level
  List<bool> trophies; // List to track trophies for each world (1 trophy per world)
  int coins;

  // Constructor to initialize a player object
  Player({
    required this.id,
    required this.username,
    required this.password,
    this.level = 1, // Default to level 1
    this.world = 'World 1', // Default starting world
    this.levelStars = const [
      [0, 0, 0, 0, 0, 0, 0, 0, 0, 0], // World 1 stars
      [0, 0, 0, 0, 0, 0, 0, 0, 0, 0], // World 2 stars
      [0, 0, 0, 0, 0, 0, 0, 0, 0, 0], // World 3 stars
      [0, 0, 0, 0, 0, 0, 0, 0, 0, 0], // World 4 stars
    ], // Default: no stars for any level in any world
    this.trophies = const [false, false, false, false], // Default: no trophies for any world
    this.coins = 0, // Default to 0 coins
  });

  // Method to calculate the total stars in a given world (index 0 to 3)
  int getTotalStarsInWorld(int worldIndex) {
    return levelStars[worldIndex].reduce((sum, stars) => sum + stars);
  }

  // Method to check if the player has earned a trophy for a world
  void checkTrophy(int worldIndex) {
    // The player earns the trophy for a world if they have 3 stars on every level in that world
    if (levelStars[worldIndex].every((stars) => stars == 3)) {
      trophies[worldIndex] = true; // Earn the trophy
    }
  }

  // Example method to update stars for a level in a specific world
  void updateStars(int worldIndex, int levelIndex, int stars) {
    if (stars >= 0 && stars <= 3) {
      levelStars[worldIndex][levelIndex] = stars;
      checkTrophy(worldIndex); // Check if the player earned a trophy after updating stars
    }
  }

  // Method to increase level (only if the player has completed the current level)
  void levelUp() {
    if (levelStars[level - 1][level - 1] >= 1) { // Can only level up if the current level has at least 1 star
      level++;
    }
  }

  // Example method to add coins
  void addCoins(int amount) {
    coins += amount;
  }

  // Convert the Player object into a Map to be stored in Firestore
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'username': username,
      'password': password, // Encrypt later
      'level': level,
      'world': world,
      'levelStars': levelStars,
      'trophies': trophies,
      'coins': coins,
    };
  }

  // Create a Player object from a Firestore document snapshot
  factory Player.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data()!;
    return Player(
      id: doc.id,
      username: data['username'],
      password: data['password'],
      level: data['level'],
      world: data['world'],
      levelStars: List<List<int>>.from(data['levelStars']),
      trophies: List<bool>.from(data['trophies']),
      coins: data['coins'],
    );
  }

  // Method to display player data (for debugging or testing purposes)
  @override
  String toString() {
    return 'Player(id: $id, username: $username, level: $level, world: $world, trophies: $trophies, coins: $coins)';
  }
}
