import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geoerechim/services/ranking_service.dart';

class RankingPage extends StatefulWidget {
  const RankingPage({super.key});

  @override
  State<RankingPage> createState() => _RankingPageState();
}

class _RankingPageState extends State<RankingPage> {
  final RankingService _rankingService = RankingService();

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        backgroundColor: const Color(0xFF0E3321),
        appBar: AppBar(
          backgroundColor: const Color(0xFF0E3321),
          foregroundColor: Colors.white,
          title: const Text('Ranking Global'),
          bottom: const TabBar(
            isScrollable: true,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white54,
            indicatorColor: Colors.white,
            tabs: [
              Tab(text: "Geral"),
              Tab(text: "Praça da Bandeira"),
              Tab(text: "Castelinho"),
              Tab(text: "Seminário"),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildRankingList('score_geral'),
            _buildRankingList('score_praca'),
            _buildRankingList('score_castelinho'),
            _buildRankingList('score_seminario'),
          ],
        ),
      ),
    );
  }

  Widget _buildRankingList(String categoryField) {
    return StreamBuilder<QuerySnapshot>(
      stream: _rankingService.getTopPlayers(categoryField),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator(color: Colors.white));
        }

        if (snapshot.hasError) {
          return const Center(
            child: Text(
              'Erro ao carregar o ranking.',
              style: TextStyle(color: Colors.white),
            ),
          );
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(
            child: Text(
              'Nenhum jogador até agora.',
              style: TextStyle(color: Colors.white70),
            ),
          );
        }

        final docs = snapshot.data!.docs;
        
        // Remove os jogadores que tem 0 pontos 
        final filteredDocs = docs.where((doc) {
          final score = (doc.data() as Map<String, dynamic>)[categoryField] ?? 0;
          return score > 0;
        }).toList();

        if (filteredDocs.isEmpty) {
          return const Center(
            child: Text(
              'Ainda não há pontuação de ninguém aqui.',
              style: TextStyle(color: Colors.white70),
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: filteredDocs.length,
          itemBuilder: (context, index) {
            final data = filteredDocs[index].data() as Map<String, dynamic>;
            final score = data[categoryField] ?? 0;
            final name = data['displayName'] ?? 'Jogador Misterioso';
            final photoUrl = data['photoUrl'];

            return Card(
              color: Colors.white12,
              margin: const EdgeInsets.only(bottom: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.white24,
                  backgroundImage: photoUrl != null ? NetworkImage(photoUrl) : null,
                  child: photoUrl == null ? const Icon(Icons.person, color: Colors.white) : null,
                ),
                title: Text(
                  name,
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                ),
                subtitle: Text(
                  'Posição: #${index + 1}',
                  style: const TextStyle(color: Colors.white70),
                ),
                trailing: Text(
                  '$score pts',
                  style: const TextStyle(
                    color: Colors.amber,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
