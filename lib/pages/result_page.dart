import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geoerechim/providers/game_state.dart';
import 'package:geoerechim/utils/calculate_distance.dart';
import 'package:geoerechim/utils/calculate_stars.dart';
import 'package:geoerechim/utils/calculate_zoom_map.dart';
import 'package:percent_indicator/percent_indicator.dart';

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
    final double distance = calculateDistance(
      streetViewPosition,
      guessedPosition,
    );
    final int stars = calculateStars(distance);

    final double percent = (points / 5000).clamp(0.0, 1.0);

    return Scaffold(
      backgroundColor: const Color(0xFF0E3321),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0E3321),
        foregroundColor: Colors.white,
        title: const Text(
          "Tua pontuação, tchê!",
          style: TextStyle(
            color: Colors.white,
            fontFamily: 'Lilita One',
            fontSize: 32,
          ),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Card(
              color: const Color(0xF01F6F3F),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              elevation: 6,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    const Text(
                      "Resumo da Rodada",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),

                    const SizedBox(height: 15),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        CircularPercentIndicator(
                          radius: 70.0,
                          lineWidth: 10.0,
                          percent: percent,
                          progressColor: const Color(0xFFFFD700),
                          backgroundColor: Colors.white24,
                          circularStrokeCap: CircularStrokeCap.round,
                          center: Text(
                            "$points\n/ 5000",
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFFFFD700),
                            ),
                          ),
                        ),

                        Column(
                          children: [
                            Row(
                              children: List.generate(5, (index) {
                                return Icon(
                                  index < stars
                                      ? Icons.star
                                      : Icons.star_border,
                                  color: const Color(0xFFFFD700),
                                  size: 30,
                                );
                              }),
                            ),

                            const SizedBox(height: 10),
                            Consumer<GameState>(
                              builder: (context, gameState, _) {
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Rodada: ${gameState.currentRound}/${gameState.maxRounds}",
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 14,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      "Total de Pontos: ${gameState.totalPoints}",
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                );
                              },
                            ),
                          ],
                        ),
                      ],
                    ),

                    const Divider(
                      color: Colors.white30,
                      height: 30,
                      thickness: 1,
                      indent: 10,
                      endIndent: 10,
                    ),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.place, color: Colors.white, size: 20),
                        const SizedBox(width: 6),
                        Text(
                          distance >= 1000
                              ? "${(distance / 1000).toStringAsFixed(1)} km do ponto correto"
                              : "${distance.toStringAsFixed(0)} m do ponto correto",
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: GoogleMap(
                  initialCameraPosition: CameraPosition(
                    target: LatLng(
                      (streetViewPosition.latitude + guessedPosition.latitude) /
                          2,
                      (streetViewPosition.longitude +
                              guessedPosition.longitude) /
                          2,
                    ),
                    zoom: calculateZoom(distance),
                  ),
                  markers: {
                    Marker(
                      markerId: const MarkerId('correct'),
                      position: streetViewPosition,
                      icon: BitmapDescriptor.defaultMarkerWithHue(
                        BitmapDescriptor.hueRed,
                      ),
                      infoWindow: const InfoWindow(title: 'Local Correto'),
                    ),
                    Marker(
                      markerId: const MarkerId('guess'),
                      position: guessedPosition,
                      icon: AssetMapBitmap(
                        'lib/assets/images/personPin.png',
                        bitmapScaling: MapBitmapScaling.auto,
                        width: 45,
                      ),
                      infoWindow: const InfoWindow(title: 'Seu Palpite'),
                    ),
                  },
                  polylines: {
                    Polyline(
                      polylineId: const PolylineId('distance'),
                      points: [streetViewPosition, guessedPosition],
                      color: Colors.red,
                      width: 3,
                      patterns: [PatternItem.dash(20), PatternItem.gap(10)],
                    ),
                  },
                  zoomControlsEnabled: false,
                  mapToolbarEnabled: false,
                ),
              ),
            ),

            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: () {
                Provider.of<GameState>(context, listen: false).addRoundPoints(points);
                Navigator.pop(context, true);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xF01F6F3F),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 40,
                  vertical: 15,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                elevation: 3,
              ),
              child: const Text(
                "Próxima Rodada",
                style: TextStyle(
                  fontSize: 20,
                  fontFamily: 'Lilita One',
                  fontStyle: FontStyle.normal,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
