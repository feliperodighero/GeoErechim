import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'game_page.dart';
import 'package:geoerechim/providers/game_state.dart';
import 'package:geoerechim/utils/enums/game_modes.dart';
import 'package:geoerechim/widgets/game_mode_card.dart';
import 'package:geoerechim/widgets/top_three_ranking.dart'; // Importe o novo widget

class GameModesPage extends StatelessWidget {
  const GameModesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0E3321),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0E3321),
        foregroundColor: Colors.white,
        title: const Text(
          "Modos de Jogo",
          style: TextStyle(
            color: Colors.white,
            fontFamily: 'Lilita One',
            fontSize: 24,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        automaticallyImplyLeading: false, // Remove a seta de voltar
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          GameModeCard(
            icon: Icons.flag,
            title: "Praça da Bandeira",
            description:
                "Modo livre: pode dar uma banda, dar zoom e explorar cada canto da cidade!",
            difficulty: "Barbada",
            onTap: () {
              Provider.of<GameState>(context, listen: false).resetGame();
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        const GamePage(mode: GameMode.pracaDaBandeira)),
              );
            },
          ),
          GameModeCard(
            icon: Icons.castle,
            title: "Castelinho",
            description:
                "Modo estático: parado feito poste, só roda a câmera e aproxima, barbaridade!",
            difficulty: "Mais ou Menos",
            onTap: () {
              Provider.of<GameState>(context, listen: false).resetGame();
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        const GamePage(mode: GameMode.castelinho)),
              );
            },
          ),
          GameModeCard(
            icon: Icons.church,
            title: "Seminário",
            description:
                "Modo desafiador: bagual de verdade não precisa andar, girar nem dar zoom. Só com a imagem descobre o local!",
            difficulty: "Peleia",
            onTap: () {
              Provider.of<GameState>(context, listen: false).resetGame();
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        const GamePage(mode: GameMode.seminario)),
              );
            },
          ),
          const SizedBox(height: 20),
          // Substitua o CustomButton pelo novo widget TopThreeRanking
          const TopThreeRanking(),
        ],
      ),
    );
  }
}