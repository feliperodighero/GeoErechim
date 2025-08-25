import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapGuessPage extends StatefulWidget {
  final LatLng streetViewPosition;
  const MapGuessPage({super.key, required this.streetViewPosition});

  @override
  State<MapGuessPage> createState() => _MapGuessPageState();
}

class _MapGuessPageState extends State<MapGuessPage> {
  LatLng? guessPosition;
  late GoogleMapController mapController;

  void _onMapTap(LatLng pos) {
    setState(() {
      guessPosition = pos;
    });
  }

  void _confirmGuess() {
    if (guessPosition != null) {
      Navigator.pop(context, guessPosition);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF0E3321),
        foregroundColor: Colors.white,
      ),
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: LatLng(-27.638515, -52.272157),
              zoom: 14,
            ),
            onTap: _onMapTap,
            markers: guessPosition != null
                ? {Marker(markerId: const MarkerId('guess'), position: guessPosition!)}
                : {},
            onMapCreated: (controller) => mapController = controller,
          ),
          Positioned(
            bottom: 20,
            left: 80,
            right: 90,
            child: ElevatedButton(
              onPressed: _confirmGuess,
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: const Color(0xF01F6F3F),
                padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 32),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              ),
              child: const Text(
                "Palpitar",
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                  fontFamily: 'Lilita One',
                  fontStyle: FontStyle.normal,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
