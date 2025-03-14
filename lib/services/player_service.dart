import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/player.dart';

class PlayerService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

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

  // Fetch player data from Firestore
  Future<Player?> getPlayer(String playerId) async {
    try {
      DocumentSnapshot<Map<String, dynamic>> docSnapshot =
      await _db.collection('players').doc(playerId).get();
      if (docSnapshot.exists) {
        return Player.fromFirestore(docSnapshot);
      } else {
        print('Player not found');
        return null;
      }
    } catch (e) {
      print('Error fetching player: $e');
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
}
