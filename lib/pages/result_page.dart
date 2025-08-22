import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geoerechim/utils/calculate_distance.dart';

class ResultPage extends StatelessWidget {
  final LatLng streetViewPosition;
  final LatLng guessedPosition;
  final int points;

  const ResultPage({
    super.key,
    required this.streetViewPosition,
    required this.guessedPosition,
    required this.points,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Resultado"),
        backgroundColor: const Color(0xFF0E3321),
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'lib/assets/images/GeoErechimLogo.png',
              height: 70,
            ),
            Text(
              "Distância do ponto correto: ${calculateDistance(streetViewPosition, guessedPosition).toStringAsFixed(0)} metros",
              style: const TextStyle(fontSize: 18),
            ),
              const SizedBox(height: 20),
            Text(
              "Seus pontos: $points",
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context, true);
              },
              child: const Text("Próxima"),
            ),
          ],
        ),
      ),
    );
  }
}
