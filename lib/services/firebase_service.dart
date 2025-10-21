import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addGameResult(String playerName, int totalScore) async {
    await _firestore.collection('gameResults').add({
      'playerName': playerName,
      'totalScore': totalScore,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }
}