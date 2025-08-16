import 'package:flutter/material.dart';
import 'package:geoerechim/widgets/custom_buttom.dart';
import 'game_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("GeoErechim")),
      body: Center(
        child: CustomButton(
          text: "Jogar",
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const GamePage()),
            );
          },
        ),
      ),
    );
  }
}
