import 'package:flutter/material.dart';
import 'package:flutter_google_street_view/flutter_google_street_view.dart';
import 'package:geoerechim/utils/generate_random_cordinates.dart';

class GamePage extends StatelessWidget {
  const GamePage({super.key});

  @override
  Widget build(BuildContext context) {
    final position = generateRandomCoordinate();

    return Scaffold(
      appBar: AppBar(title: const Text("Street View")),
      body: FlutterGoogleStreetView(
        // Aqui usamos o LatLng do flutter_google_street_view
        initPos: LatLng(-27.6345, -52.2730),
        streetNamesEnabled: true,
        userNavigationEnabled: true,
        zoomGesturesEnabled: true,
      ),
    );
  }
}
