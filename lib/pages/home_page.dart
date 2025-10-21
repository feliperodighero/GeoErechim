import 'package:flutter/material.dart';
import 'package:geoerechim/widgets/custom_buttom.dart';
import 'games_mode_page.dart';
import 'package:geoerechim/widgets/player_name_dialog.dart';
import 'package:provider/provider.dart';
import 'package:geoerechim/providers/game_state.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0E3321),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'lib/assets/images/Logo.png',
              height: 130,
            ),
            const Text(
              "Explore a geografia de Erechim de forma divertida!",
              style: TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w400,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 200),
            CustomButton(
              text: "Jogar",
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => PlayerNameDialog(
                    onConfirm: (playerName) {
                      Provider.of<GameState>(context, listen: false)
                          .setPlayerName(playerName);
                      Navigator.of(context).pop(); // Fecha o diálogo
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const GameModesPage()),
                      );
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
