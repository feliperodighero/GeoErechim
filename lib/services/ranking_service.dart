import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geoerechim/utils/enums/game_modes.dart';

class RankingService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  /// Atualiza a pontuação do usuário após uma partida concluída.
  /// O `score_geral` é somado infinitamente.
  /// Os scores dos modos guardam apenas a pontuação máxima (recorde).
  Future<void> saveScore({
    required String uid,
    required String displayName,
    required String? photoUrl,
    required GameMode mode,
    required int finalScore,
  }) async {
    final docRef = _db.collection('users').doc(uid);
    
    // Obter os dados atuais
    final snapshot = await docRef.get();
    
    Map<String, dynamic> dataToSave = {
      'displayName': displayName,
      'photoUrl': photoUrl,
      'lastPlayedAt': FieldValue.serverTimestamp(),
    };

    if (!snapshot.exists) {
      dataToSave['score_geral'] = finalScore;
      dataToSave['score_praca'] = mode == GameMode.pracaDaBandeira ? finalScore : 0;
      dataToSave['score_castelinho'] = mode == GameMode.castelinho ? finalScore : 0;
      dataToSave['score_seminario'] = mode == GameMode.seminario ? finalScore : 0;
      await docRef.set(dataToSave);
      return;
    }

    final currentData = snapshot.data()!;
    int currentGeral = currentData['score_geral'] ?? 0;
    dataToSave['score_geral'] = currentGeral + finalScore;

    String modeField;
    switch (mode) {
      case GameMode.pracaDaBandeira:
        modeField = 'score_praca';
        break;
      case GameMode.castelinho:
        modeField = 'score_castelinho';
        break;
      case GameMode.seminario:
        modeField = 'score_seminario';
        break;
    }

    int currentModeScore = currentData[modeField] ?? 0;
    if (finalScore > currentModeScore) {
      dataToSave[modeField] = finalScore;
    }

    await docRef.update(dataToSave);
  }

  /// Retorna o fluxo de usuários ordenados decrescentemente por pontuação na categoria desejada.
  Stream<QuerySnapshot> getTopPlayers(String categoryField, {int maxLimit = 50}) {
    // categoryField deve ser um de: 'score_geral', 'score_praca', 'score_castelinho', 'score_seminario'
    return _db
        .collection('users')
        .orderBy(categoryField, descending: true)
        .limit(maxLimit)
        .snapshots();
  }
}
