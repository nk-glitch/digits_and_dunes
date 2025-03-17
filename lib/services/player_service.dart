import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/player.dart';

class PlayerService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Create new player document
  Future<void> createPlayer(
    String uid, 
    String name, 
    String email, 
    {String? profilePicUrl}
  ) async {
    try {
      // Instead of nested arrays, create a map with world-level keys
      Map<String, int> levelStars = {};
      
      // Initialize all levels with 0 stars (4 worlds, 10 levels each)
      for (int world = 0; world < 4; world++) {
        for (int level = 0; level < 10; level++) {
          // Create keys like "0-0", "0-1", "1-0", etc.
          String key = '$world-$level';
          levelStars[key] = 0;
        }
      }
      
      final player = {
        'id': uid,
        'name': name,
        'email': email,
        'profilePicUrl': profilePicUrl,
        'levelStars': levelStars,
        'worldsUnlocked': [true, false, false, false], // Only first world unlocked
        'trophiesEarned': [false, false, false, false],
      };
      
      await _db.collection('players').doc(uid).set(player);
    } catch (e) {
      print('Error creating player: $e');
      rethrow;
    }
  }

  // Get player data
  Future<Player> getPlayer(String uid) async {
    DocumentSnapshot doc = await _db.collection('players').doc(uid).get();
    if (!doc.exists) {
      throw Exception('Player not found');
    }
    return Player.fromFirestore(doc);
  }

  // Update level stars
  Future<void> updateLevelStars(String uid, int worldIndex, int levelIndex, int newStars) async {
    try {
      DocumentReference playerRef = _db.collection('players').doc(uid);
      String key = '$worldIndex-$levelIndex';
      
      DocumentSnapshot doc = await playerRef.get();
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      Map<String, dynamic> levelStars = Map<String, dynamic>.from(data['levelStars'] ?? {});
      List<bool> worldsUnlocked = List<bool>.from(data['worldsUnlocked'] ?? [true, false, false, false]);

      // Only update if new stars are higher
      int currentStars = levelStars[key] ?? 0;
      if (newStars > currentStars) {
        levelStars[key] = newStars;
        
        // Check if all levels in current world have at least 1 star
        bool allLevelsCompleted = true;
        for (int level = 0; level < 10; level++) {
          String levelKey = '$worldIndex-$level';
          if ((levelStars[levelKey] ?? 0) == 0) {
            allLevelsCompleted = false;
            break;
          }
        }

        // If all levels completed and not the last world, unlock next world
        if (allLevelsCompleted && worldIndex < 3) {
          worldsUnlocked[worldIndex + 1] = true;
        }

        // Update both stars and world unlock status
        await playerRef.update({
          'levelStars': levelStars,
          'worldsUnlocked': worldsUnlocked,
        });

        // After updating stars, check for trophy eligibility
        await checkTrophyEligibility(uid, worldIndex);
      }
    } catch (e) {
      print('Error updating stars: $e');
      rethrow;
    }
  }

  // Get stars for a specific level
  Future<int> getLevelStars(String uid, int worldIndex, int levelIndex) async {
    try {
      DocumentSnapshot doc = await _db.collection('players').doc(uid).get();
      if (!doc.exists) {
        await createPlayer(uid, '', '');
        return 0;
      }
      
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      Map<String, dynamic> levelStars = Map<String, dynamic>.from(data['levelStars'] ?? {});
      String key = '$worldIndex-$levelIndex';
      return levelStars[key] ?? 0;
    } catch (e) {
      print('Error getting level stars: $e');
      return 0;
    }
  }

  // Get all stars for a world
  Future<List<int>> getWorldStars(String uid, int worldIndex) async {
    try {
      DocumentSnapshot doc = await _db.collection('players').doc(uid).get();
      if (!doc.exists) {
        await createPlayer(uid, '', '');
        return List.filled(10, 0);
      }
      
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      Map<String, dynamic> levelStars = Map<String, dynamic>.from(data['levelStars'] ?? {});
      
      List<int> worldStars = List.filled(10, 0);
      for (int level = 0; level < 10; level++) {
        String key = '$worldIndex-$level';
        worldStars[level] = levelStars[key] ?? 0;
      }
      
      return worldStars;
    } catch (e) {
      print('Error getting world stars: $e');
      return List.filled(10, 0);
    }
  }

  // Save player data to Firestore
  Future<void> savePlayer(Player player) async {
    try {
      await _db.collection('players').doc(player.id).set(player.toMap());
      print('Player saved successfully');
    } catch (e) {
      print('Error saving player: $e');
      rethrow; // Handle the error appropriately
    }
  }

  // Update player data in Firestore (e.g., after level up or earning stars)
  Future<void> updatePlayer(Player player) async {
    try {
      await _db.collection('players').doc(player.id).update(player.toMap());
      print('Player updated successfully');
    } catch (e) {
      print('Error updating player: $e');
      rethrow; // Handle the error appropriately
    }
  }

  // Example method to fetch a list of all players (if needed)
  Future<List<Player>> getAllPlayers() async {
    try {
      QuerySnapshot<Map<String, dynamic>> snapshot =
      await _db.collection('players').get();
      return snapshot.docs
          .map((doc) => Player.fromFirestore(doc))
          .toList();
    } catch (e) {
      print('Error fetching players: $e');
      rethrow; // Handle the error appropriately
    }
  }

  // Add method to check if world is unlocked
  Future<bool> isWorldUnlocked(String uid, int worldIndex) async {
    try {
      DocumentSnapshot doc = await _db.collection('players').doc(uid).get();
      if (!doc.exists) return worldIndex == 0;
      
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      List<bool> worldsUnlocked = List<bool>.from(data['worldsUnlocked'] ?? [true, false, false, false]);
      return worldsUnlocked[worldIndex];
    } catch (e) {
      print('Error checking world unlock status: $e');
      return worldIndex == 0;
    }
  }

  Future<void> checkTrophyEligibility(String uid, int worldIndex) async {
    try {
      DocumentReference playerRef = _db.collection('players').doc(uid);
      DocumentSnapshot doc = await playerRef.get();
      
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      Map<String, dynamic> levelStars = Map<String, dynamic>.from(data['levelStars'] ?? {});
      List<bool> trophiesEarned = List<bool>.from(data['trophiesEarned'] ?? [false, false, false, false]);

      // Check if all levels in the world have 3 stars
      bool allThreeStars = true;
      for (int level = 0; level < 10; level++) {
        String key = '$worldIndex-$level';
        if ((levelStars[key] ?? 0) < 3) {
          allThreeStars = false;
          break;
        }
      }

      // Update trophy status if earned
      if (allThreeStars && !trophiesEarned[worldIndex]) {
        trophiesEarned[worldIndex] = true;
        await playerRef.update({
          'trophiesEarned': trophiesEarned,
        });
      }
    } catch (e) {
      print('Error checking trophy eligibility: $e');
    }
  }
}
