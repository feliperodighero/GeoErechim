import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geoerechim/pages/ranking_page.dart';

class TopThreeRanking extends StatelessWidget {
  const TopThreeRanking({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color(0xFF1F6F3F),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      elevation: 6,
      margin: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.emoji_events, color: Color(0xFFFFD700), size: 30),
                SizedBox(width: 10),
                Text(
                  "Pódio dos Melhores",
                  style: TextStyle(
                    fontSize: 22,
                    color: Colors.white,
                    fontFamily: 'Lilita One',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 15),
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('gameResults')
                  .orderBy('totalScore', descending: true)
                  .limit(3)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Text(
                    "O pódio aguarda os primeiros campeões!",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white70, fontSize: 16),
                  );
                }

                final results = snapshot.data!.docs;

                return Column(
                  children: List.generate(results.length, (index) {
                    final result = results[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                      child: Row(
                        children: [
                          Text(
                            '#${index + 1}',
                            style: const TextStyle(
                              color: Color(0xFFFFD700),
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(width: 15),
                          Expanded(
                            child: Text(
                              result['playerName'],
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Text(
                            '${result['totalScore']} pts',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                );
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0E3321),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const RankingPage()),
                );
              },
              child: const Text(
                'Ver Ranking Completo',
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'Lilita One',
                  fontSize: 18,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}