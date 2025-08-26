import 'package:flutter/material.dart';
import 'game_page.dart';
import 'package:geoerechim/utils/enums/game_modes.dart';
import 'package:geoerechim/widgets/game_mode_card.dart';

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
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          GameModeCard(
            icon: Icons.flag,
            title: "Praça da Bandeira",
            description:
                "Modo livre: você pode andar, dar zoom e explorar a cidade.",
            difficulty: "Fácil",
            record: 4200,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const GamePage(mode: GameMode.pracaDaBandeira,)),
              );
            },
          ),
          GameModeCard(
            icon: Icons.castle,
            title: "Castelinho",
            description:
                "Modo estático: você não pode andar, apenas girar a câmera e dar zoom.",
            difficulty: "Médio",
            record: 1500,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const GamePage(mode: GameMode.castelinho,)),
              );
            },
          ),
          GameModeCard(
            icon: Icons.church,
            title: "Seminário",
            description:
                "Modo desafiador: você não pode andar, girar a câmera ou dar zoom. Use apenas o que vê para adivinhar a localização.",
            difficulty: "Difícil",
            record: 2580,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const GamePage(mode: GameMode.seminario,)),
              );
            },
          ),
        ],
      ),
    );
  }
}
