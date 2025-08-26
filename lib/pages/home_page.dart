import 'package:flutter/material.dart';
import 'package:geoerechim/widgets/custom_buttom.dart';
import 'games_mode_page.dart';

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
            Image.asset('lib/assets/images/Logo.png', height: 130,),

            const SizedBox(height: 200),

            CustomButton(
              text: "Jogar",
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const GameModesPage()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
