import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RankingPage extends StatelessWidget {
  const RankingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0E3321),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0E3321),
        foregroundColor: Colors.white,
        title: const Text(
          "Ranking dos Melhores",
          style: TextStyle(
            color: Colors.white,
            fontFamily: 'Lilita One',
            fontSize: 24,
          ),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('gameResults')
            .orderBy('totalScore', descending: true)
            .limit(20) // Limita aos 20 melhores resultados
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text(
                "Ainda não há resultados.\nSeja o primeiro a jogar!",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
            );
          }

          final results = snapshot.data!.docs;

          return ListView.builder(
            itemCount: results.length,
            itemBuilder: (context, index) {
              final result = results[index];
              final playerName = result['playerName'];
              final totalScore = result['totalScore'];

              return Card(
                color: const Color(0xFF1F6F3F),
                margin:
                    const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: ListTile(
                  leading: Text(
                    '#${index + 1}',
                    style: const TextStyle(
                      color: Color(0xFFFFD700),
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  title: Text(
                    playerName,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  trailing: Text(
                    '$totalScore pts',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}