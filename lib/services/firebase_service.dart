import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/level_progress.dart';

class FirebaseService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> saveLevelProgress(String userId, LevelProgress progress) async {
    await _db
        .collection('users')
        .doc(userId)
        .collection('progress')
        .doc('level_${progress.level}')
        .set(progress.toJson());
  }

  Future<LevelProgress?> getLevelProgress(String userId, int level) async {
    DocumentSnapshot doc = await _db
        .collection('users')
        .doc(userId)
        .collection('progress')
        .doc('level_$level')
        .get();

    if (doc.exists) {
      return LevelProgress.fromJson(doc.data() as Map<String, dynamic>);
    }
    return null;
  }
}
