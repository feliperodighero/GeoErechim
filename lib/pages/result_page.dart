import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geoerechim/utils/calculate_distance.dart';
import 'package:geoerechim/utils/calculate_stars.dart';
import 'package:geoerechim/utils/calculate_zoom_map.dart';

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

    return Scaffold(
      backgroundColor: const Color(0xFF0E3321),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0E3321),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Title
            const Text(
              "Sua Pontuação",
              style: TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),

            const SizedBox(height: 20),

            // Points display
            Text(
              "$points / 5000",
              style: const TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Color(0xFFFFD700),
              ),
            ),

            const SizedBox(height: 20),

            // Stars display
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(5, (index) {
                return Icon(
                  index < stars ? Icons.star : Icons.star_border,
                  color: const Color(0xFFFFD700),
                  size: 30,
                );
              }),
            ),

            const SizedBox(height: 30),
            Container(
              height: 300,
              margin: const EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.white,
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: GoogleMap(
                  initialCameraPosition: CameraPosition(
                    target: LatLng(
                      (streetViewPosition.latitude + guessedPosition.latitude) / 2,
                      (streetViewPosition.longitude + guessedPosition.longitude) / 2,
                    ),
                    zoom: calculateZoom(distance),
                  ),
                  markers: {
                    Marker(
                      markerId: const MarkerId('correct'),
                      position: streetViewPosition,
                      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
                      infoWindow: const InfoWindow(title: 'Local Correto'),
                    ),
                    Marker(
                      markerId: const MarkerId('guess'),
                      position: guessedPosition,
                      icon: AssetMapBitmap('lib/assets/images/personPin.png',  bitmapScaling: MapBitmapScaling.auto, width: 40),
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

            // Distance display
            RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                children: [
                  const TextSpan(
                    text: "Distância da Localização: ",
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                  TextSpan(
                    text: distance >= 1000
                        ? "${(distance / 1000).toStringAsFixed(1)} km"
                        : "${distance.toStringAsFixed(0)} m",
                    style: const TextStyle(
                      fontSize: 18,
                      color: Color(0xFFFFD700),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 40),

            // Next Round Button
            const Text(
              "Próxima rodada?",
              style: TextStyle(
                fontSize: 24,
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),

            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: () {
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
                "Próxima",
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
